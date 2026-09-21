Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\9cc355fa-ffc3-4b44-828e-3c5000d4f697.png")

function SaveCrop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $crop.Save("C:\sporting analyze\leverkusen-crops\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
}

SaveCrop 0 20 383 60 "crop_1x2_exact"
SaveCrop 0 75 383 150 "crop_ou_exact"
SaveCrop 383 25 384 190 "crop_hdp_exact"
SaveCrop 0 220 383 180 "crop_btts_exact"
SaveCrop 383 340 384 90 "crop_corners_exact"

$bmp.Dispose()
Write-Output "Crops saved successfully."
