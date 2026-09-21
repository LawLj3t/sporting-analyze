Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\b3a53b86-51a9-4df3-af21-edb005c7e277.png")

function PrintBoxAscii($bmp, $rx, $ry, $rw, $rh, $title) {
    Write-Output "`n========================================================"
    Write-Output "[$title] (x:$rx, y:$ry, w:$rw, h:$rh)"
    Write-Output "========================================================"
    for ($y = $ry; $y -lt ($ry + $rh); $y += 1) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x += 1) {
            if ($x -lt $bmp.Width -and $y -lt $bmp.Height) {
                $c = $bmp.GetPixel($x, $y)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 150) { $row += "#" }
                elseif ($lum -gt 85) { $row += "." }
                else { $row += " " }
            }
        }
        if ($row.Trim() -ne "") {
            Write-Output $row
        }
    }
}

# 1. 1X2 Header & Odds
PrintBoxAscii $img 0 0 380 50 "Left Header & 1X2"

# 2. Left O/U Header & Odds (y:50..210)
PrintBoxAscii $img 0 50 380 160 "Left FT Total Goals O/U"

# 3. Left Lower Market Header (y:210..240)
PrintBoxAscii $img 0 210 380 30 "Left Lower Header"

# 4. Left Lower Market Rows (y:240..350)
PrintBoxAscii $img 0 240 380 110 "Left Lower Rows"

# 5. BTTS (Both teams to score) (y:350..414)
PrintBoxAscii $img 0 350 380 64 "Left BTTS"

# 6. Right Asian Handicap Header & Rows (y:0..160)
PrintBoxAscii $img 380 0 379 160 "Right FT Asian Handicap"

# 7. Right Mid Header (y:160..190)
PrintBoxAscii $img 380 160 379 30 "Right Mid Header"

# 8. Right Mid Rows (y:190..370)
PrintBoxAscii $img 380 190 379 180 "Right Mid Rows"

# 9. Right Bottom Header & Rows (y:370..414)
PrintBoxAscii $img 380 370 379 44 "Right Bottom"

$img.Dispose()
