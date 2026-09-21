Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\ebcd726c-d908-42d2-ba24-9bb703b4305a.png")

# Let's write an ASCII renderer for sub-rectangles
function PrintAscii($bmp, $rx, $ry, $rw, $rh, $name) {
    Write-Output "===== $name (x:$rx, y:$ry, w:$rw, h:$rh) ====="
    for ($y = $ry; $y -lt ($ry + $rh); $y += 1) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x += 1) {
            if ($x -lt $bmp.Width -and $y -lt $bmp.Height) {
                $c = $bmp.GetPixel($x, $y)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                # Dark background, white/bright text
                if ($lum -gt 150) {
                    $row += "#"
                } elseif ($lum -gt 80) {
                    $row += "."
                } else {
                    $row += " "
                }
            }
        }
        if ($row.Trim() -ne "") {
            Write-Output $row
        }
    }
}

# The ticket is width 261.
# On each leg (height ~59 pixels):
# Right side has the odds (e.g. x: 215..255, y: y..y+25)
# Left side has Selection (x: 25..200, y: y+5..y+22)
# Market line (x: 25..200, y: y+23..y+38)
# Match line (x: 25..200, y: y+39..y+54)

for ($i = 0; $i -lt 7; $i++) {
    $y = [int]($i * 59.3)
    Write-Output "`n************************************************"
    Write-Output "CHECKING LEG $i (y=$y)"
    Write-Output "************************************************"
    
    # Selection text (top left of leg)
    PrintAscii $img 25 ($y + 4) 180 18 "Leg $i Selection"
    
    # Odds (top right of leg)
    PrintAscii $img 205 ($y + 4) 52 18 "Leg $i Odds"
    
    # Market type (middle left of leg)
    PrintAscii $img 25 ($y + 22) 180 16 "Leg $i Market"
    
    # Match name (bottom left of leg)
    PrintAscii $img 25 ($y + 37) 180 17 "Leg $i Match"
}

$img.Dispose()
