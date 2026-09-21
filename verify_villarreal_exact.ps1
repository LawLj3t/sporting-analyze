Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\498a7ea8-d6f7-465d-9bfe-bba6d7ee4e42.png")

function PrintBox($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
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

# 1X2:
PrintBox 90 28 45 17 "1X2 Villarreal"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Levante"

# HDP Row 2 (Villarreal -1.0 vs Levante +1.0)
PrintBox 530 78 45 17 "Villarreal -1.0 Odds"
PrintBox 715 78 45 17 "Levante +1.0 Odds"

# HDP Row 3 (Villarreal -0.75 vs Levante +0.75)
PrintBox 530 103 45 17 "Villarreal -0.75 Odds"
PrintBox 715 103 45 17 "Levante +0.75 Odds"

# HDP Row 4 (Villarreal -0.5 vs Levante +0.5)
PrintBox 530 128 45 17 "Villarreal -0.5 Odds"
PrintBox 715 128 45 17 "Levante +0.5 Odds"

# Corners line and odds: x:420..755, y:350..385
PrintBox 420 350 70 20 "Corners Line Text"
PrintBox 510 350 45 20 "Corners Tai Odds"
PrintBox 715 350 45 20 "Corners Xiu Odds"

$bmp.Dispose()
