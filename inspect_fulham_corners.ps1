Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

function PrintSub($bmp, $rx, $ry, $rw, $rh, $name) {
    Write-Output "=== $name (x:$rx..$($rx+$rw), y:$ry..$($ry+$rh)) ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y += 1) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x += 1) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 150) { $row += "#" }
            elseif ($lum -gt 85) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

# Corner section is at y: 380 to 425
PrintSub $bmp 350 380 420 45 "Corner Market Row"

# Also check BTTS (Ca 2 doi ghi ban)
PrintSub $bmp 0 240 380 45 "BTTS Market Row"

# Check 1X2
PrintSub $bmp 0 15 380 35 "1X2 Row"

$bmp.Dispose()
