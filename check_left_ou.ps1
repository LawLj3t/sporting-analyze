Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

# Let's inspect Left O/U odds column:
# Over odds are around x: 155 to 190
# Under odds are around x: 330 to 365
# y levels:
# row 1 (2.5): y: 80
# row 2 (2.5/3.0): y: 106
# row 3 (3.0): y: 132
# row 4 (3.0/3.5): y: 158
# row 5 (3.5): y: 184

for ($row = 0; $row -lt 5; $row++) {
    $y0 = 75 + $row * 26
    Write-Output "--- Row $row (y: $y0) ---"
    # Print Over odds (x: 150..190)
    $overStr = ""
    # Print Under odds (x: 330..370)
    $underStr = ""
}

# Let's crop x: 150..370, y: 70..200 and OCR directly with labels
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(0, 70, 370, 130)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\left_ou_all.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$bmp.Dispose()
