﻿Function Enable-TerminalServerInstallMode {
    <#
.SYNOPSIS

Changes to user install mode for Remote Desktop Session Host/Citrix servers.

.DESCRIPTION

Changes to user install mode for Remote Desktop Session Host/Citrix servers.

.PARAMETER ContinueOnError

Continue if an error is encountered. Default is: $true.

.INPUTS

None

You cannot pipe objects to this function.

.OUTPUTS

None

This function does not return any objects.

.EXAMPLE

Enable-TerminalServerInstallMode

.NOTES

.LINK

https://psappdeploytoolkit.com
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullorEmpty()]
        [Boolean]$ContinueOnError = $true
    )

    Begin {
        Write-ADTDebugHeader
    }
    Process {
        Try {
            Write-ADTLogEntry -Message 'Changing terminal server into user install mode...'
            $terminalServerResult = & "$env:WinDir\System32\change.exe" User /Install

            If ($global:LastExitCode -ne 1) {
                Throw $terminalServerResult
            }
        }
        Catch {
            Write-ADTLogEntry -Message "Failed to change terminal server into user install mode. `r`n$(Resolve-Error) " -Severity 3
            If (-not $ContinueOnError) {
                Throw "Failed to change terminal server into user install mode: $($_.Exception.Message)"
            }
        }
    }
    End {
        Write-ADTDebugFooter
    }
}