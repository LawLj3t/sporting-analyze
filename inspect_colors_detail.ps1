Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\fce34188\31eb0110-6447-49b9-821e-7a8e9b11475f.png")

# Let's inspect unique colors, or save a slice or detailed ASCII representation
Write-Output "Width: $($bmp.Width), Height: $($bmp.Height)"

# Find bounding box of non-background pixels if background is uniform
# Let's see color of pixel at 0,0
$bg = $bmp.GetPixel(0,0)
Write-Output "Top-left pixel: R=$($bg.R) G=$($bg.G) B=$($bg.B)"

# Let's inspect a horizontal slice across the middle (y = 70)
# and across y = 30, y = 100
for ($y = 10; $y -lt $bmp.Height; $y += 15) {
    $rowText = ""
    for ($x = 0; $x -lt $bmp.Width; $x += 10) {
        $c = $bmp.GetPixel($x, $y)
        # Check if greenish, bluish, brownish, whitish
        if ($c.R -gt 200 -and $c.G -gt 200 -and $c.B -gt 200) { $rowText += "#" } # white
        elseif ($c.R -gt 150 -and $c.G -lt 100 -and $c.B -lt 100) { $rowText += "R" }
        elseif ($c.G -gt 150 -and $c.R -lt 100) { $rowText += "G" } # green
        elseif ($c.B -gt 150 -and $c.R -lt 100) { $rowText += "B" } # blue
        elseif ($c.R -gt 120 -and $c.G -gt 100 -and $c.B -lt 50) { $rowText += "Y" } # yellow/gold
        else { $rowText += "." }
    }
    Write-Output "y=$($y.ToString('D3')): $rowText"
}

$bmp.Dispose()
