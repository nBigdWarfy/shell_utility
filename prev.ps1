Write-Host "Downloading and installing files..."
Invoke-WebRequest -Uri https://raw.githubusercontent.com/nBigdWarfy/shell_utility/main/pwsh_tool.ps1 -OutFile Downloads
Start-Process Downloads/pwsh_tool.ps1