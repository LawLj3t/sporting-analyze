Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\87dcd4c9-27c3-4797-b5ac-553a2cb6d2b2.png")

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
PrintBox 90 28 45 17 "1X2 Fiorentina"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Napoli"

# HDP Row 2: Fiorentina +0.25 vs Napoli -0.25
PrintBox 530 78 45 17 "Fiorentina +0.25 Odds"
PrintBox 715 78 45 17 "Napoli -0.25 Odds"

# HDP Row 3: Fiorentina +0.5 vs Napoli -0.5
PrintBox 530 103 45 17 "Fiorentina +0.5 Odds"
PrintBox 715 103 45 17 "Napoli -0.5 Odds"

# HDP Row 1: Fiorentina 0 vs Napoli 0
PrintBox 530 53 45 17 "Fiorentina 0 Odds"
PrintBox 715 53 45 17 "Napoli 0 Odds"

# FT O/U Row 1: Tai 2.5 vs Xiu 2.5
PrintBox 160 85 45 17 "Tai 2.5 Odds"
PrintBox 345 85 45 17 "Xiu 2.5 Odds"

$bmp.Dispose()
