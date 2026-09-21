Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\df418bdb-f6c6-41ef-b9e0-24ce24adb00d.png")

# Leg 8 is roughly y: 390 to 450
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(0, 390, $bmp.Width, 55)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\leg8_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

for ($y = 0; $y -lt $crop.Height; $y += 1) {
    $row = ""
    for ($x = 0; $x -lt 180; $x += 1) {
        $c = $crop.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($c.G -gt 130 -and $c.G -gt ($c.R * 1.3)) { $row += "$" }
        elseif ($lum -lt 50) { $row += "#" }
        elseif ($lum -lt 100) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}

$crop.Dispose()
$bmp.Dispose()
