Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\3baaa4fb-9ce1-44d2-990b-8b6685b6a64c.png")

# Let's inspect different sub-regions
# Region 1: 1X2 (Top left, y: 0 to 60, x: 0 to 378)
# Region 2: O/U goals (y: 60 to 220, x: 0 to 378)
# Region 3: BTTS / Both teams to score (y: 220 to 382, x: 0 to 378)
# Region 4: Asian Handicap (y: 0 to 180, x: 378 to 757)
# Region 5: Other O/U / Corners (y: 180 to 382, x: 378 to 757)

function SaveCrop($x, $y, $w, $h, $name) {
    $rect = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $crop.Save("C:\sporting analyze\parma-crops\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()
}

SaveCrop 0 0 378 65 "crop_1x2"
SaveCrop 0 65 378 160 "crop_ou_goals"
SaveCrop 0 220 378 160 "crop_btts"
SaveCrop 378 0 379 175 "crop_asian_hdp"
SaveCrop 378 175 379 205 "crop_right_bottom"

$bmp.Dispose()
Write-Output "Crops saved."
