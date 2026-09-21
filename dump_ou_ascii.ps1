Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\b11d26e7-5366-4cea-b6d6-f2ef43185ab8.png")

# Let's inspect OU area: X: 0 to 380, Y: 60 to 135
$w = 380
$h = 75
$stepX = 4
$stepY = 2

for ($y = 60; $y -lt 60 + $h; $y += $stepY) {
    $line = ""
    for ($x = 0; $x -lt $w; $x += $stepX) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 80) {
            $line += " "
        } elseif ($lum -lt 150) {
            $line += "."
        } elseif ($lum -lt 200) {
            $line += "*"
        } else {
            $line += "#"
        }
    }
    Write-Output ("Y:{0,3} | {1}" -f $y, $line)
}

$bmp.Dispose()
