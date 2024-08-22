---
external help file: PSAppDeployToolkit-help.xml
Module Name: PSAppDeployToolkit
online version: https://psappdeploytoolkit.com
schema: 2.0.0
---

# Write-ADTLogEntry

## SYNOPSIS
Write messages to a log file in CMTrace.exe compatible format or Legacy text file format.

## SYNTAX

```
Write-ADTLogEntry -Message <String[]> [-Severity <UInt32>] [-Source <String>] [-ScriptSection <String>]
 [[-LogType] <String>] [[-LogFileDirectory] <String>] [[-LogFileName] <String>] [-PassThru] [-DebugMessage]
 [<CommonParameters>]
```

## DESCRIPTION
Write messages to a log file in CMTrace.exe compatible format or Legacy text file format and optionally display in the console.
This function supports different severity levels and can be used to log debug messages if required.

## EXAMPLES

### EXAMPLE 1
```
Write-ADTLogEntry -Message "Installing patch MS15-031" -Source 'Add-Patch'
```

Writes a log entry indicating that patch MS15-031 is being installed.

### EXAMPLE 2
```
Write-ADTLogEntry -Message "Script is running on Windows 11" -Source 'Test-ValidOS'
```

Writes a log entry indicating that the script is running on Windows 11.

## PARAMETERS

### -Message
The message to write to the log file or output to the console.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Severity
Defines message type.
When writing to console or CMTrace.exe log format, it allows highlighting of message type.
Options: 0 = Success (highlighted in green), 1 = Information (default), 2 = Warning (highlighted in yellow), 3 = Error (highlighted in red)

```yaml
Type: UInt32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Source
The source of the message being logged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (& $Script:CommandTable.'Get-PSCallStack' | & { process { if (![System.String]::IsNullOrWhiteSpace($_.Command) -and ($_.Command -notmatch '^Write-(Log|ADTLogEntry)$')) { return $_.Command } } } | & $Script:CommandTable.'Select-Object' -First 1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptSection
The heading for the portion of the script that is being executed.
Default is: $installPhase.

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

### -LogType
Choose whether to write a CMTrace.exe compatible log file or a Legacy text log file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFileDirectory
Set the directory where the log file will be saved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFileName
Set the name of the log file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return the message that was passed to the function.

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

### -DebugMessage
Specifies that the message is a debug message.
Debug messages only get logged if -LogDebugMessage is set to $true.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
### The message to write to the log file or output to the console.
## OUTPUTS

### System.String[]
### This function returns the provided output if -PassThru is specified.
## NOTES
An active ADT session is NOT required to use this function.

Tags: psadt
Website: https://psappdeploytoolkit.com
Copyright: (c) 2024 PSAppDeployToolkit Team, licensed under LGPLv3
License: https://opensource.org/license/lgpl-3-0

## RELATED LINKS

[https://psappdeploytoolkit.com](https://psappdeploytoolkit.com)
