Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\920aea6b-2e0a-437e-98fe-054c172b9b4c.png")

# Let's see: image is 216 x 640.
# Let's downsample: 216 / 3 = 72 chars wide, 640 / 8 = 80 lines tall.
for ($y = 0; $y -lt 640; $y += 8) {
    $line = ""
    for ($x = 0; $x -lt 216; $x += 3) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 50) { $line += " " }
        elseif ($lum -lt 100) { $line += "." }
        elseif ($lum -lt 160) { $line += ":" }
        elseif ($lum -lt 220) { $line += "*" }
        else { $line += "#" }
    }
    Write-Output ("Y:{0,3} | {1}" -f $y, $line)
}

$bmp.Dispose()
