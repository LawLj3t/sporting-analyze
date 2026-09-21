Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\e122b754-3590-4e60-9bb4-3413e9fed8a8.png")

Write-Output "Width: $($bmp.Width), Height: $($bmp.Height)"

# Let's inspect the lower part (Y: 120 to 158)
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(0, 110, $bmp.Width, ($bmp.Height - 110))), $bmp.PixelFormat)
$scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
$g = [System.Drawing.Graphics]::FromImage($scaled)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
$g.Dispose()

$p = "C:\sporting analyze\betslip-crops\bottom_slip.png"
$scaled.Save($p, [System.Drawing.Imaging.ImageFormat]::Png)
$scaled.Dispose()
$bmp.Dispose()
Write-Output "Saved bottom slip."
