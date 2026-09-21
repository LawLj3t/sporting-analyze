Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\f94ae6fd-a0fe-4804-934c-4971a1f27272.png")

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
PrintBox 90 28 45 17 "1X2 Frosinone"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Como"

# HDP Row 1: Frosinone +0.75 vs Como -0.75
PrintBox 530 53 45 17 "Frosinone +0.75 Odds"
PrintBox 715 53 45 17 "Como -0.75 Odds"

# HDP Row 2: Frosinone +1.0 vs Como -1.0
PrintBox 530 78 45 17 "Frosinone +1.0 Odds"
PrintBox 715 78 45 17 "Como -1.0 Odds"

# HDP Row 0: Frosinone +0.5 vs Como -0.5
PrintBox 530 28 45 17 "Frosinone +0.5 Odds"
PrintBox 715 28 45 17 "Como -0.5 Odds"

$bmp.Dispose()
