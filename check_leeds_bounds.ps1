Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\28d1c3ac-2e0f-494a-badd-fb0655e1a4d3.png")

function PrintDigits($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title (x:$rx, y:$ry, w:$rw, h:$rh) ==="
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

# Leeds -0.5/1.0 Odds (Row 2, y around 80..95)
PrintDigits 530 80 40 18 "Leeds -0.5/1.0 Odds"
PrintDigits 705 80 40 18 "Crystal Palace +0.5/1.0 Odds"

# Leeds -0.5 Odds (Row 3, y around 105..120)
PrintDigits 530 105 40 18 "Leeds -0.5 Odds"
PrintDigits 705 105 40 18 "Crystal Palace +0.5 Odds"

# Leeds -0/0.5 Odds (Row 4, y around 130..145)
PrintDigits 530 130 40 18 "Leeds -0/0.5 Odds"
PrintDigits 705 130 40 18 "Crystal Palace +0/0.5 Odds"

# Corners Odds (y around 380..395)
PrintDigits 530 380 40 18 "Corners Over Odds"
PrintDigits 705 380 40 18 "Corners Under Odds"

$bmp.Dispose()
