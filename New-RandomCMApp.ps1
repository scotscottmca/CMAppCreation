# Store the current working directory
$OriginalDirectory = (Get-Location).Path

try {
    # Import required scripts and modules
    . ".\New-RandomMsiInstaller.ps1"

    if (-not (Get-Module -ListAvailable -Name PSMI)) {
        # Try importing the module from the specified path
        $ModulePath = "$env:PROGRAMFILES\PowerShell\Modules\PSMSI"
        try {
            if (Test-Path -Path $ModulePath) {
                Import-Module -Name $ModulePath -ErrorAction Stop
            } else {
                throw "Module not found at $ModulePath"
            }
        } catch {
            # If the module doesn't exist or import fails, extract and copy it
            Expand-Archive -Path .\PSMI.zip -DestinationPath ".\PSMI" -Force > $null
            Copy-Item -Path ".\PSMI" -Destination "$env:PROGRAMFILES\PowerShell\Modules\PSMSI\0.0.3\" -Recurse -Force > $null
            Import-Module -Name "$env:PROGRAMFILES\PowerShell\Modules\PSMSI" -ErrorAction Stop
            Remove-Item -Path ".\PSMI" -Recurse -Force
        }
    } else {
        Import-Module -Name PSMI -ErrorAction Stop
    }

    <#
    .SYNOPSIS
    Creates random Microsoft System Center Configuration Manager (SCCM) applications with MSI installers, deployment types, and deployments.

    .DESCRIPTION
    The New-RandomCMApp function generates random Configuration Manager applications complete with MSI installers, 
    deployment types, content distribution, and application deployments. This tool is designed for testing and 
    lab environments to quickly populate Configuration Manager with realistic dummy applications.

    The function creates:
    - Random MSI installer packages with realistic metadata
    - Random application names, descriptions, and publishers
    - Random icons for each application
    - Configuration Manager applications with proper deployment types
    - Content distribution to distribution point groups
    - Application deployments to the "All Users" collection

    .PARAMETER OutputDirectory
    Specifies the UNC path where the MSI installer files and associated content will be created. 
    This must be a valid UNC path accessible by the Configuration Manager site server.
    Example: "\\server\share\CMApplications\DummyApps"

    .PARAMETER NumberOfApps
    Specifies the number of random applications to create. Each application will have its own 
    MSI installer, deployment type, and deployment.

    .PARAMETER NumberOfAdditionalFiles
    Optional. Specifies the number of additional files to create alongside each MSI installer.
    These files simulate supporting documentation, configuration files, or other content that 
    might be distributed with an application. Must be used with TotalSizeOfAdditionalFiles parameter.

    .PARAMETER TotalSizeOfAdditionalFiles
    Optional. Specifies the total size of all additional files to be created for each application.
    Accepts values in KB, MB, or GB format (e.g., "500MB", "1.5GB", "2048KB").
    Must be used with NumberOfAdditionalFiles parameter.

    .EXAMPLE
    New-RandomCMApp -OutputDirectory "\\sccmserver\sources$\Applications\TestApps" -NumberOfApps 5

    Creates 5 random Configuration Manager applications with MSI installers in the specified UNC path.

    .EXAMPLE
    New-RandomCMApp -OutputDirectory "\\pmpclabsccm\g$\cmapplications\DummyApplications" -NumberOfApps 10 -NumberOfAdditionalFiles 5 -TotalSizeOfAdditionalFiles "250MB"

    Creates 10 random Configuration Manager applications, each with 5 additional files totaling 250MB, 
    stored in the specified network location.

    .EXAMPLE
    New-RandomCMApp -OutputDirectory "\\fileserver\apps$\SCCM\RandomApps" -NumberOfApps 3 -NumberOfAdditionalFiles 15 -TotalSizeOfAdditionalFiles "1GB"

    Creates 3 random Configuration Manager applications, each with 15 additional files totaling 1GB of content.

    .INPUTS
    None. You cannot pipe objects to New-RandomCMApp.

    .OUTPUTS
    None. The function creates Configuration Manager applications and displays progress information to the console.

    .NOTES
    Prerequisites:
    - Configuration Manager Console must be installed
    - SMS_ADMIN_UI_PATH environment variable must be set
    - PowerShell execution policy must allow script execution
    - User must have appropriate permissions to create applications in Configuration Manager
    - PSMI module for creating MSI installers
    - Network access to the specified OutputDirectory

    The function automatically:
    - Imports the Configuration Manager PowerShell module
    - Connects to the Configuration Manager site
    - Creates content in the specified output directory
    - Distributes content to the first available distribution point group
    - Deploys applications to the "All Users" collection as Available deployments

    .LINK
    https://docs.microsoft.com/en-us/mem/configmgr/

    .ROLE
    Configuration Manager Administrator

    .FUNCTIONALITY
    Application Management, Content Distribution, Application Deployment
    #>
    function New-RandomCMApp {
        param (
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [ValidatePattern('^\\\\[\w\.-]+\\[\w\$\.-]+(\\[\w\.-]+)*$')]
            [string]$OutputDirectory,

            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string]$NumberOfApps,

            [Parameter(Mandatory=$false, ParameterSetName="WithAdditionalFiles")]
            [ValidateNotNullOrEmpty()]
            [int]$NumberOfAdditionalFiles = 0,

            [Parameter(Mandatory=$false, ParameterSetName="WithAdditionalFiles")]
            [ValidatePattern("^\d+(\.\d+)?(KB|MB|GB)$")]
            [string]$TotalSizeOfAdditionalFiles
        )

        try {
            # Attempt to import the Configuration Manager module
            Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386", "\bin\configurationmanager.psd1") -ErrorAction Stop
        } catch {
            throw "Failed to import the Configuration Manager module. Ensure the SMS_ADMIN_UI_PATH environment variable is set correctly and the module exists."
        }

        try {
            # Attempt to get the site code
            $SiteCode = Get-PSDrive -PSProvider CMSITE -ErrorAction Stop
            if (-not $SiteCode) {
                throw "Failed to retrieve the Configuration Manager site code. Ensure you have access to the Configuration Manager environment."
            }
        } catch {
            throw "Failed to retrieve the Configuration Manager site code. Ensure the Configuration Manager console is installed and accessible."
        }

        for ($i = 1; $i -le $NumberOfApps; $i++) {
            Write-Host "Creating application $i of $NumberOfApps..." -ForegroundColor Cyan
    
            # STEP 1 - Create the content
            $App = New-RandomMsiInstaller -NumberOfAdditionalFiles $NumberOfAdditionalFiles -TotalSizeOfAdditionalFiles $TotalSizeOfAdditionalFiles -OutputDirectory $OutputDirectory
    
    
            try {
                # Attempt to set the location to the Configuration Manager site
                Set-Location "$($SiteCode.Name):\" -ErrorAction Stop
            } catch {
                throw "Failed to set the location to the Configuration Manager site. Ensure the site code is valid and accessible."
            }
    
            $AppOutput = @{
                Name = $App.ProductName;
                SoftwareVersion = $App.Version
                Platform = $App.Platform
                Publisher = $App.Manufacturer
                MsiFilePath = $App.MsiFilePath
                IconLocationFile = $App.IconPath
                Description = $App.Description
                PrivacyUrl = $App.AboutLink
                UserDocumentation = $App.HelpLink
            }
    
            Write-CustomObject -Object ([PSCustomObject]$AppOutput) -OutputTitle "Application Details"
    
            
            $AppProperties = @{
                Name = $App.ProductName;
                SoftwareVersion = $App.Version
                Publisher = $App.Manufacturer
                IconLocationFile = $App.IconPath
                Description = $App.Description
                PrivacyUrl = $App.AboutLink
                UserDocumentation = $App.HelpLink
            }
            New-CMApplication @AppProperties > $null
            
            $AppDTProperties = @{
                ApplicationName = $App.ProductName
                DeploymentTypeName = "$($App.ProductName)($($App.Platform)) - Deployment Type"
                ContentLocation = $App.MsiFilePath
                Comment = "New Deployment Type for $($App.ProductName)"
                InstallCommand = "msiexec /i `"$($App.ProductName).$($App.Version).$($App.Platform).msi`" /qn"
            }
    
            Write-CustomObject -Object ([PSCustomObject]$AppDTProperties) -OutputTitle "Deployment Type Properties"
            Add-CMMSiDeploymentType @AppDTProperties -Force > $null
    
            $DistributionPointGroupName = Get-CMDistributionPointGroup | Select -First 1 | Select -ExpandProperty Name
            $ContentProperties = @{
                ApplicationName = $App.ProductName
                DistributionPointGroupName = $DistributionPointGroupName
            }
            Write-CustomObject -Object ([PSCustomObject]$ContentProperties) -OutputTitle "Content Distribution Properties"
            Start-CMContentDistribution @ContentProperties > $null
    
            $DeploymentProperties = @{
                Name = $App.ProductName;
                DeployAction = 'Install';
                DeployPurpose = 'Available';
                CollectionName = 'All Users';
                UserNotification = 'DisplayAll';
                AvailableDateTime = (Get-Date);
                TimeBaseOn = 'LocalTime';
            }
            Write-CustomObject -Object ([PSCustomObject]$DeploymentProperties) -OutputTitle "Deployment Properties"
            New-CMApplicationDeployment @DeploymentProperties > $null
            
            Set-Location -Path $OriginalDirectory
        }
    }
} catch {
    throw "Failed to create ConfigMgr apps, please retry. Error: $($_.Exception.Message)"
}

function Write-CustomObject {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Object,

        [Parameter(Mandatory = $true)]
        [string]$OutputTitle
    )

    Write-Host "$($OutputTitle):" -ForegroundColor Cyan
    Write-Host "=====================" -ForegroundColor Cyan

    foreach ($Property in $Object.PSObject.Properties) {
        $Name = $Property.Name
        $Value = $Property.Value

        # Use different colors for property names and values
        Write-Host "$($Name):" -ForegroundColor Yellow -NoNewline
        Write-Host " $Value" -ForegroundColor Green
    }

    Write-Host "=====================" -ForegroundColor Cyan
}
