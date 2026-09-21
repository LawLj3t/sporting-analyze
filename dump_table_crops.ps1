Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

function DumpCrop($rx, $ry, $rw, $rh, $title) {
    Write-Output "================ $title (x:$rx y:$ry w:$rw h:$rh) ================"
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

# Dump left side main betting block:
DumpCrop 0 10 370 200 "LEFT PANEL (HDP & O/U & 1X2)"

# Dump right side main betting block:
DumpCrop 375 10 390 200 "RIGHT PANEL TOP (HDP & O/U)"

# Dump right side middle & bottom:
DumpCrop 375 210 390 150 "RIGHT PANEL MIDDLE (Total Goals / BTTS)"

$bmp.Dispose()
