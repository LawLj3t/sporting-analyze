Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\a600665e-208e-497f-b94e-79dd6dadf85c.png")

function InspectColorBox($rx, $ry, $rw, $rh, $label) {
    Write-Output "=== $label ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            # If text is red (R > 150, G < 100):
            if ($c.R -gt 150 -and $c.G -lt 100) { $row += "R" }
            # If text is dark (black/gray text on light bg):
            elseif ($c.R -lt 100 -and $c.G -lt 100) { $row += "#" }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
    }
}

InspectColorBox 530 30 50 15 "Row0_Home_Odds (CA Aldosivi 0)"
InspectColorBox 715 30 50 15 "Row0_Away_Odds (Atletico Tucuman 0)"
InspectColorBox 530 55 50 15 "Row1_Home_Odds (CA Aldosivi +0/0.5)"
InspectColorBox 715 55 50 15 "Row1_Away_Odds (Atletico Tucuman -0/0.5)"
InspectColorBox 530 80 50 15 "Row2_Home_Odds (CA Aldosivi +0.5)"
InspectColorBox 715 80 50 15 "Row2_Away_Odds (Atletico Tucuman -0.5)"

$bmp.Dispose()
