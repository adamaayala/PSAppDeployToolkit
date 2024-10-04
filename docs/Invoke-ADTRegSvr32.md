---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Invoke-ADTRegSvr32

## SYNOPSIS
Register or unregister a DLL file.

## SYNTAX

```
Invoke-ADTRegSvr32 [-FilePath] <String> [-Action] <String> [<CommonParameters>]
```

## DESCRIPTION
Register or unregister a DLL file using regsvr32.exe.
This function determines the bitness of the DLL file and uses the appropriate version of regsvr32.exe to perform the action.
It supports both 32-bit and 64-bit DLL files on corresponding operating systems.

## EXAMPLES

### EXAMPLE 1
```
Invoke-ADTRegSvr32 -FilePath "C:\Test\DcTLSFileToDMSComp.dll" -Action 'Register'
```

Registers the specified DLL file.

### EXAMPLE 2
```
Invoke-ADTRegSvr32 -FilePath "C:\Test\DcTLSFileToDMSComp.dll" -Action 'Unregister'
```

Unregisters the specified DLL file.

## PARAMETERS

### -FilePath
Path to the DLL file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Action
Specify whether to register or unregister the DLL.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
### This function does not return objects.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
