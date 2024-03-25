# Function to download
function Install-Pwsh {
    #$progressPreference = 'silentlyContinue'
    Write-Host "Searching and installing the latest version of Powershell..."
    Winget search Microsoft.PowerShell
    Winget install --id Microsoft.Powershell --source winget
    Winget install --id Microsoft.Powershell.Preview --source winget
}

function Install-Winget {
    #$progressPreference = 'silentlyContinue'
    Write-Host "Downloading WinGet and it's dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

function Install-Chocolatey {
    #$progressPreference = 'silentlyContinue'
    Write-Host "Downloading and installing Chocolatey and it's dependencies..."
    Set-ExecutionPolicy Bypass -Scope Process
    $url = "https://community.chocolatey.org/install.ps1"
    [System.Net.ServicePointManager]::SecurityProtocol = 3072
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString($url)
    Set-Variable "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
}

function Install-Wsl {
    Write-Host "Installing WSL and its dependencies..."
    $lnx = Read-Host "The standard operating system kernel is Ubuntu. Do you want to install another Linux distribution? (Y/N)"
    if ($lnx -eq 'y' -or $lnx -eq 'Y') {
        Write-Host "Available Linux distributions:"
        wsl --list --online
        $distro = Read-Host "Enter the chosen distribution"
        wsl --install --distribution $distro
    } elseif ($lnx -eq 'n' -or $lnx -eq 'N') {
        Write-Host "Installing the Ubuntu distribution..."
        wsl --install
        Write-Host "Remember to update the WSL system:`n'sudo apt update && sudo apt upgrade'"
    } else {
        Write-Host "Enter a valid option..."
    }
}

function NetworkInterfaces {
    #$progressPreference = 'silentlyContinue'
    Write-Host "Devide network adapters:"
    Get-NetAdapter
    $AdapterOption = Read-Host "Enter the network interface name"    
    Restart-NetAdapter -Name $AdapterOption -Confirm:$false
}

while ($true) {
    Write-Host "Welcome to PowerShell tools panel!"
    $option = Read-Host "Choose an option: `n1. Install PowerShell `n2. Install Winget `n3. Install Chocolatey `n4. Restart Network Interface`nOption"
    switch ($option) {
        '1' {  
            Clear-Host
            Install-Pwsh
            break
        } '2' {
            Clear-Host
            Install-Winget
            break
        } '3' {
            Clear-Host
            Install-Chocolatey
            break
        } '4' {
            Clear-Host
            Install-Wsl
            break
        } '5' {
            Clear-Host
            NetworkInterfaces
            break
        } Default {
            Clear-Host
            Write-Host "Invalid Input"
            break
        }
    }
}