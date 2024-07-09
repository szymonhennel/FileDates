function Set-FileDates {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Target,

        [Parameter(Mandatory=$true)]
        [string]$Source,

        [Parameter(Mandatory=$false)]
        [switch]$AlignToLastWrite
    )

    if (Test-Path $Target -PathType Leaf) {
        if (Test-Path $Source -PathType Leaf) {
            $target_file = Get-Item $Target
            $source_file = Get-Item $Source

            if ($AlignToLastWrite) {
                # Set the CreationTime and LastWriteTime of target_file to the LastWriteTime of source_file
                if ($PSCmdlet.ShouldProcess("$Target", "Set CreationTime and LastWriteTime equal to LastWriteTime of $source_file")) {
                    $target_file.CreationTime = $source_file.LastWriteTime
                    $target_file.LastWriteTime = $source_file.LastWriteTime
                    Write-Verbose "Aligned CreationTime and LastWriteTime of $target_file to LastWriteTime of $source_file"
                }
            } else {
                # Set the CreationTime and LastWriteTime of target_file to the CreationTime and LastWriteTime of source_file
                if ($PSCmdlet.ShouldProcess("$Target", "Set CreationTime and LastWriteTime equal to CreationTime and LastWriteTime of $source_file")) {
                    $target_file.CreationTime = $source_file.CreationTime
                    $target_file.LastWriteTime = $source_file.LastWriteTime
                    Write-Verbose "Set CreationTime and LastWriteTime of $target_file to CreationTime and LastWriteTime of $source_file"
                }
            }
        }
        # Check if Source is a datetime or ISO string
        else {
            # Try to parse Source as a datetime
            try {
                $date = [datetime]::Parse($Source)
                $target_file = Get-Item $Target

                # Set the CreationTime and LastWriteTime of target_file to the specified date
                if ($PSCmdlet.ShouldProcess("$Target", "Set CreationTime and LastWriteTime equal to $date")) {
                    $target_file.CreationTime = $date
                    $target_file.LastWriteTime = $date
                    Write-Verbose "Set CreationTime and LastWriteTime of $target_file to $date"
                }
            }
            catch {
                Write-Error "Source must be a valid file path or a datetime/ISO string."
            }
        }
    } else {
        Write-Error "Target must be a valid file path."
    }
}