Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\6528155a-ebf0-43f6-b2da-17688acc6e2c.png")

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
PrintBox 90 28 45 17 "1X2 Juventus"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Atalanta"

# HDP Row 2: Juventus -0.75 vs Atalanta +0.75
PrintBox 530 78 45 17 "Juve -0.75 Odds"
PrintBox 715 78 45 17 "Atalanta +0.75 Odds"

# HDP Row 3: Juventus -0.5 vs Atalanta +0.5
PrintBox 530 103 45 17 "Juve -0.5 Odds"
PrintBox 715 103 45 17 "Atalanta +0.5 Odds"

# HDP Row 4: Juventus -0.25 vs Atalanta +0.25
PrintBox 530 128 45 17 "Juve -0.25 Odds"
PrintBox 715 128 45 17 "Atalanta +0.25 Odds"

# BTTS:
PrintBox 140 260 50 17 "BTTS Co Odds"
PrintBox 330 260 50 17 "BTTS Khong Odds"

$bmp.Dispose()
