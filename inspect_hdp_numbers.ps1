Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\a600665e-208e-497f-b94e-79dd6dadf85c.png")

# Let's inspect the Handicap rows on the right side:
# Row 0 (HDP 0): y: 30..45
# Row 1 (HDP 0/0.5): y: 55..70
# Row 2 (HDP 0.5): y: 80..95

function InspectNumberBox($rx, $ry, $rw, $rh, $label) {
    Write-Output "=== $label (x:$rx y:$ry w:$rw h:$rh) ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 90) { $row += "#" }
            elseif ($lum -lt 150) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
    }
}

# HDP Row 0 odds:
InspectNumberBox 530 30 45 15 "Row0_Home_Odds"
InspectNumberBox 715 30 45 15 "Row0_Away_Odds"

# HDP Row 1 odds:
InspectNumberBox 530 55 45 15 "Row1_Home_Odds"
InspectNumberBox 715 55 45 15 "Row1_Away_Odds"

# HDP Row 2 odds:
InspectNumberBox 530 80 45 15 "Row2_Home_Odds"
InspectNumberBox 715 80 45 15 "Row2_Away_Odds"

$bmp.Dispose()
