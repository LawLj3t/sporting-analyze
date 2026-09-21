Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\304ed8b5-2305-4274-9581-abc7fefef604.png")

# Let's crop line 1 text (x: 55 to 195, y: 12 to 24) and line 2 text (x: 55 to 195, y: 32 to 44)
# Save as 10x images with smoothing to see clearly
function SaveZoom($x, $y, $w, $h, $name) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($x, $y, $w, $h)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($w * 8), ($h * 8))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $scaled.Save("C:\sporting analyze\betslip-crops\$name.png", [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $crop.Dispose()
    $scaled.Dispose()
}

SaveZoom 50 12 150 14 "line1_zoom"
SaveZoom 50 32 150 14 "line2_zoom"

$bmp.Dispose()
