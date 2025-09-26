# CM App Creation PowerShell Module

A comprehensive PowerShell toolkit for creating random Microsoft System Center Configuration Manager (SCCM/MECM) applications for testing and lab environments.

## Overview

This module generates realistic dummy applications complete with MSI installers, deployment types, content distribution, and deployments in Configuration Manager. Perfect for testing, demonstrations, and populating lab environments with sample data.

## Features

- **Random MSI Installer Generation**: Creates realistic MSI packages with proper metadata
- **Dynamic Application Names**: Generates creative application and company names
- **Custom Icons**: Creates unique colorful icons for each application
- **Flexible File Generation**: Supports additional files with configurable sizes
- **Full CM Integration**: Automatically creates applications, deployment types, and deployments
- **Content Distribution**: Distributes content to distribution point groups
- **Automated Deployment**: Deploys applications to user collections

## Prerequisites

Before using this module, ensure you have:

- **Configuration Manager Console** installed on your system
- **SMS_ADMIN_UI_PATH** environment variable properly configured
- **PowerShell execution policy** set to allow script execution
- **Appropriate permissions** in Configuration Manager to create applications
- **Network access** to the target output directory (UNC path)
- **Internet connectivity** (recommended) for automatic PSMSI module installation from PowerShell Gallery
- **PSMSI PowerShell module** for MSI creation (automatically installed from PowerShell Gallery or local archive)

## Module Files

| File | Description |
|------|-------------|
| `New-RandomCMApp.ps1` | Main function that orchestrates CM application creation |
| `New-RandomMSIInstaller.ps1` | Creates MSI installer packages with metadata |
| `New-RandomName.ps1` | Generates random application and company names |
| `New-RandomIcon.ps1` | Creates colorful random icons for applications |
| `New-RandomDescription.ps1` | Generates realistic application descriptions |
| `New-RandomAdditionalFiles.ps1` | Creates additional files with specified sizes |
| `PSMI.zip` | PowerShell MSI creation module (fallback archive) |

## Dependencies

This module relies on the **PSMSI** PowerShell module for MSI installer creation. The PSMSI module is maintained by Ironman Software and provides comprehensive MSI manipulation capabilities.

- **PSMSI Module Repository**: [https://github.com/ironmansoftware/psmsi](https://github.com/ironmansoftware/psmsi)
- **Installation Strategy**: 
  1. **Primary**: Automatic installation from PowerShell Gallery (`Install-Module PSMSI`)
  2. **Fallback**: Installation from bundled `PSMI.zip` archive (for offline scenarios)
- **Author**: Ironman Software
- **License**: MIT License

## Installation and Setup

### Quick Start
1. **Download or clone** this repository to your system
2. **Ensure Prerequisites** are met (see Prerequisites section above)
3. **Run PowerShell as Administrator** (required for PSMSI module installation)
4. **Navigate** to the CM App Creation directory
5. **Execute** the main function:

```powershell
# Basic usage - creates 5 test applications
. .\New-RandomCMApp.ps1
New-RandomCMApp -OutputDirectory "\\yourserver\share\TestApps" -NumberOfApps 5
```

### PSMSI Module Installation
The module automatically handles PSMSI installation using a two-tier approach:

#### Online Installation (Recommended)
- Automatically installs the latest PSMSI module from PowerShell Gallery
- Ensures compatibility with the latest Windows Installer features
- Requires internet connectivity during first run

#### Offline Installation (Fallback)
- Uses the bundled `PSMI.zip` archive if PowerShell Gallery is unavailable
- Perfect for air-gapped or restricted network environments
- Maintains full functionality without internet dependency

### First Run Behavior
```
1. Check if PSMSI module is already installed ✓
2. Attempt PowerShell Gallery installation (Install-Module PSMSI) ✓
3. If Gallery fails, extract and install from PSMI.zip ✓
4. Import module and proceed with application creation ✓
```

## Usage

### Basic Usage

Create 5 random Configuration Manager applications:

```powershell
New-RandomCMApp -OutputDirectory "\\sccmserver\sources$\Applications\TestApps" -NumberOfApps 5
```

### Advanced Usage with Additional Files

Create applications with additional supporting files:

```powershell
New-RandomCMApp -OutputDirectory "\\pmpclabsccm\g$\cmapplications\DummyApplications" -NumberOfApps 10 -NumberOfAdditionalFiles 5 -TotalSizeOfAdditionalFiles "250MB"
```

### Large-Scale Testing

Create applications with substantial content for bandwidth testing:

```powershell
New-RandomCMApp -OutputDirectory "\\fileserver\apps$\SCCM\RandomApps" -NumberOfApps 3 -NumberOfAdditionalFiles 15 -TotalSizeOfAdditionalFiles "1GB"
```

## Parameters

### New-RandomCMApp Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `OutputDirectory` | String | Yes | UNC path where MSI files and content will be stored |
| `NumberOfApps` | String | Yes | Number of random applications to create |
| `NumberOfAdditionalFiles` | Int | No | Number of additional files per application (requires TotalSizeOfAdditionalFiles) |
| `TotalSizeOfAdditionalFiles` | String | No | Total size of additional files (format: "500MB", "1.5GB", "2048KB") |

### Output Directory Requirements

The `OutputDirectory` parameter must be:
- A valid UNC path (e.g., `\\server\share\folder`)
- Accessible by the Configuration Manager site server
- Have sufficient disk space for the generated content
- Allow write permissions for the executing user

## Examples

### Example 1: Quick Test Environment

```powershell
# Create 5 basic applications for quick testing
New-RandomCMApp -OutputDirectory "\\cm01\sources$\Apps\Test" -NumberOfApps 5
```

**Output:**
- 5 Configuration Manager applications
- Each with a unique MSI installer
- Random names like "Golden Thunder Suite", "Dynamic Echo Platform"
- Deployed to "All Users" collection
- Distributed to first available DP group

### Example 2: Bandwidth Testing

```powershell
# Create applications with large content for bandwidth testing
New-RandomCMApp -OutputDirectory "\\dp01\content$\BandwidthTest" -NumberOfApps 3 -NumberOfAdditionalFiles 20 -TotalSizeOfAdditionalFiles "2GB"
```

**Output:**
- 3 Configuration Manager applications
- Each with 20 additional files totaling 2GB
- Perfect for testing content distribution performance

### Example 3: Demo Environment

```powershell
# Create varied applications for demonstration purposes
New-RandomCMApp -OutputDirectory "\\demo\apps$\SCCM\DemoApps" -NumberOfApps 15 -NumberOfAdditionalFiles 8 -TotalSizeOfAdditionalFiles "500MB"
```

**Output:**
- 15 diverse applications with realistic names
- Moderate file sizes suitable for demos
- Variety of application types and publishers

## What Gets Created

For each application, the function creates:

1. **File System Content:**
   - Unique MSI installer with proper metadata
   - Custom PNG icon (512x512 pixels)
   - README.txt file with application details
   - Additional files (if specified)

2. **Configuration Manager Objects:**
   - CM Application with metadata (name, version, publisher, description)
   - MSI Deployment Type with install command
   - Content distribution to first available DP group
   - Application deployment to "All Users" collection

3. **Sample Application Properties:**
   - **Name**: "Quantum Steel Manager"
   - **Version**: "3.7.42"
   - **Platform**: "x64"
   - **Publisher**: "Innovative Synergy Solutions Inc."
   - **Description**: "Powerful delivers solutions for enterprises to improve productivity."
   - **Install Command**: `msiexec /i "Quantum Steel Manager.3.7.42.x64.msi" /qn`

## Generated Content Structure

```
OutputDirectory\
├── Application_Name_1\
│   ├── Application_Name_1.3.2.15.x64.msi
│   ├── Application_Name_1.png
│   ├── File_1.bin (if additional files specified)
│   ├── File_2.txt
│   └── ...
├── Application_Name_2\
│   ├── Application_Name_2.1.8.7.x86.msi
│   ├── Application_Name_2.png
│   └── ...
└── ...
```

## Configuration Manager Integration

The function automatically handles:

- **Module Import**: Loads the Configuration Manager PowerShell module
- **Site Connection**: Connects to the CM site using the site code
- **Application Creation**: Creates CM applications with proper metadata
- **Deployment Types**: Adds MSI deployment types with install commands
- **Content Distribution**: Distributes to the first available DP group
- **Deployments**: Creates "Available" deployments to "All Users"

## Troubleshooting

### Common Issues

**Error: "Failed to import the Configuration Manager module"**
- Verify CM Console is installed
- Check SMS_ADMIN_UI_PATH environment variable
- Restart PowerShell session after CM Console installation

**Error: "Failed to retrieve the Configuration Manager site code"**
- Ensure you have access to the CM environment
- Verify CM Console can connect to the site
- Check user permissions in Configuration Manager

**Error: "Access to the path is denied"**
- Verify UNC path accessibility
- Check write permissions on the output directory
- Ensure network connectivity to the target server

**PSMSI Module Issues**
- The script automatically attempts to install the PSMSI module from PowerShell Gallery
- If PowerShell Gallery is unavailable, falls back to local PSMI.zip archive installation  
- Requires administrator privileges for module installation to system paths
- Internet connectivity recommended for getting the latest version from PowerShell Gallery
- In offline environments, ensure PSMI.zip is present in the script directory

### Validation Steps

1. **Test Output Directory Access:**
   ```powershell
   Test-Path "\\server\share\folder"
   New-Item -Path "\\server\share\folder\test.txt" -ItemType File
   ```

2. **Verify CM Module:**
   ```powershell
   $env:SMS_ADMIN_UI_PATH
   Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386", "\bin\configurationmanager.psd1")
   ```

3. **Check Site Connectivity:**
   ```powershell
   Get-PSDrive -PSProvider CMSITE
   ```

## Performance Considerations

- **Large File Generation**: Creating applications with large additional files may take significant time
- **Network Bandwidth**: Content distribution will consume network bandwidth
- **Disk Space**: Ensure adequate space on content sources and distribution points
- **CM Database**: Large numbers of applications will consume database space

## Best Practices

1. **Use Dedicated Test Collections**: Create specific collections for testing instead of "All Users"
2. **Cleanup After Testing**: Remove test applications and content when no longer needed
3. **Monitor Disk Space**: Keep an eye on content source and DP disk usage
4. **Network Considerations**: Run during maintenance windows for large content generation
5. **Documentation**: Keep track of created applications for easier cleanup

## License

This module is provided as-is for educational and testing purposes. Use in production environments is not recommended.

## Contributing

Feel free to submit issues, feature requests, or improvements to enhance the functionality of this testing toolkit.

## Version History

- **v1.0**: Initial release with basic CM application creation
- **v1.1**: Added support for additional files and size specification
- **v1.2**: Enhanced error handling and validation
- **v1.3**: Added comprehensive help documentation and README
- **v1.4**: Improved PSMSI module installation with PowerShell Gallery priority and fallback support

## Credits and Acknowledgments

- **PSMSI Module**: Created and maintained by [Ironman Software](https://github.com/ironmansoftware/psmsi)
- **Configuration Manager**: Microsoft System Center Configuration Manager
- **PowerShell Community**: For best practices and module development standards

## Links and Resources

- **PSMSI GitHub Repository**: [https://github.com/ironmansoftware/psmsi](https://github.com/ironmansoftware/psmsi)
- **PowerShell Gallery - PSMSI**: [https://www.powershellgallery.com/packages/PSMSI](https://www.powershellgallery.com/packages/PSMSI)
- **Configuration Manager Documentation**: [https://docs.microsoft.com/en-us/mem/configmgr/](https://docs.microsoft.com/en-us/mem/configmgr/)

---

*This tool is designed for testing and lab environments. Always test thoroughly before using in any production capacity.*