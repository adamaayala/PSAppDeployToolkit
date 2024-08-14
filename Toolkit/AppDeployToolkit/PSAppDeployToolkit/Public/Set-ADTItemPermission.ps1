﻿function Set-ADTItemPermission
{
    <#

    .SYNOPSIS
    Allow you to easily change permissions on files or folders

    .DESCRIPTION
    Allow you to easily change permissions on files or folders for a given user or group.

    You can add, remove or replace permissions, set inheritance and propagation.

    .PARAMETER Path
    Path to the folder or file you want to modify (ex: C:\Temp)

    .PARAMETER User
    One or more user names (ex: BUILTIN\Users, DOMAIN\Admin) to give the permissions to. If you want to use SID, prefix it with an asterisk * (ex: *S-1-5-18)

    .PARAMETER Permission
    Permission or list of permissions to be set/added/removed/replaced. To see all the possible permissions go to 'http://technet.microsoft.com/fr-fr/library/ff730951.aspx'.

    Permission DeleteSubdirectoriesAndFiles does not apply to files.

    .PARAMETER PermissionType
    Sets Access Control Type of the permissions. Allowed options: Allow, Deny   Default: Allow

    .PARAMETER Inheritance
    Sets permission inheritance. Does not apply to files. Multiple options can be specified. Allowed options: ObjectInherit, ContainerInherit, None  Default: None

    None - The permission entry is not inherited by child objects, ObjectInherit - The permission entry is inherited by child leaf objects. ContainerInherit - The permission entry is inherited by child container objects.

    .PARAMETER Propagation
    Sets how to propagate inheritance. Does not apply to files. Allowed options: None, InheritOnly, NoPropagateInherit  Default: None

    None - Specifies that no inheritance flags are set. NoPropagateInherit - Specifies that the permission entry is not propagated to child objects. InheritOnly - Specifies that the permission entry is propagated only to child objects. This includes both container and leaf child objects.

    .PARAMETER Method
    Specifies which method will be used to apply the permissions. Allowed options: Add, Set, Reset.

    Add - adds permissions rules but it does not remove previous permissions, Set - overwrites matching permission rules with new ones, Reset - removes matching permissions rules and then adds permission rules, Remove - Removes matching permission rules, RemoveSpecific - Removes specific permissions, RemoveAll - Removes all permission rules for specified user/s
    Default: Add

    .PARAMETER EnableInheritance
    Enables inheritance on the files/folders.

    .INPUTS
    None. You cannot pipe objects to this function.

    .OUTPUTS
    None. This function does not return any objects.

    .EXAMPLE
    # Will grant FullControl permissions to 'John' and 'Users' on 'C:\Temp' and its files and folders children.
    Set-ADTItemPermission -Path 'C:\Temp' -User 'DOMAIN\John', 'BUILTIN\Utilisateurs' -Permission FullControl -Inheritance ObjectInherit,ContainerInherit

    .EXAMPLE
    # Will grant Read permissions to 'John' on 'C:\Temp\pic.png'
    Set-ADTItemPermission -Path 'C:\Temp\pic.png' -User 'DOMAIN\John' -Permission 'Read'

    .EXAMPLE
    # Will remove all permissions to 'John' on 'C:\Temp\Private'
    Set-ADTItemPermission -Path 'C:\Temp\Private' -User 'DOMAIN\John' -Permission 'None' -Method 'RemoveAll'

    .NOTES
    Original Author: Julian DA CUNHA - dacunha.julian@gmail.com, used with permission.

    .NOTES
    This function can be called without an active ADT session.

    .LINK
    https://psappdeploytoolkit.com

    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Path to the folder or file you want to modify (ex: C:\Temp)', ParameterSetName = 'DisableInheritance')]
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Path to the folder or file you want to modify (ex: C:\Temp)', ParameterSetName = 'EnableInheritance')]
        [ValidateScript({
            if (!(Test-Path -Path $_))
            {
                $PSCmdlet.ThrowTerminatingError((New-ADTValidateScriptErrorRecord -ParameterName Path -ProvidedValue $_ -ExceptionMessage 'The specified path does not exist.'))
            }
            return !!$_
        })]
        [Alias('File', 'Folder')]
        [System.String]$Path,

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'One or more user names (ex: BUILTIN\Users, DOMAIN\Admin). If you want to use SID, prefix it with an asterisk * (ex: *S-1-5-18)', ParameterSetName = 'DisableInheritance')]
        [Alias('Username', 'Users', 'SID', 'Usernames')]
        [ValidateNotNullOrEmpty()]
        [System.String[]]$User,

        [Parameter(Mandatory = $true, Position = 2, HelpMessage = "Permission or list of permissions to be set/added/removed/replaced. To see all the possible permissions go to 'http://technet.microsoft.com/fr-fr/library/ff730951.aspx'", ParameterSetName = 'DisableInheritance')]
        [Alias('Acl', 'Grant', 'Permissions', 'Deny')]
        [ValidateNotNullOrEmpty()]
        [System.Security.AccessControl.FileSystemRights]$Permission,

        [Parameter(Mandatory = $false, Position = 3, HelpMessage = 'Whether you want to set Allow or Deny permissions', ParameterSetName = 'DisableInheritance')]
        [Alias('AccessControlType')]
        [ValidateNotNullOrEmpty()]
        [System.Security.AccessControl.AccessControlType]$PermissionType = [System.Security.AccessControl.AccessControlType]::Allow,

        [Parameter(Mandatory = $false, Position = 4, HelpMessage = 'Sets how permissions are inherited', ParameterSetName = 'DisableInheritance')]
        [ValidateNotNullOrEmpty()]
        [System.Security.AccessControl.InheritanceFlags]$Inheritance = [System.Security.AccessControl.InheritanceFlags]::None,

        [Parameter(Mandatory = $false, Position = 5, HelpMessage = 'Sets how to propage inheritance flags', ParameterSetName = 'DisableInheritance')]
        [ValidateNotNullOrEmpty()]
        [System.Security.AccessControl.PropagationFlags]$Propagation = [System.Security.AccessControl.PropagationFlags]::None,

        [Parameter(Mandatory = $false, Position = 6, HelpMessage = 'Specifies which method will be used to add/remove/replace permissions.', ParameterSetName = 'DisableInheritance')]
        [ValidateSet('AddAccessRule', 'SetAccessRule', 'ResetAccessRule', 'RemoveAccessRule', 'RemoveAccessRuleSpecific', 'RemoveAccessRuleAll')]
        [Alias('ApplyMethod', 'ApplicationMethod')]
        [System.String]$Method = 'AddAccessRule',

        [Parameter(Mandatory = $true, Position = 1, HelpMessage = 'Enables inheritance, which removes explicit permissions.', ParameterSetName = 'EnableInheritance')]
        [System.Management.Automation.SwitchParameter]$EnableInheritance
    )

    begin
    {
        Initialize-ADTFunction -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    }

    process
    {
        try
        {
            try
            {
                # Test elevated permissions.
                if (!(Test-ADTCallerIsAdmin))
                {
                    Write-ADTLogEntry -Message 'Unable to use the function [Set-ADTItemPermission] without elevated permissions.' -Severity 3
                    $naerParams = @{
                        Exception = [System.UnauthorizedAccessException]::new('Unable to use the function [Set-ADTItemPermission] without elevated permissions.')
                        Category = [System.Management.Automation.ErrorCategory]::PermissionDenied
                        ErrorId = 'CallerNotLocalAdmin'
                        RecommendedAction = "Please review the executing user's permissions or the supplied config and try again."
                    }
                    throw (New-ADTErrorRecord @naerParams)
                }

                # Get object ACLs and enable inheritance.
                if ($EnableInheritance)
                {
                    ($Acl = Get-Acl -Path $Path).SetAccessRuleProtection($false, $true)
                    Write-ADTLogEntry -Message "Enabling Inheritance on path [$Path]."
                    [System.Void](Set-Acl -Path $Path -AclObject $Acl)
                    return
                }

                # Modify variables to remove file incompatible flags if this is a file.
                if (Test-Path -LiteralPath $Path -PathType Leaf)
                {
                    $Permission = $Permission -band (-bnot [System.Security.AccessControl.FileSystemRights]::DeleteSubdirectoriesAndFiles)
                    $Inheritance = [System.Security.AccessControl.InheritanceFlags]::None
                    $Propagation = [System.Security.AccessControl.PropagationFlags]::None
                }

                # Get object ACLs, disable inheritance but preserve inherited permissions.
                ($Acl = Get-Acl -Path $Path).SetAccessRuleProtection($true, $true)
                [System.Void](Set-Acl -Path $Path -AclObject $Acl)

                # Get updated ACLs - without inheritance.
                $Acl = Get-Acl -Path $Path

                # Apply permissions on each user.
                foreach ($U in $User.Trim().Where({$_.Length}))
                {
                    # Set Username.
                    [System.Security.Principal.NTAccount]$Username = if ($U.StartsWith('*'))
                    {
                        try
                        {
                            # Translate the SID.
                            ConvertTo-ADTNTAccountOrSID -SID ($U = $U.Remove(0, 1))
                        }
                        catch
                        {
                            Write-ADTLogEntry "Failed to translate SID [$U]. Skipping..." -Severity 2
                            continue
                        }
                    }
                    else
                    {
                        $U
                    }

                    # Set/Add/Remove/Replace permissions and log the changes.
                    Write-ADTLogEntry -Message "Changing permissions [Permissions:$Permission, InheritanceFlags:$Inheritance, PropagationFlags:$Propagation, AccessControlType:$PermissionType, Method:$Method] on path [$Path] for user [$Username]."
                    $Acl.$Method([System.Security.AccessControl.FileSystemAccessRule]::new($Username, $Permission, $Inheritance, $Propagation, $PermissionType))
                }

                # Use the prepared ACL.
                [System.Void](Set-Acl -Path $Path -AclObject $Acl)
            }
            catch
            {
                Write-Error -ErrorRecord $_
            }
        }
        catch
        {
            Invoke-ADTFunctionErrorHandler -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState -ErrorRecord $_
        }
    }

    end
    {
        Complete-ADTFunction -Cmdlet $PSCmdlet
    }
}