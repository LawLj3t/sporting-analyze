Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

# Inspect the corner row at y: 390..410
for ($y = 390; $y -lt 410; $y += 2) {
    $row = ""
    for ($x = 380; $x -lt 760; $x += 4) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 80) { $row += "." }
        else { $row += " " }
    }
    Write-Output ("y:{0,3} | {1}" -f $y, $row)
}

$bmp.Dispose()
