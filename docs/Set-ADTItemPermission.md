---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Set-ADTItemPermission

## SYNOPSIS
Allows you to easily change permissions on files or folders.

## SYNTAX

### EnableInheritance
```
Set-ADTItemPermission [-Path] <String> [-EnableInheritance] [<CommonParameters>]
```

### DisableInheritance
```
Set-ADTItemPermission [-Path] <String> [-User] <String[]> [-Permission] <FileSystemRights>
 [[-PermissionType] <AccessControlType>] [[-Inheritance] <InheritanceFlags>]
 [[-Propagation] <PropagationFlags>] [[-Method] <String>] [<CommonParameters>]
```

## DESCRIPTION
Allows you to easily change permissions on files or folders for a given user or group.
You can add, remove or replace permissions, set inheritance and propagation.

## EXAMPLES

### EXAMPLE 1
```
Set-ADTItemPermission -Path 'C:\Temp' -User 'DOMAIN\John', 'BUILTIN\Users' -Permission FullControl -Inheritance ObjectInherit,ContainerInherit
```

Will grant FullControl permissions to 'John' and 'Users' on 'C:\Temp' and its files and folders children.

### EXAMPLE 2
```
Set-ADTItemPermission -Path 'C:\Temp\pic.png' -User 'DOMAIN\John' -Permission 'Read'
```

Will grant Read permissions to 'John' on 'C:\Temp\pic.png'.

### EXAMPLE 3
```
Set-ADTItemPermission -Path 'C:\Temp\Private' -User 'DOMAIN\John' -Permission 'None' -Method 'RemoveAll'
```

Will remove all permissions to 'John' on 'C:\Temp\Private'.

## PARAMETERS

### -Path
Path to the folder or file you want to modify (ex: C:\Temp)

```yaml
Type: String
Parameter Sets: (All)
Aliases: File, Folder

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
One or more user names (ex: BUILTIN\Users, DOMAIN\Admin) to give the permissions to.
If you want to use SID, prefix it with an asterisk * (ex: *S-1-5-18)

```yaml
Type: String[]
Parameter Sets: DisableInheritance
Aliases: Username, Users, SID, Usernames

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Permission
Permission or list of permissions to be set/added/removed/replaced.
To see all the possible permissions go to 'http://technet.microsoft.com/fr-fr/library/ff730951.aspx'.

Permission DeleteSubdirectoriesAndFiles does not apply to files.

```yaml
Type: FileSystemRights
Parameter Sets: DisableInheritance
Aliases: Acl, Grant, Permissions, Deny
Accepted values: ListDirectory, ReadData, WriteData, CreateFiles, CreateDirectories, AppendData, ReadExtendedAttributes, WriteExtendedAttributes, Traverse, ExecuteFile, DeleteSubdirectoriesAndFiles, ReadAttributes, WriteAttributes, Write, Delete, ReadPermissions, Read, ReadAndExecute, Modify, ChangePermissions, TakeOwnership, Synchronize, FullControl

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PermissionType
Sets Access Control Type of the permissions.
Allowed options: Allow, Deny

```yaml
Type: AccessControlType
Parameter Sets: DisableInheritance
Aliases: AccessControlType
Accepted values: Allow, Deny

Required: False
Position: 4
Default value: Allow
Accept pipeline input: False
Accept wildcard characters: False
```

### -Inheritance
Sets permission inheritance.
Does not apply to files.
Multiple options can be specified.
Allowed options: ObjectInherit, ContainerInherit, None

None - The permission entry is not inherited by child objects, ObjectInherit - The permission entry is inherited by child leaf objects.
ContainerInherit - The permission entry is inherited by child container objects.

```yaml
Type: InheritanceFlags
Parameter Sets: DisableInheritance
Aliases:
Accepted values: None, ContainerInherit, ObjectInherit

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Propagation
Sets how to propagate inheritance.
Does not apply to files.
Allowed options: None, InheritOnly, NoPropagateInherit

None - Specifies that no inheritance flags are set.
NoPropagateInherit - Specifies that the permission entry is not propagated to child objects.
InheritOnly - Specifies that the permission entry is propagated only to child objects.
This includes both container and leaf child objects.

```yaml
Type: PropagationFlags
Parameter Sets: DisableInheritance
Aliases:
Accepted values: None, NoPropagateInherit, InheritOnly

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
Specifies which method will be used to apply the permissions.
Allowed options: Add, Set, Reset.

Add - adds permissions rules but it does not remove previous permissions, Set - overwrites matching permission rules with new ones, Reset - removes matching permissions rules and then adds permission rules, Remove - Removes matching permission rules, RemoveSpecific - Removes specific permissions, RemoveAll - Removes all permission rules for specified user/s

```yaml
Type: String
Parameter Sets: DisableInheritance
Aliases: ApplyMethod, ApplicationMethod

Required: False
Position: 7
Default value: AddAccessRule
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableInheritance
Enables inheritance on the files/folders.

```yaml
Type: SwitchParameter
Parameter Sets: EnableInheritance
Aliases:

Required: True
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
### You cannot pipe objects to this function.
## OUTPUTS

### None
### This function does not return any output.
## NOTES
An active ADT session is NOT required to use this function.

Original Author: Julian DA CUNHA - dacunha.julian@gmail.com, used with permission.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
