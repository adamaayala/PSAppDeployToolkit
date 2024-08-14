﻿function Show-ADTBalloonTipFluent
{
    <#

    .SYNOPSIS
    Displays a balloon tip notification in the system tray.

    .DESCRIPTION
    Displays a balloon tip notification in the system tray.

    .PARAMETER BalloonTipText
    Text of the balloon tip.

    .PARAMETER BalloonTipTitle
    Title of the balloon tip.

    .PARAMETER BalloonTipIcon
    Icon to be used. Options: 'Error', 'Info', 'None', 'Warning'. Default is: Info.

    .PARAMETER BalloonTipTime
    Time in milliseconds to display the balloon tip. Default: 10000.

    .PARAMETER NoWait
    Create the balloontip asynchronously. Default: $false

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    System.String. Returns the version of the specified file.

    .EXAMPLE
    Show-ADTBalloonTipFluent -BalloonTipText 'Installation Started' -BalloonTipTitle 'Application Name'

    .EXAMPLE
    Show-ADTBalloonTipFluent -BalloonTipIcon 'Info' -BalloonTipText 'Installation Started' -BalloonTipTitle 'Application Name' -BalloonTipTime 1000

    .LINK
    https://psappdeploytoolkit.com

    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.String]$BalloonTipText,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.String]$BalloonTipTitle,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Error', 'Info', 'None', 'Warning')]
        [System.Windows.Forms.ToolTipIcon]$BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.UInt32]$BalloonTipTime = 10000,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$NoWait
    )

    # Define internal worker function.
    function New-ADTToastNotification
    {
        [CmdletBinding()]
        param
        (
            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$ToolkitName,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$ModuleBase,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$ToastName,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$ToastLogo,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$ToastTitle,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullOrEmpty()]
            [System.String]$ToastText
        )

        # Ensure script runs in strict mode since this may be called in a new scope.
        $ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop
        $ProgressPreference = [System.Management.Automation.ActionPreference]::SilentlyContinue
        Set-StrictMode -Version 3

        # Add in required assemblies.
        if ($PSVersionTable.PSEdition.Equals('Core'))
        {
            Add-Type -AssemblyName (Get-ChildItem -Path $ModuleBase\lib\net6.0\*.dll).FullName
        }
        else
        {
            [System.Void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
            [System.Void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
        }

        # Configure the notification centre.
        $regPath = 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings'
        Remove-Item -LiteralPath "Registry::$regPath\$ToolkitName" -Force -Confirm:$false -ErrorAction Ignore
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'ShowInActionCenter', 1, [Microsoft.Win32.RegistryValueKind]::DWord)
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'Enabled', 1, [Microsoft.Win32.RegistryValueKind]::DWord)
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'SoundFile', [System.String]::Empty, [Microsoft.Win32.RegistryValueKind]::String)

        # Configure the toast notification.
        $regPath = 'HKEY_CURRENT_USER\Software\Classes\AppUserModelId'
        Remove-Item -LiteralPath "Registry::$regPath\$ToolkitName" -Force -Confirm:$false -ErrorAction Ignore
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'DisplayName', $ToastName, [Microsoft.Win32.RegistryValueKind]::String)
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'ShowInSettings', 0, [Microsoft.Win32.RegistryValueKind]::DWord)
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'IconUri', $ToastLogo, [Microsoft.Win32.RegistryValueKind]::ExpandString)
        [Microsoft.Win32.Registry]::SetValue("$regPath\$ToolkitName", 'IconBackgroundColor', [System.String]::Empty, [Microsoft.Win32.RegistryValueKind]::ExpandString)

        # Build out toast XML and display it.
        $toastXml = [Windows.Data.Xml.Dom.XmlDocument]::new()
        $toastXml.LoadXml("<toast launch=`"app-defined-string`"><visual><binding template=`"ToastImageAndText02`"><text id=`"1`">$([System.Security.SecurityElement]::Escape($ToastTitle))</text><text id=`"2`">$([System.Security.SecurityElement]::Escape($ToastText))</text><image id=`"1`" src=`"file://$ToastLogo`" /></binding></visual></toast>")
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($ToolkitName).Show($toastXml)
    }

    # Initialise variables.
    $adtEnv = Get-ADTEnvironment
    $adtConfig = Get-ADTConfig

    # Build out parameters for internal worker function.
    $natnParams = [ordered]@{
        ToolkitName = $adtEnv.appDeployToolkitName
        ModuleBase = $Script:PSScriptRoot
        ToastName = $adtConfig.UI.ToastName
        ToastLogo = $adtConfig.Assets.Logo
        ToastTitle = $BalloonTipTitle
        ToastText = $BalloonTipText
    }

    # If we're running as the active user, display directly; otherwise, run via Execute-ProcessAsUser.
    if ($adtEnv.ProcessNTAccount -ne $adtEnv.runAsActiveUser.NTAccount)
    {
        Write-ADTLogEntry -Message "Displaying toast notification with message [$BalloonTipText] using Execute-ProcessAsUser."
        Execute-ProcessAsUser -Path $adtEnv.envPSProcessPath -Parameters "-NonInteractive -NoProfile -NoLogo -WindowStyle Hidden -EncodedCommand $(Out-ADTPowerShellEncodedCommand -Command "& {${Function:New-ADTToastNotification}} $(($natnParams | Resolve-ADTBoundParameters).Replace('"', '\"'))")" -Wait -RunLevel LeastPrivilege
        return
    }
    Write-ADTLogEntry -Message "Displaying toast notification with message [$BalloonTipText]."
    New-ADTToastNotification @natnParams
}