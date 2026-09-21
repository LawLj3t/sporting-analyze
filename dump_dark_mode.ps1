Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\93382515-f20b-4586-928e-7f8e99f77ca1.png")

for ($y = 10; $y -lt $bmp.Height; $y += 2) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x += 2) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 130) { $row += "#" }
        elseif ($lum -gt 70) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
}

$bmp.Dispose()
