# Function to download
function WingetInstall {
    Write-Information "Downloading WinGet and its dependencies..."
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle    
}

function PwshInstall {
    Winget install --id Microsoft.Powershell --source winget
    Winget install --id Microsoft.Powershell.Preview --source winget
}

function TelnetInstall {
    install -windowsfeature "telnet-client"
}

while ($true) {
    Welcome
    $option = Read-Host "Choose an option: 1. Install Winget Tool, 2. Install PowerShell, 3. Other"
    switch ($option) {
        '1' {  
            WingetInstall
            break
        }
        '2' {
            PwshInstall
            break
        }
        '3' {
            TelnetInstall
            break
        }
        Default {
            Write-Host "Invalid Input"
            break
        }
    }
}