function Set-FileDates {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory=$true)]
        [string]$arg1,

        [Parameter(Mandatory=$true)]
        [string]$arg2
    )

    # Check if arg1 and arg2 are files
    if ($PSCmdlet.ShouldProcess("$arg1", "Set file dates")) {
        if ((Test-Path $arg1 -PathType Leaf) -and (Test-Path $arg2 -PathType Leaf)) {
            $file1 = Get-Item $arg1
            $file2 = Get-Item $arg2

            if ($AlignToLastWrite) {
                # Set the CreationTime and LastWriteTime of file1 to the LastWriteTime of file2
                $file1.CreationTime = $file2.LastWriteTime
                $file1.LastWriteTime = $file2.LastWriteTime
                Write-Verbose "Aligned CreationTime and LastWriteTime of $file1 to LastWriteTime of $file2"
            } else {
                # Set the CreationTime and LastWriteTime of file1 to the CreationTime and LastWriteTime of file2
                $file1.CreationTime = $file2.CreationTime
                $file1.LastWriteTime = $file2.LastWriteTime
                Write-Verbose "Set CreationTime and LastWriteTime of $file1 to CreationTime and LastWriteTime of $file2"
            }
        }
        # Check if arg2 is a datetime or ISO string
        else {
            # Added a variable to hold the parsed datetime
            $date = $null
            # Changed the TryParse method call to use the $date variable as [ref]
            if ([datetime]::TryParse($arg2, [ref]$date)) {
                $file1 = Get-Item $arg1

                # Set the CreationTime and LastWriteTime of file1 to the specified date
                $file1.CreationTime = $date
                $file1.LastWriteTime = $date
            }
            else {
                Write-Error "arg2 must be a valid file path or a datetime/ISO string."
            }
        }
    }
}