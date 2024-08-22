---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Set-ADTShortcut

## SYNOPSIS
Modifies a .lnk or .url type shortcut.

## SYNTAX

```
Set-ADTShortcut [-Path] <String> [-TargetPath <String>] [-Arguments <String>] [-IconLocation <String>]
 [-IconIndex <String>] [-Description <String>] [-WorkingDirectory <String>] [-WindowStyle <String>]
 [-RunAsAdmin] [-Hotkey <String>] [<CommonParameters>]
```

## DESCRIPTION
Modifies a shortcut - .lnk or .url file, with configurable options.
Only specify the parameters that you want to change.

## EXAMPLES

### EXAMPLE 1
```
Set-ADTShortcut -Path "$envCommonDesktop\Application.lnk" -TargetPath "$envProgramFiles\Application\application.exe"
```

Creates a shortcut on the All Users desktop named 'Application', targeted to '$envProgramFiles\Application\application.exe'.

## PARAMETERS

### -Path
Path to the shortcut to be changed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -TargetPath
Sets target path or URL that the shortcut launches.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Arguments
Sets the arguments used against the target path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconLocation
Sets location of the icon used for the shortcut.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconIndex
Sets the index of the icon.
Executables, DLLs, ICO files with multiple icons need the icon index to be specified.
This parameter is an Integer.
The first index is 0.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Sets the description of the shortcut as can be seen in the shortcut's properties.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkingDirectory
Sets working directory to be used for the target path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowStyle
Sets the shortcut's window style to be minimised, maximised, etc.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: DontChange
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunAsAdmin
Sets the shortcut to require elevated permissions to run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hotkey
Sets the hotkey to launch the shortcut, e.g.
"CTRL+SHIFT+F".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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
### This function does not generate any output.
## NOTES
An active ADT session is NOT required to use this function.
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0
https://psappdeploytoolkit.com

## RELATED LINKS