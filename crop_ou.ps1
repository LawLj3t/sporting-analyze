Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\b11d26e7-5366-4cea-b6d6-f2ef43185ab8.png")

# Let's inspect the exact pixels/text around OU Row 1 & Row 2
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(0, 50, 380, 85)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\ou_check_exact.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$bmp.Dispose()
Write-Output "Cropped OU check."
