Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\9f6abfd6-2f4e-4021-877c-47eccff8c0c0.png")

$scaled = New-Object System.Drawing.Bitmap(($bmp.Width * 4), ($bmp.Height * 4))
$g = [System.Drawing.Graphics]::FromImage($scaled)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($bmp, 0, 0, $scaled.Width, $scaled.Height)
$g.Dispose()

$p = "C:\sporting analyze\betslip-crops\zoomed_check.png"
$scaled.Save($p, [System.Drawing.Imaging.ImageFormat]::Png)
$scaled.Dispose()
$bmp.Dispose()
Write-Output "Saved zoomed check."
