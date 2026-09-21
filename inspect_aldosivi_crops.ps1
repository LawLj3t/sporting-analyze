Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\a600665e-208e-497f-b94e-79dd6dadf85c.png")

function DumpCropAscii($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title (x:$rx y:$ry w:$rw h:$rh) ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y += 2) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x += 2) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 90) { $row += "#" }
            elseif ($lum -lt 150) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
    }
}

# Left side: 1X2 & O/U (x:0..370, y:0..268)
DumpCropAscii 0 20 370 120 "LEFT PANEL TOP (1X2 & O/U)"
DumpCropAscii 0 130 370 135 "LEFT PANEL BOTTOM (BTTS & others)"

# Right side: Handicap (x:375..766, y:0..130)
DumpCropAscii 375 0 390 130 "RIGHT PANEL TOP (HDP)"

# Right side: Total Goals (x:375..766, y:130..268)
DumpCropAscii 375 130 390 135 "RIGHT PANEL BOTTOM (Total Goals)"

$bmp.Dispose()
