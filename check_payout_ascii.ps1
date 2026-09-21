Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\550a6f74\2081ce09-2323-4cb4-b6a0-82c96512c56a.png")

# Crop bottom right where the payout is
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(20, 395, 250, 35)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\payout_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

for ($y = 0; $y -lt $crop.Height; $y++) {
    $row = ""
    for ($x = 0; $x -lt $crop.Width; $x++) {
        $c = $crop.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 85) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}

$crop.Dispose()
$bmp.Dispose()
