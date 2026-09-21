Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

function RenderGreenAscii($x, $y, $w, $h, $label) {
    Write-Output "`n=== $label ==="
    for ($j = $y; $j -lt ($y + $h); $j += 1) {
        $line = ""
        for ($i = $x; $i -lt ($x + $w); $i += 1) {
            if ($i -ge 0 -and $i -lt $bmp.Width -and $j -ge 0 -and $j -lt $bmp.Height) {
                $c = $bmp.GetPixel($i, $j)
                if ($c.G -gt 130 -and $c.G -gt ($c.R * 1.4)) {
                    $line += "#"
                } elseif ($c.G -gt 80 -and $c.G -gt ($c.R * 1.2)) {
                    $line += "+"
                } else {
                    $line += "."
                }
            }
        }
        Write-Output $line
    }
}

# Check Leg 2, Leg 5, Leg 10, Leg 11
RenderGreenAscii 195 62 40 16 "Leg 2 Odds Fine"
RenderGreenAscii 195 230 40 16 "Leg 5 Odds Fine"
RenderGreenAscii 195 510 40 16 "Leg 10 Odds Fine"

$bmp.Dispose()
