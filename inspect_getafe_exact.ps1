Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

function PrintSub($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title (x:$rx y:$ry w:$rw h:$rh) ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            if ($x -lt $bmp.Width -and $y -lt $bmp.Height) {
                $c = $bmp.GetPixel($x, $y)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 150) { $row += "#" }
                elseif ($lum -gt 85) { $row += "." }
                else { $row += " " }
            }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

# 1X2 three columns: Getafe (x:0..120), Hoa (x:120..240), Malaga (x:240..370), y:15..50
PrintSub 10 20 110 25 "1X2 Getafe"
PrintSub 130 20 110 25 "1X2 Hoa"
PrintSub 250 20 120 25 "1X2 Malaga"

# Bottom Left: y:215..376
# Let's crop y:215..280 and y:280..376
PrintSub 10 220 360 40 "Bottom Left 1"
PrintSub 10 260 360 40 "Bottom Left 2"
PrintSub 10 300 360 40 "Bottom Left 3"
PrintSub 10 340 360 35 "Bottom Left 4"

# FT HDP lines: x:385..760, y:20..160
PrintSub 385 20 375 30 "HDP Row 0"
PrintSub 385 50 375 25 "HDP Row 1"
PrintSub 385 75 375 25 "HDP Row 2"
PrintSub 385 100 375 25 "HDP Row 3"
PrintSub 385 125 375 25 "HDP Row 4"

# Corners: x:385..760, y:330..376
PrintSub 385 330 375 45 "Corners Row"

$bmp.Dispose()
