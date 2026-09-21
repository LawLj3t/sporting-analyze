Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\6ed653f7-900c-438d-b23c-25fb74167ddf.png")

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

# Print Asian Handicap text & odds for all 5 rows
# x: 380..757, y: 25..160
for ($row = 0; $row -lt 5; $row++) {
    $y = 30 + $row * 25
    PrintSub $bmp 385 $y 180 20 "HDP Row $row Left (Bournemouth)"
    PrintSub $bmp 535 $y 50 20 "HDP Row $row Odds Left"
    PrintSub $bmp 575 $y 140 20 "HDP Row $row Right (Liverpool)"
    PrintSub $bmp 715 $y 40 20 "HDP Row $row Odds Right"
}

# Print FT Total Goals text & odds for all 5 rows
# x: 0..380, y: 80..210
for ($row = 0; $row -lt 5; $row++) {
    $y = 85 + $row * 25
    PrintSub $bmp 10 $y 80 20 "OU Row $row Over text"
    PrintSub $bmp 150 $y 40 20 "OU Row $row Over Odds"
    PrintSub $bmp 195 $y 80 20 "OU Row $row Under text"
    PrintSub $bmp 335 $y 40 20 "OU Row $row Under Odds"
}

$bmp.Dispose()
