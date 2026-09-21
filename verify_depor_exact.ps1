Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\86190556-75ca-4edd-be94-a0ee6899903a.png")

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
PrintBox 90 28 45 17 "1X2 Dep La Coruna"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Real Betis"

# FT O/U Row 2: Tai 2.5 vs Xiu 2.5
PrintBox 160 110 45 17 "Tai 2.5 Odds"
PrintBox 345 110 45 17 "Xiu 2.5 Odds"

# FT HDP Row 2: Dep +0.5 vs Betis -0.5
PrintBox 530 78 45 17 "Dep +0.5 Odds"
PrintBox 715 78 45 17 "Betis -0.5 Odds"

# BTTS: y:250..290, x:130..190 & x:330..375
PrintBox 140 260 50 17 "BTTS Left Odds"
PrintBox 330 260 50 17 "BTTS Right Odds"

# Corners:
PrintBox 500 370 50 20 "Corners Tai Odds"
PrintBox 690 370 50 20 "Corners Xiu Odds"

$bmp.Dispose()
