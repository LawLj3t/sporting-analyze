Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\095d8fb6-c5d3-472d-a6a7-17d300902d43.png")

# Let's inspect the 5 matches in the H2H table:
# Match 1: y: 215 to 265
# Match 2: y: 268 to 318
# Match 3: y: 320 to 370
# Match 4: y: 372 to 422
# Match 5: y: 424 to 475

for ($m = 0; $m -lt 5; $m++) {
    $y0 = 215 + $m * 52
    Write-Output "=== MATCH $($m + 1) (y: $y0) ==="
    # Score is at x: 310..340, y: $y0 .. ($y0+50)
    for ($y = $y0; $y -lt ($y0 + 45); $y += 3) {
        $row = ""
        for ($x = 20; $x -lt 345; $x += 3) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 90) { $row += "#" }
            elseif ($lum -lt 160) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
    }
}

$bmp.Dispose()
