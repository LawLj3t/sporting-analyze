Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\fce34188\31eb0110-6447-49b9-821e-7a8e9b11475f.png")

# Let's inspect region x: 0 to 80, y: 0 to 140
# And region above text: x: 0 to 506, y: 0 to 75
Write-Output "Checking region x: 0 to 80, y: 30 to 110"
for ($y = 40; $y -lt 100; $y += 5) {
    $row = ""
    for ($x = 10; $x -lt 80; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 100 -and $c.G -gt 80 -and $c.B -lt 60) { $row += "Y" }
        elseif ($c.R -gt 150 -and $c.G -gt 150 -and $c.B -gt 150) { $row += "#" }
        elseif ($c.R -gt 70 -or $c.G -gt 70 -or $c.B -gt 70) { $row += "+" }
        else { $row += "." }
    }
    Write-Output "$y : $row"
}

# Also let's check y from 10 to 60 above the text (x: 80 to 450)
Write-Output "`nChecking region above text (y: 20 to 70, x: 80 to 400)"
for ($y = 20; $y -lt 70; $y += 8) {
    $row = ""
    for ($x = 80; $x -lt 400; $x += 6) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 150 -and $c.G -gt 150 -and $c.B -gt 150) { $row += "#" }
        elseif ($c.R -gt 100 -and $c.G -gt 80 -and $c.B -lt 60) { $row += "Y" }
        elseif ($c.R -gt 70 -or $c.G -gt 70 -or $c.B -gt 70) { $row += "+" }
        else { $row += "." }
    }
    Write-Output "$y : $row"
}

$bmp.Dispose()
