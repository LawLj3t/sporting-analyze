Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\93382515-f20b-4586-928e-7f8e99f77ca1.png")

# Sample some pixels across the image to see background and text colors
for ($y = 20; $y -lt 110; $y += 20) {
    for ($x = 20; $x -lt 360; $x += 40) {
        $c = $bmp.GetPixel($x, $y)
        Write-Output ("x:{0,3} y:{1,3} -> R:{2,3} G:{3,3} B:{4,3} Hex:{5}" -f $x, $y, $c.R, $c.G, $c.B, $c.Name)
    }
}

$bmp.Dispose()
