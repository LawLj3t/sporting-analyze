Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\920aea6b-2e0a-437e-98fe-054c172b9b4c.png")

# Let's inspect the text pixel by pixel in row 1, 2, 3, 4, 5, 6.
# Let's create an inverted and high-contrast version of the entire image and save it as PNG.
$highContrast = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)

for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        # If lum is dark (text), make it black, else white
        if ($lum -lt 140) {
            $highContrast.SetPixel($x, $y, [System.Drawing.Color]::Black)
        } else {
            $highContrast.SetPixel($x, $y, [System.Drawing.Color]::White)
        }
    }
}

$highContrast.Save("C:\sporting analyze\betslip-crops\seriec_bw.png", [System.Drawing.Imaging.ImageFormat]::Png)
$highContrast.Dispose()
$bmp.Dispose()
Write-Output "Created B/W image."
