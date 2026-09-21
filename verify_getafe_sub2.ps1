Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

function PrintBox($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 150) { $row += "#" }
            elseif ($lum -gt 85) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

# 1X2 Malaga odds: x:325..365, y:28..45
PrintBox 325 28 40 17 "1X2 Malaga Digits"

# BTTS: Có vs Không
# Let's find exactly where Có and Không are in y:250..300
PrintBox 80 270 50 17 "BTTS Co Odds"
PrintBox 230 270 50 17 "BTTS Khong Odds"

# Hoa hoan tien (Draw No Bet) in y:320..365
PrintBox 10 320 370 45 "Draw No Bet Full Panel"

# Corners in y:345..375, x:450..750
PrintBox 480 345 60 20 "Corners Tai Odds"
PrintBox 680 345 60 20 "Corners Xiu Odds"

$bmp.Dispose()
