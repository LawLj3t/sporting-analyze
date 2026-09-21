Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

Write-Output "Image Size: $($bmp.Width) x $($bmp.Height)"

# Let's inspect the layout:
# Top headers: y: 0 to 35
# Rows on left (x: 0 to 370)
# Rows on right (x: 375 to 765)

# Let's write an ASCII renderer for the left side and right side at key intervals
function DumpRegion($x0, $y0, $w, $h, $stepX, $stepY) {
    for ($y = $y0; $y -lt ($y0 + $h); $y += $stepY) {
        $row = ""
        for ($x = $x0; $x -lt ($x0 + $w); $x += $stepX) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 100) { $row += "#" }
            elseif ($lum -lt 170) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
    }
}

Write-Output "--- LEFT SIDE (x:10..360, y:10..180) ---"
# Let's check left side headers and rows
$bmp.Dispose()
