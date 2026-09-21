Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\4e63a97b-02ef-4c2c-acb0-8fe2e4a5b29e.png")

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
PrintBox 90 28 45 17 "1X2 Valencia"
PrintBox 210 28 45 17 "1X2 Hoa"
PrintBox 330 28 45 17 "1X2 Real Sociedad"

# HDP Row 2: Valencia 0 vs Real Sociedad 0
PrintBox 530 78 45 17 "Valencia 0 Odds"
PrintBox 715 78 45 17 "Sociedad 0 Odds"

# HDP Row 4: Valencia +0.5 vs Real Sociedad -0.5
PrintBox 530 128 45 17 "Valencia +0.5 Odds"
PrintBox 715 128 45 17 "Sociedad -0.5 Odds"

# Corners:
PrintBox 420 350 70 20 "Corners Line Text"
PrintBox 510 350 45 20 "Corners Tai Odds"
PrintBox 715 350 45 20 "Corners Xiu Odds"

$bmp.Dispose()
