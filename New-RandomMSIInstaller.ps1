# Import required scripts
. ".\New-RandomName.ps1"
. ".\New-RandomIcon.ps1"
. ".\New-RandomAdditionalFiles.ps1"
. ".\New-RandomDescription.ps1"

function New-RandomMSIInstaller {
    param (
        [Parameter(Mandatory=$false, ParameterSetName="WithAdditionalFiles")]
        [ValidateNotNullOrEmpty()]
        [int]$NumberOfAdditionalFiles = 0,

        [Parameter(Mandatory=$false, ParameterSetName="WithAdditionalFiles")]
        [ValidatePattern("^\d+(\.\d+)?(KB|MB|GB)$")]
        [string]$TotalSizeOfAdditionalFiles,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$OutputDirectory
    )

    # Check if Output Directory exists, if not, create it
    if (!(Test-Path -Path filesystem::$OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory -Force
    }

    # Function to generate a random URL
    function Generate-RandomUrl {
        $domains = @("example.com", "mydomain.net", "randomsite.org", "fakeurl.io", "website.co")
        $domain = $domains[(Get-Random -Minimum 0 -Maximum $domains.Count)]
        return "https://$domain"
    }

    # Generate random product name, version, platform, and upgrade code
    $ProductName = New-RandomName -Type App
    $CompanyName = New-RandomName -Type Company
    $UpgradeCode = [Guid]::NewGuid().ToString()
    $Version = "{0}.{1}.{2}" -f (Get-Random -Minimum 1 -Maximum 10), (Get-Random -Minimum 0 -Maximum 9), (Get-Random -Minimum 0 -Maximum 99)
    $Platform = if (Get-Random -Minimum 0 -Maximum 2) { "x86" } else { "x64" }

    # Generate random URLs
    $BaseUrl = Generate-RandomUrl
    $HelpLink = "$BaseUrl/support"
    $AboutLink = "$BaseUrl/privacy"
    
    # Create an app-specific directory if it doesn't exist
    $AppOutputDir = Join-Path $OutputDirectory ($ProductName -Replace " ", "_")
    if (!(Test-Path -Path $AppOutputDir)) {
        New-Item -ItemType Directory -Path $AppOutputDir -Force
    }

    # Generate a random icon
    New-RandomIcon -Width 512 -Height 512 -OutputPath $AppOutputDir -IconName $ProductName
    $IconPath = Join-Path $AppOutputDir "$ProductName.png"
    
    # Create a simple text file to include in the installer
    $FilePath = Join-Path $AppOutputDir "readme.txt"
    "This is a sample file for $ProductName. Version: $Version" | Out-File -FilePath $FilePath

    # Create a random description for the app
    $Description = New-RandomDescription

    # Generate the installer
    $MsiFilePath = Join-Path $AppOutputDir "$ProductName.$Version.$Platform.msi"
    New-Installer -ProductName $ProductName -UpgradeCode $UpgradeCode -Manufacturer $CompanyName `
        -Version $Version -Platform $Platform -HelpLink $HelpLink -Description $Description -AboutLink $AboutLink -AddRemoveProgramsIcon $IconPath `
        -Content {
        New-InstallerDirectory -PredefinedDirectory "LocalAppDataFolder" -Content {
            New-InstallerDirectory -DirectoryName $ProductName -Content {
                New-InstallerFile -Source $FilePath
            }
        }
    } -OutputDirectory $AppOutputDir

    # Remove any non .MSI files from the output directory
    Get-ChildItem -Path $AppOutputDir -File | Where-Object { $_.Extension -notin ".msi", ".png" } | Remove-Item -Force

    if ($NumberOfAdditionalFiles -gt 0) {
        # Generate additional files for the app
        New-RandomAdditionalFiles -OutputDirectory $AppOutputDir -FileCount $NumberOfAdditionalFiles -TotalSize $TotalSizeOfAdditionalFiles
    }

    # Return an object with details
    return [PSCustomObject]@{
        ProductName = $ProductName
        Manufacturer = $CompanyName
        Version     = $Version
        Platform    = $Platform
        MsiFilePath = $MsiFilePath
        IconPath    = $IconPath
        HelpLink    = $HelpLink
        AboutLink   = $AboutLink
        Description = $Description
        AppOutputDir = $AppOutputDir
    }
}