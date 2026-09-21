Add-Type -AssemblyName System.Drawing

$img1 = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\fce34188\31eb0110-6447-49b9-821e-7a8e9b11475f.png")

# Let's see where text or UI elements are located
# Let's downsample and print an ASCII grayscale map of Image 1
$w = 100
$h = 28
$bmpSmall = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmpSmall)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($img1, 0, 0, $w, $h)
$g.Dispose()

$chars = " .:-=+*#%@"
for ($y = 0; $y -lt $h; $y++) {
    $line = ""
    for ($x = 0; $x -lt $w; $x++) {
        $c = $bmpSmall.GetPixel($x, $y)
        $brightness = ($c.R * 0.299 + $c.G * 0.587 + $c.B * 0.114) / 255.0
        $idx = [int]($brightness * ($chars.Length - 1))
        $line += $chars[$idx]
    }
    Write-Output $line
}

$bmpSmall.Dispose()
$img1.Dispose()
