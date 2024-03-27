function Install-Pwsh {
    Write-Host "Searching and installing the latest version of Powershell..."
    Winget search Microsoft.PowerShell
    Winget install --id Microsoft.Powershell --source winget
    Winget install --id Microsoft.Powershell.Preview --source winget
    $PSVersionTable.PSVersion
}

function Install-Winget {
    Write-Host "Downloading WinGet and it's dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

function Install-Chocolatey {
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
        Write-Host "Enter a valid option."
    }
}

function Install-OpenSSH {
    Write-Host "Installing the SSH..."
    Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
    $permission = Invoke-Expression (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($permission -eq 'False') {
        Write-Host "You do not have the neccesary permissions."
        Pause
        Return
    }
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
        New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
    }
} 

function NetworkInterfaces {
    #$progressPreference = 'silentlyContinue'
    Write-Host "Devide network adapters:"
    Get-NetAdapter
    $adpt = Read-Host "Enter the network interface name"
    Write-Host "`n"
    $action = Read-Host "Choose the action to be performed:`n1. Enable adapter`n2. Disable adapter`n3. Restart adapter`n4. Get back`nOption"
    switch ($action) {
        '1' {
            Enable-NetAdapter -Name $adpt -Confirm:$false
        } '2' {
            Disable-NetAdapter -Name $adpt -Confirm:$false
        } '3' {
            Restart-NetAdapter -Name $adpt -Confirm:$false
        } '4' {
            Return
        } Default {
            Write-Host "Enter a valid option."
        }
    }
}

while ($true) {
    Write-Host "Welcome to PowerShell tools panel!"
    $option = Read-Host "Choose an option:`n1. Install PowerShell`n2. Install Winget`n3. Install Chocolatey`n4. Install WSL`n5. Install OpenSH`n6. Network Interface`nOption"
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
            Install-OpenSSH
            break
        } '6' {
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