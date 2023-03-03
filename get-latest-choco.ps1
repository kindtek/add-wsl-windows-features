#Requires -RunAsAdministrator
# using https://gist.github.com/MarkTiedemann/c0adc1701f3f5c215fc2c2d5b1d5efd3#file-download-latest-release-ps1 as template for this file

# Download latest choclatey release from github
# defaults (most up to date release)
$choco = 'choco'
$repo = "chocolatey/$choco"
$tag = "1.3.0" # default is latest known release
$file = "$tag.zip"
$dir = "$choco-$tag"

$releases = "https://api.github.com/repos/$repo/releases"

Write-Host "Determining latest release"
# don't use preview releases
foreach ( $this_tag in (Invoke-WebRequest $releases | ConvertFrom-Json)) {
    if ($this_tag["tag_name"] -NotLike "*alpha*" ) {
        $tag = $this_tag["url"]
        break
    }
}

$download = "https://github.com/$repo/archive/refs/tags/$file"

Push-Location ..
Push-Location ..

Write-Host "Downloading latest release at $download"
Invoke-WebRequest $download -Out $file

Write-Host "Unpacking ..."
Expand-Archive $file -Force
Write-Host "`r`n"


Invoke-Expression "cmd /c $tag/$dir/build.bat"
# Install-PackageProvider ChocolateyGet -Force -AllowClobber

Remove-Item $tag -Recurse -Force -ErrorAction SilentlyContinue 
Remove-Item $file -Recurse -Force -ErrorAction SilentlyContinue 

Pop-Location
Pop-Location
# Moving from temp dir to target dir
# $pwd_path = Split-Path -Path $PSCommandPath
# $old_path = Join-Path -Path $pwd_path -ChildPath $dir
# $new_path = Join-Path -Path (Get-Location) -ChildPath $name\Winget
# Move-Item $old_path -Destination $new_path -Force