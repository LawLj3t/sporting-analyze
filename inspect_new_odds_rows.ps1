Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\ef58c555-4e2c-41cf-ab69-1996a751299f.png")

function DumpRegion($y0, $h, $title) {
    Write-Output "=== $title ==="
    for ($y = $y0; $y -lt ($y0 + $h); $y += 2) {
        $row = ""
        for ($x = 0; $x -lt $bmp.Width; $x += 2) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 90) { $row += "#" }
            elseif ($lum -lt 160) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
    }
}

# Row 1 (HDP 0): y: 15..40
DumpRegion 15 25 "Row 0 (HDP 0)"

# Row 2 (HDP 0.25): y: 40..65
DumpRegion 40 25 "Row 1 (HDP 0.25)"

# Row 3 (HDP 0.5): y: 65..90
DumpRegion 65 25 "Row 2 (HDP 0.5)"

# Row 4 (HDP 0.75): y: 90..115
DumpRegion 90 25 "Row 3 (HDP 0.75)"

# Row 5 (HDP 1.0): y: 115..140
DumpRegion 115 25 "Row 4 (HDP 1.0)"

$bmp.Dispose()
