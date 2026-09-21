Add-Type -AssemblyName System.Runtime.WindowsRuntime
Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\e122b754-3590-4e60-9bb4-3413e9fed8a8.png")

$scaled = New-Object System.Drawing.Bitmap(($bmp.Width * 4), ($bmp.Height * 4))
$g = [System.Drawing.Graphics]::FromImage($scaled)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($bmp, 0, 0, $scaled.Width, $scaled.Height)
$g.Dispose()

$p = "C:\sporting analyze\betslip-crops\slip_scaled.png"
$scaled.Save($p, [System.Drawing.Imaging.ImageFormat]::Png)
$scaled.Dispose()
$bmp.Dispose()
Write-Output "Saved scaled slip."
