﻿function Show-ADTBalloonTip
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
    Show-ADTBalloonTip -BalloonTipText 'Installation Started' -BalloonTipTitle 'Application Name'

    .EXAMPLE
    Show-ADTBalloonTip -BalloonTipIcon 'Info' -BalloonTipText 'Installation Started' -BalloonTipTitle 'Application Name' -BalloonTipTime 1000

    .NOTES
    For Windows 10 OS and above a Toast notification is displayed in place of a balloon tip if toast notifications are enabled in the XML config file.

    .LINK
    https://psappdeploytoolkit.com

    #>

    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [System.String]$BalloonTipText,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.String]$BalloonTipTitle = (Get-ADTSession).GetPropertyValue('InstallTitle'),

        [Parameter(Mandatory = $false)]
        [ValidateSet('Error', 'Info', 'None', 'Warning')]
        [System.Windows.Forms.ToolTipIcon]$BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.UInt32]$BalloonTipTime = 10000,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]$NoWait
    )

    begin {
        $adtSession = Get-ADTSession
        Write-ADTDebugHeader
    }

    process {
        # Skip balloon if in silent mode, disabled in the config or presentation is detected.
        if ($adtSession.DeployModeSilent -or !$Script:ADT.Config.UI.BalloonNotifications)
        {
            Write-ADTLogEntry -Message "Bypassing Show-ADTBalloonTip [Mode:$($adtSession.GetPropertyValue('deployMode')), Config Show Balloon Notifications:$($Script:ADT.Config.UI.BalloonNotifications)]. BalloonTipText:$BalloonTipText"
            return
        }
        if (Test-ADTPowerPoint)
        {
            Write-ADTLogEntry -Message "Bypassing Show-ADTBalloonTip [Mode:$($adtSession.GetPropertyValue('deployMode')), Presentation Detected:$true]. BalloonTipText:$BalloonTipText"
            return
        }

        # Dispose of previous balloon.
        Reset-ADTNotifyIcon

        # Do a balloon tip if we're on an old OS or toast notifications are disabled.
        if (($Script:ADT.Environment.envOSVersionMajor -lt 10) -or $Script:ADT.Config.Toast.Disable)
        {
            # Create in separate process if -NoWait is passed.
            if ($NoWait)
            {
                Write-ADTLogEntry -Message "Displaying balloon tip notification asynchronously with message [$BalloonTipText]."
                Execute-Process -Path $Script:ADT.Environment.envPSProcessPath -Parameters "-NonInteractive -NoProfile -NoLogo -WindowStyle Hidden -Command Add-Type -AssemblyName System.Windows.Forms, System.Drawing; ([System.Windows.Forms.NotifyIcon]@{BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::$BalloonTipIcon; BalloonTipText = '$($BalloonTipText.Replace("'","''"))'; BalloonTipTitle = '$($BalloonTipTitle.Replace("'","''"))'; Icon = [System.Drawing.Icon]::new('$($Script:ADT.Config.Assets.Icon)'); Visible = `$true}).ShowBalloonTip($BalloonTipTime); [System.Threading.Thread]::Sleep($BalloonTipTime)" -NoWait -WindowStyle Hidden -CreateNoWindow
                return
            }
            Write-ADTLogEntry -Message "Displaying balloon tip notification with message [$BalloonTipText]."
            ($Script:FormData.NotifyIcon = [System.Windows.Forms.NotifyIcon]@{BalloonTipIcon = $BalloonTipIcon; BalloonTipText = $BalloonTipText; BalloonTipTitle = $BalloonTipTitle; Icon = $Script:FormData.Assets.Icon; Visible = $true}).ShowBalloonTip($BalloonTipTime)
        }
        else
        {
            # Define script block for toast notifications, pre-injecting variables and values.
            $toastScriptBlock = [System.Management.Automation.ScriptBlock]::Create($ExecutionContext.InvokeCommand.ExpandString({
                # Ensure script runs in strict mode since its in a new scope.
                (Get-Variable -Name ErrorActionPreference).Value = [System.Management.Automation.ActionPreference]::Stop
                (Get-Variable -Name ProgressPreference).Value = [System.Management.Automation.ActionPreference]::SilentlyContinue
                Set-StrictMode -Version 3

                # Add in required assemblies.
                if ((Get-Variable -Name PSVersionTable -ValueOnly).PSEdition.Equals('Core'))
                {
                    Add-Type -AssemblyName (Get-ChildItem -Path '$($Script:PSScriptRoot)\lib\*\*.dll').FullName
                }
                else
                {
                    [System.Void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
                    [System.Void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
                }

                # Configure the notification centre.
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$($Script:ADT.Environment.appDeployToolkitName)', 'ShowInActionCenter', 1, 'DWord')
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$($Script:ADT.Environment.appDeployToolkitName)', 'Enabled', 1, 'DWord')
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$($Script:ADT.Environment.appDeployToolkitName)', 'SoundFile', '', 'String')

                # Configure the toast notification.
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Classes\AppUserModelId\$($Script:ADT.Environment.appDeployToolkitName)', 'DisplayName', '$($Script:ADT.Config.Toast.AppName)', 'String')
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Classes\AppUserModelId\$($Script:ADT.Environment.appDeployToolkitName)', 'ShowInSettings', 0, 'DWord')
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Classes\AppUserModelId\$($Script:ADT.Environment.appDeployToolkitName)', 'IconUri', '$($Script:ADT.Config.Assets.Logo)', 'ExpandString')
                [Microsoft.Win32.Registry]::SetValue('HKEY_CURRENT_USER\Software\Classes\AppUserModelId\$($Script:ADT.Environment.appDeployToolkitName)', 'IconBackgroundColor', '', 'ExpandString')

                # Build out toast XML and display it.
                (New-Variable -Name toastXml -Value ([Windows.Data.Xml.Dom.XmlDocument]::new()) -PassThru).Value.LoadXml('<toast launch="app-defined-string"><visual><binding template="ToastImageAndText02"><text id="1">$BalloonTipTitle</text><text id="2">$BalloonTipText</text><image id="1" src="file://$($Script:ADT.Config.Assets.Logo)" /></binding></visual></toast>')
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('$($Script:ADT.Environment.appDeployToolkitName)').Show((Get-Variable -Name toastXml -ValueOnly))
            }))

            # If we're running as the active user, display directly; otherwise, run via Execute-ProcessAsUser.
            if ($Script:ADT.Environment.ProcessNTAccount -eq $Script:ADT.Environment.runAsActiveUser.NTAccount)
            {
                Write-ADTLogEntry -Message "Displaying toast notification with message [$BalloonTipText]."
                & $toastScriptBlock
            }
            else
            {
                Write-ADTLogEntry -Message "Displaying toast notification with message [$BalloonTipText] using Execute-ProcessAsUser."
                Execute-ProcessAsUser -Path $Script:ADT.Environment.envPSProcessPath -Parameters "-NonInteractive -NoProfile -NoLogo -WindowStyle Hidden -EncodedCommand $([System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes([System.String]::Join("`n", $toastScriptBlock.ToString().Trim().Split("`n").Trim()))))" -Wait -RunLevel LeastPrivilege
            }
        }
    }

    end {
        Write-ADTDebugFooter
    }
}