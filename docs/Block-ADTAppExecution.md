---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Block-ADTAppExecution

## SYNOPSIS
Block the execution of an application(s).

## SYNTAX

```
Block-ADTAppExecution [-ProcessName] <String[]> [<CommonParameters>]
```

## DESCRIPTION
This function is called when you pass the -BlockExecution parameter to the Stop-RunningApplications function.
It does the following:

1. 
Makes a copy of this script in a temporary directory on the local machine.
2. 
Checks for an existing scheduled task from previous failed installation attempt where apps were blocked and if found, calls the Unblock-ADTAppExecution function to restore the original IFEO registry keys.
    This is to prevent the function from overriding the backup of the original IFEO options.
3. 
Creates a scheduled task to restore the IFEO registry key values in case the script is terminated uncleanly by calling the local temporary copy of this script with the parameter -CleanupBlockedApps.
4. 
Modifies the "Image File Execution Options" registry key for the specified process(s) to call this script with the parameter -ShowBlockedAppDialog.
5. 
When the script is called with those parameters, it will display a custom message to the user to indicate that execution of the application has been blocked while the installation is in progress.
    The text of this message can be customized in the XML configuration file.

## EXAMPLES

### EXAMPLE 1
```
Block-ADTAppExecution -ProcessName ('winword','excel')
```

This example blocks the execution of Microsoft Word and Excel.

## PARAMETERS

### -ProcessName
Name of the process or processes separated by commas.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
It is used when the -BlockExecution parameter is specified with the Show-ADTInstallationWelcome function to block applications.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
