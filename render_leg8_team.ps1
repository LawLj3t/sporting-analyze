Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\sporting analyze\betslip-crops\leg8_crop.png")

for ($y = 35; $y -lt 44; $y++) {
    $row = ""
    for ($x = 20; $x -lt 180; $x++) {
        $p = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $p.R + 0.587 * $p.G + 0.114 * $p.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 90) { $row += "." }
        else { $row += " " }
    }
    Write-Output $row
}

$bmp.Dispose()
