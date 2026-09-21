Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\be5ee2f9\6254151c-da75-4413-bc55-1c586e93aa7a.png")

function RenderAsciiArea($x, $y, $w, $h, $label) {
    Write-Output "`n=== $label ==="
    for ($j = $y; $j -lt ($y + $h); $j += 1) {
        $line = ""
        for ($i = $x; $i -lt ($x + $w); $i += 1) {
            if ($i -ge 0 -and $i -lt $bmp.Width -and $j -ge 0 -and $j -lt $bmp.Height) {
                $c = $bmp.GetPixel($i, $j)
                if ($c.G -gt 130 -and $c.G -gt ($c.R * 1.3)) {
                    $line += "#"
                } elseif ($c.G -gt 80 -and $c.G -gt ($c.R * 1.1)) {
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

# Odds are in right column x: 220 to 265
# Let's inspect odds for each leg
RenderAsciiArea 220 0 45 20 "Leg 1 (Getafe) Odds"
RenderAsciiArea 220 240 45 20 "Leg 5 (Genoa) Odds"
RenderAsciiArea 220 300 45 20 "Leg 6 (Paderborn) Odds"
RenderAsciiArea 220 360 45 20 "Leg 7 (Auxerre) Odds"
RenderAsciiArea 220 420 45 20 "Leg 8 (Lille) Odds"
RenderAsciiArea 220 480 45 20 "Leg 9 (Marseille) Odds"
RenderAsciiArea 220 540 45 20 "Leg 10 (Juventus) Odds"
RenderAsciiArea 220 600 45 20 "Leg 11 (Leeds) Odds"
RenderAsciiArea 210 655 55 25 "Total Odds"

$bmp.Dispose()
