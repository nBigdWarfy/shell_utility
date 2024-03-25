Write-Host "Downloading and installing files..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/nBigdWarfy/shell_utility/main/shellpanel.ps1 -OutFile Downloads
Start-Process Downloads/shellpanel.ps1