Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\df0ae098-5e07-432b-991e-b6c5dc42163b.png")

function PrintSub($rx, $ry, $rw, $rh, $title) {
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

# Fulham 1X2 odds (x:90..130, y:28..45)
PrintSub 90 28 40 17 "Fulham 1X2 Odds"

# HDP Row 0: Left & Right odds
PrintSub 530 28 45 20 "HDP Row 0 Left Odds"
PrintSub 710 28 45 20 "HDP Row 0 Right Odds"

# HDP Row 1: Left & Right odds
PrintSub 530 53 45 20 "HDP Row 1 Left Odds"
PrintSub 710 53 45 20 "HDP Row 1 Right Odds"

# HDP Row 2: Left & Right odds
PrintSub 530 78 45 20 "HDP Row 2 Left Odds"
PrintSub 710 78 45 20 "HDP Row 2 Right Odds"

$bmp.Dispose()
