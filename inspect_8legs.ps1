Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\df418bdb-f6c6-41ef-b9e0-24ce24adb00d.png")

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
        if ($line.Trim() -ne "") {
            Write-Output $line
        }
    }
}

# Also let's inspect the bottom total odds at y: 440..470, x: 170..235
RenderGreenAscii 170 440 65 30 "Total Bet Slip Odds (Bottom Right)"

# Now let's print odds for each of the 8 legs
# The slip has 8 legs in 440px -> about 55px each
for ($i = 0; $i -lt 8; $i++) {
    $y = 5 + $i * 55
    RenderGreenAscii 190 ($y - 5) 45 20 "Leg $($i+1) Odds"
}

$bmp.Dispose()
