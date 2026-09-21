Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

function PrintBox($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title (x:$rx y:$ry w:$rw h:$rh) ==="
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

# 1X2 Malaga: x:340..375, y:28..45
PrintBox 342 27 35 18 "1X2 Malaga Exact"

# Let's inspect Bottom Left:
# y:240 to 376, x:0 to 380
# What panels are there?
# Row at y:271 has 2.24 (at x:162) and 1.65 (at x:349) -> That's BTTS: Có @ 2.24, Không @ 1.65!
# Row at y:300..325: What is there?
PrintBox 0 295 380 25 "BL Row 1"
# Row at y:325..350:
PrintBox 0 320 380 25 "BL Row 2"
# Row at y:350..375:
PrintBox 0 345 380 25 "BL Row 3"

# Also FT HDP Row 2 Right (Malaga +0.5):
PrintBox 720 78 35 18 "Malaga +0.5 Odds"

# Corners Tai 8.5 odds: x:540..570, y:345..365
PrintBox 540 345 30 18 "Corners Tai 8.5 Odds"
PrintBox 725 345 30 18 "Corners Xiu 8.5 Odds"

$bmp.Dispose()
