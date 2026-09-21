Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

function RenderAscii($x, $y, $w, $h, $label) {
    Write-Output "`n========================================================"
    Write-Output "ASCII: $label (x:$x, y:$y, w:$w, h:$h)"
    Write-Output "========================================================"
    for ($j = $y; $j -lt ($y + $h); $j += 1) {
        $line = ""
        for ($i = $x; $i -lt ($x + $w); $i += 1) {
            if ($i -ge 0 -and $i -lt $bmp.Width -and $j -ge 0 -and $j -lt $bmp.Height) {
                $c = $bmp.GetPixel($i, $j)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 130) {
                    $line += "#"
                } elseif ($lum -gt 80) {
                    $line += "+"
                } else {
                    $line += "."
                }
            }
        }
        Write-Output $line
    }
}

# The betslip has 13 items.
# Let's see the y range for each item's odds in the right column (x: 200 to 235)
# Item 1: y: 5..25
# Item 2: y: 60..80
# Item 3: y: 115..135
# Item 4: y: 170..190
# Item 5: y: 225..245
# Item 6: y: 280..300
# Item 7: y: 335..355
# Item 8: y: 390..410
# Item 9: y: 445..465
# Item 10: y: 505..525
# Item 11: y: 560..580
# Item 12: y: 615..635
# Item 13: y: 670..690
# Total: y: 730..750

for ($i = 1; $i -le 13; $i++) {
    $y = 10 + ($i - 1) * 56
    RenderAscii 195 ($y - 5) 40 18 "Leg $i Odds"
}

RenderAscii 185 730 50 20 "Total Accumulated Odds"

$bmp.Dispose()
