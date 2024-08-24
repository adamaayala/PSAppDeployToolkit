---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Remove-ADTInvalidFileNameChars

## SYNOPSIS
Remove invalid characters from the supplied string.

## SYNTAX

```
Remove-ADTInvalidFileNameChars [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
This function removes invalid characters from the supplied string and returns a valid filename as a string.
It ensures that the resulting string does not contain any characters that are not allowed in filenames.
This function should not be used for entire paths as '\' is not a valid filename character.

## EXAMPLES

### EXAMPLE 1
```
Remove-ADTInvalidFileNameChars -Name "Filename/\1"
```

Removes invalid filename characters from the string "Filename/\1".

## PARAMETERS

### -Name
Text to remove invalid filename characters from.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### A string containing invalid filename characters.
## OUTPUTS

### System.String
### Returns the input string with the invalid characters removed.
## NOTES
An active ADT session is NOT required to use this function.

This function always returns a string; however, it can be empty if the name only contains invalid characters.
Do not use this command for an entire path as '\' is not a valid filename character.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
