Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\fce34188\31eb0110-6447-49b9-821e-7a8e9b11475f.png")

# Let's check text or pixels in x: 0 to 506, y: 0 to 40
# and x: 400 to 506, y: 0 to 140
for ($y = 5; $y -lt 35; $y += 5) {
    $row = ""
    for ($x = 0; $x -lt 506; $x += 5) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 180 -and $c.G -gt 180 -and $c.B -gt 180) { $row += "#" }
        elseif ($c.R -gt 120 -or $c.G -gt 120 -or $c.B -gt 120) { $row += "+" }
        else { $row += "." }
    }
    Write-Output "y=$y : $row"
}

# Also check x > 400
for ($y = 40; $y -lt 100; $y += 10) {
    $row = ""
    for ($x = 400; $x -lt 506; $x += 4) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 180 -and $c.G -gt 180 -and $c.B -gt 180) { $row += "#" }
        elseif ($c.R -gt 120 -or $c.G -gt 120 -or $c.B -gt 120) { $row += "+" }
        else { $row += "." }
    }
    Write-Output "x>400 y=$y : $row"
}

$bmp.Dispose()
