
# Auto install & setup oh-my-posh, Terminal-Icons, and posh-git
# for windows 10/11 with my custom theme
# This script will use Install-Module function & winget
# to download & install required programs


# install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh -s winget

# install Terminal-Icons
Install-Module -Name Terminal-Icons -Repository PSGallery -Force

# install posh-git
Install-Module -Name posh-git -Repository PSGallery -Force

# ask to install fonts
$option = (Read-Host -Prompt "Do you want to install all fonts automatically? (y/N)").ToLower().Trim()
if ($option -eq "y") {
    
    # unzip font files
    $fontFolder = "$(Get-Location)\font"
    New-Item $fontFolder -Type Directory
    Invoke-WebRequest -URI "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/CascadiaCode.zip" -OutFile "$fontFolder\CascadiaCode_v2.2.2.zip"
    $fontSourceFolder = "$fontFolder\output"
    Expand-Archive -LiteralPath "$fontFolder\CascadiaCode_v2.2.2.zip" -DestinationPath "$fontSourceFolder"
    $SystemFontsPath = "C:\Windows\Fonts"
    
    # install all font files
    # https://gist.github.com/anthonyeden/0088b07de8951403a643a8485af2709b
    foreach($FontFile in Get-ChildItem $fontSourceFolder -Include '*.ttf','*.ttc','*.otf' -recurse ) {
        $targetPath = Join-Path $SystemFontsPath $FontFile.Name
        if(Test-Path -Path $targetPath){
            $FontFile.Name + " already installed"
        }
        else {
            "Installing font " + $FontFile.Name
            
            #Extract Font information for Reqistry 
            $ShellFolder = (New-Object -COMObject Shell.Application).Namespace($fontSourceFolder)
            $ShellFile = $ShellFolder.ParseName($FontFile.name)
            $ShellFileType = $ShellFolder.GetDetailsOf($ShellFile, 2)
            
            #Set the $FontType Variable
            If ($ShellFileType -Like '*TrueType font file*') {$FontType = '(TrueType)'}
                
            #Update Registry and copy font to font directory
            $RegName = $ShellFolder.GetDetailsOf($ShellFile, 21) + ' ' + $FontType
            New-ItemProperty -Name $RegName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.name -Force | out-null
            Copy-item $FontFile.FullName -Destination $SystemFontsPath
            "Done"
            Write-Output "Remember to change your terminal font to `"CaskaydiaCove NF Mono`"."
        }
    }
    
    # clear unzipped fonts
    Remove-Item $fontFolder -Recurse
    
}

# ask to update profile with template profile
$option = (Read-Host -Prompt "Do you want to automatically update your powershell profile? (y/N)").ToLower().Trim()
if ($option -eq "y") {
    $profile_str = $(Get-Content ./profile_templates/Microsoft.PowerShell_profile.ps1.template).Replace("_REPO_PATH_", $(Get-Location))
    
    Write-Output "We will append following text block to this file:`n$PROFILE"
    Write-Output $profile_str
    $sure = (Read-Host -Prompt "`n`nAre you sure? (y/N)").ToLower().Trim()
    if ($sure -eq "y") {
        $profile_str >> $PROFILE
    }
}

# prompt
echo "Successfully setup oh-my-posh, please restart your shell."

