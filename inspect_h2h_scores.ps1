Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\095d8fb6-c5d3-472d-a6a7-17d300902d43.png")

for ($m = 0; $m -lt 5; $m++) {
    $y0 = 215 + $m * 52
    Write-Output "=== MATCH $($m + 1) SCORE ==="
    for ($y = $y0; $y -lt ($y0 + 45); $y++) {
        $row = ""
        for ($x = 315; $x -lt 340; $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 100) { $row += "#" }
            elseif ($lum -lt 170) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
    }
}

$bmp.Dispose()
