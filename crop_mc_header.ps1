Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\4bff4fa5\5886e54b-fd52-4f15-b503-70f6711522e5.png")

# Let's crop y: 20 to 120, x: 0 to 450
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(0, 20, 450, 110)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\mc_header_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

# Let's also crop the scoreboard / match info
$crop2 = $bmp.Clone((New-Object System.Drawing.Rectangle(100, 25, 450, 70)), $bmp.PixelFormat)
$crop2.Save("C:\sporting analyze\betslip-crops\mc_match_info.png", [System.Drawing.Imaging.ImageFormat]::Png)

$crop.Dispose()
$crop2.Dispose()
$bmp.Dispose()
Write-Output "Crops saved."
