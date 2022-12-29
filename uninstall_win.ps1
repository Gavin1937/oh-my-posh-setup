
# uninstall oh-my-posh
winget uninstall --name JanDeDobbeleer.OhMyPosh

# uninstall Terminal-Icons
Uninstall-Module -Name Terminal-Icons -Force

# uninstall posh-git
Uninstall-Module -Name posh-git -Force

# ask to update $PROFILE
$option = (Read-Host -Prompt "Do you want to automatically remove oh-my-posh from your powershell profile? (y/N)").ToLower().Trim()
if ($option -eq "y") {
    $pattern = "# ============================================ oh-my-posh ============================================ #"
    $filepath = $PROFILE
    $raw = (Get-Content $filepath -raw)
    $beg = $raw.IndexOf($pattern)
    $end = ($raw.IndexOf($pattern, $beg+1) + $pattern.Length + 1)
    $block = $raw.Substring($beg, $end-$beg)
    
    Write-Output "We will remove following text block from this file:`n$filepath"
    Write-Output $block
    $sure = (Read-Host -Prompt "`n`nAre you sure? (y/N)").ToLower().Trim()
    if ($sure -eq "y") {
        $raw.Replace($block, "") > $filepath
        Write-Output "Remember to change your terminal font setting."
    }
}

echo "Successfully uninstall oh-my-posh, please restart your shell."

