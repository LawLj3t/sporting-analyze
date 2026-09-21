Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

# Let's inspect the RGB and luminance of each leg's odds
for ($i = 0; $i -lt 13; $i++) {
    $y = 15 + $i * 56
    $maxR = 0; $maxG = 0; $maxB = 0
    for ($dy = -5; $dy -le 5; $dy++) {
        for ($x = 200; $x -lt 230; $x++) {
            $c = $bmp.GetPixel($x, ($y + $dy))
            if ($c.R -gt $maxR) { $maxR = $c.R }
            if ($c.G -gt $maxG) { $maxG = $c.G }
            if ($c.B -gt $maxB) { $maxB = $c.B }
        }
    }
    Write-Output ("Leg {0,2} (y~{1,3}): Max RGB = ({2},{3},{4})" -f ($i+1), $y, $maxR, $maxG, $maxB)
}

$bmp.Dispose()
