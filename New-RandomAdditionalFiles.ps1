function New-RandomAdditionalFiles {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory,

        [Parameter(Mandatory=$true)]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$FileCount,

        [Parameter(Mandatory=$true)]
        [ValidatePattern("^\d+(\.\d+)?(KB|MB|GB)$")]
        [string]$TotalSize
    )

    # Convert TotalSize to bytes
    $sizeMultiplier = @{
        "KB" = 1KB
        "MB" = 1MB
        "GB" = 1GB
    }
    $sizeUnit = $TotalSize -replace '\d+(\.\d+)?'
    $sizeValue = [double]($TotalSize -replace '[^\d\.]')
    $TotalSizeBytes = [int64]($sizeValue * $sizeMultiplier[$sizeUnit])

    # Ensure the output directory exists
    if (!(Test-Path -Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory | Out-Null
    }

    # Special case for FileCount = 1
    if ($FileCount -eq 1) {
        $FileExtension = "bin" # Default extension for single file
        $FileName = "File_1.$FileExtension"
        $FilePath = Join-Path -Path $OutputDirectory -ChildPath $FileName

        # Generate file content in chunks to handle large files
        $ChunkSize = 1MB
        $Chunks = [math]::Floor($TotalSizeBytes / $ChunkSize)
        $RemainingBytes = $TotalSizeBytes % $ChunkSize

        $FileStream = [System.IO.File]::Create($FilePath)
        try {
            $Random = New-Object System.Random
            $Buffer = New-Object byte[] $ChunkSize

            for ($j = 1; $j -le $Chunks; $j++) {
                $Random.NextBytes($Buffer)
                $FileStream.Write($Buffer, 0, $Buffer.Length)
            }

            if ($RemainingBytes -gt 0) {
                $Buffer = New-Object byte[] $RemainingBytes
                $Random.NextBytes($Buffer)
                $FileStream.Write($Buffer, 0, $Buffer.Length)
            }
        } finally {
            $FileStream.Close()
        }
    } else {
        # Existing logic for multiple files
        $AverageFileSize = [math]::Ceiling($TotalSizeBytes / $FileCount)
        $MinFileSize = if ($AverageFileSize * 0.5 -ge 1KB) {
            [math]::Floor($AverageFileSize * 0.5)
        } else {
            1KB
        }
        $MaxFileSize = if ($AverageFileSize * 1.5 -lt 2GB - 1) {
            [math]::Ceiling($AverageFileSize * 1.5)
        } else {
            2GB - 1
        }

        # Ensure MinFileSize is less than MaxFileSize
        if ($MinFileSize -ge $MaxFileSize) {
            $MinFileSize = [math]::Floor($MaxFileSize * 0.5)
        }

        $GeneratedSize = [int64]0
        $FileExtensions = @("bin", "exe", "png", "txt", "jpg", "pdf", "docx", "xlsx")

        for ($i = 1; $i -le $FileCount; $i++) {
            $RemainingSize = $TotalSizeBytes - $GeneratedSize
            if ($RemainingSize -lt $MinFileSize) { break }

            $MaxAllowedSize = [math]::Min($MaxFileSize, $RemainingSize)
            $FileSize = [int64](Get-Random -Minimum $MinFileSize -Maximum $MaxAllowedSize)

            $FileExtension = $FileExtensions | Get-Random
            $FileName = "File_$i.$FileExtension"
            $FilePath = Join-Path -Path $OutputDirectory -ChildPath $FileName

            # Generate file content in chunks to handle large files
            $ChunkSize = 1MB
            $Chunks = [math]::Floor($FileSize / $ChunkSize)
            $RemainingBytes = $FileSize % $ChunkSize

            $FileStream = [System.IO.File]::Create($FilePath)
            try {
                $Random = New-Object System.Random
                $Buffer = New-Object byte[] $ChunkSize

                for ($j = 1; $j -le $Chunks; $j++) {
                    $Random.NextBytes($Buffer)
                    $FileStream.Write($Buffer, 0, $Buffer.Length)
                }

                if ($RemainingBytes -gt 0) {
                    $Buffer = New-Object byte[] $RemainingBytes
                    $Random.NextBytes($Buffer)
                    $FileStream.Write($Buffer, 0, $Buffer.Length)
                }
            } finally {
                $FileStream.Close()
            }

            $GeneratedSize += $FileSize
        }
    }
}