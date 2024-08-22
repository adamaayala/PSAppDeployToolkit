---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Remove-ADTContentFromCache

## SYNOPSIS
Removes the toolkit content from the cache folder on the local machine and reverts the $dirFiles and $supportFiles directory.

## SYNTAX

```
Remove-ADTContentFromCache [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
This function removes the toolkit content from the cache folder on the local machine.
It also reverts the $dirFiles and $supportFiles directory to their original state.
If the specified cache folder does not exist, it logs a message and exits.

## EXAMPLES

### EXAMPLE 1
```
Remove-ADTContentFromCache -Path 'C:\Windows\Temp\PSAppDeployToolkit'
```

Removes the toolkit content from the specified cache folder.

## PARAMETERS

### -Path
The path to the software cache folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$((Get-ADTConfig).Toolkit.CachePath)\$((Get-ADTSession).GetPropertyValue('installName'))"
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
### This function does not return objects.
## NOTES
An active ADT session is required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
