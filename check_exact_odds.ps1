Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\b3a53b86-51a9-4df3-af21-edb005c7e277.png")

function PrintSub($bmp, $rx, $ry, $rw, $rh, $name) {
    Write-Output "=== $name (x:$rx..$($rx+$rw), y:$ry..$($ry+$rh)) ==="
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

# Check Sunderland 1X2 odds at x:335..370, y:28..45
PrintSub $bmp 335 28 35 17 "Sunderland 1X2 Odds"

# Check Draw 1X2 odds at x:215..245, y:28..45
PrintSub $bmp 215 28 35 17 "Draw 1X2 Odds"

# Check Man City 1X2 odds at x:95..125, y:28..45
PrintSub $bmp 95 28 35 17 "Man City 1X2 Odds"

# Check BTTS Co at x:155..185, y:375..392
PrintSub $bmp 155 375 35 17 "BTTS Yes Odds"

# Check BTTS Khong at x:335..370, y:375..392
PrintSub $bmp 335 375 35 17 "BTTS No Odds"

$bmp.Dispose()
