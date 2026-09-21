Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

# Leg 5 is roughly y: 224 to 280
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(0, 224, $bmp.Width, 56)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\leg5_crop.png", [System.Drawing.Imaging.ImageFormat]::Png)

function PrintCropAscii($c, $label) {
    Write-Output "=== $label ==="
    for ($y = 0; $y -lt $c.Height; $y += 2) {
        $row = ""
        for ($x = 0; $x -lt $c.Width; $x += 2) {
            $p = $c.GetPixel($x, $y)
            $lum = [int](0.299 * $p.R + 0.587 * $p.G + 0.114 * $p.B)
            if ($p.G -gt 130 -and $p.G -gt ($p.R * 1.3)) { $row += "$" }
            elseif ($lum -gt 140) { $row += "#" }
            elseif ($lum -gt 70) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

PrintCropAscii $crop "Leg 5 Full Row"

$crop.Dispose()
$bmp.Dispose()
