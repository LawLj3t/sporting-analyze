Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\304ed8b5-2305-4274-9581-abc7fefef604.png")

for ($y = 0; $y -lt $bmp.Height; $y += 2) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 100) { $row += "#" }
        elseif ($lum -lt 170) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}

# Also let's check with inverse if background is dark
Write-Output "--- INVERSE (DARK BG) ---"
for ($y = 0; $y -lt $bmp.Height; $y += 2) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 80) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}

$bmp.Dispose()
