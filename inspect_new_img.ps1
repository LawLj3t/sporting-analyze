Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\93382515-f20b-4586-928e-7f8e99f77ca1.png")
Write-Output "Image Dimensions: $($bmp.Width) x $($bmp.Height)"

# Let's inspect rows with ASCII
for ($y = 0; $y -lt $bmp.Height; $y += [Math]::Max(1, [int]($bmp.Height / 40))) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x += [Math]::Max(1, [int]($bmp.Width / 80))) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 90) { $row += "#" }
        elseif ($lum -lt 160) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
}

$bmp.Dispose()
