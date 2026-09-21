Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\6ed653f7-900c-438d-b23c-25fb74167ddf.png")

function PrintDigits($bmp, $rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 145) { $row += "#" }
            elseif ($lum -gt 85) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

# Over Odds Row 1 (y around 110)
PrintDigits $bmp 150 108 40 18 "OU Row 1 Over Odds (x:150..190, y:108..126)"

# Over Odds Row 2 (y around 135)
PrintDigits $bmp 150 134 40 18 "OU Row 2 Over Odds (x:150..190, y:134..152)"

$bmp.Dispose()
