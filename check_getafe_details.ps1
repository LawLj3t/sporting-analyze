Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

function PrintSub($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title (x:$rx y:$ry w:$rw h:$rh) ==="
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

# 1X2 Row
PrintSub 0 0 380 50 "1X2 Full Header & Odds"

# Bottom Left
PrintSub 0 215 380 160 "Bottom Left Full"

# Bottom Right Corners
PrintSub 380 320 386 56 "Bottom Right Corners"

$bmp.Dispose()
