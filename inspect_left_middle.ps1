Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\a600665e-208e-497f-b94e-79dd6dadf85c.png")

for ($y = 55; $y -lt 115; $y += 2) {
    $row = ""
    for ($x = 0; $x -lt 370; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 90) { $row += "#" }
        elseif ($lum -lt 150) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
}

$bmp.Dispose()
