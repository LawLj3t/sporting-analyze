Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

# Let's crop y: 385 to 415, x: 380 to 765
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(380, 385, 385, 30)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\fulham_corner_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

for ($y = 0; $y -lt $crop.Height; $y += 2) {
    $row = ""
    for ($x = 0; $x -lt $crop.Width; $x += 2) {
        $c = $crop.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 50) { $row += "#" }
        elseif ($lum -lt 100) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}

$crop.Dispose()
$bmp.Dispose()
