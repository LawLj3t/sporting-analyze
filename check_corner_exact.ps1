Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\1b244b93-a154-4c10-976c-91c13b73ac3c.png")

function InspectColorText($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -gt 150 -and $c.G -lt 100) { $row += "R" }
            elseif ($c.R -lt 100 -and $c.G -lt 100) { $row += "#" }
            elseif ($c.R -lt 150 -and $c.G -lt 150) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
    }
}

# Top left O/U 9.5:
# Tai 9.5 odds: x: 150..200, y: 25..45
InspectColorText 150 25 50 18 "Tai 9.5 Corner Odds"

# Xiu 9.5 odds: x: 330..375, y: 25..45
InspectColorText 325 25 50 18 "Xiu 9.5 Corner Odds"

# Top right HT O/U 4.5:
# Tai 4.5 HT odds: x: 530..575, y: 25..45
InspectColorText 530 25 50 18 "Tai 4.5 HT Corner Odds"
# Xiu 4.5 HT odds: x: 715..765, y: 25..45
InspectColorText 715 25 50 18 "Xiu 4.5 HT Corner Odds"

# Corner HDP lines (y: 80..100):
# Aldosivi +1.0: x: 530..575
InspectColorText 530 80 50 18 "Aldosivi +1.0 Corner HDP Odds"
# Tucuman -1.0: x: 715..765
InspectColorText 715 80 50 18 "Tucuman -1.0 Corner HDP Odds"

$bmp.Dispose()
