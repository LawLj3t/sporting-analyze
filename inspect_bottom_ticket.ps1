Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\550a6f74\2081ce09-2323-4cb4-b6a0-82c96512c56a.png")

# Let's inspect bottom area y: 390 to 433
for ($y = 390; $y -lt $bmp.Height; $y++) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 85) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
}

$bmp.Dispose()
