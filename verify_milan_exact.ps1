Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\a987b250-e2a9-4fb4-82b2-7eb5a307a621.png")

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
PrintBox 90 28 45 17 "1X2 AC Milan"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Lecce"

# HDP Row 3: Milan -1.5 vs Lecce +1.5
PrintBox 530 103 45 17 "Milan -1.5 Odds"
PrintBox 715 103 45 17 "Lecce +1.5 Odds"

# HDP Row 4: Milan -1.25 vs Lecce +1.25
PrintBox 530 128 45 17 "Milan -1.25 Odds"
PrintBox 715 128 45 17 "Lecce +1.25 Odds"

# FT O/U Row 0: Tai 2.5 vs Xiu 2.5
PrintBox 160 60 45 17 "Tai 2.5 Odds"
PrintBox 345 60 45 17 "Xiu 2.5 Odds"

$bmp.Dispose()
