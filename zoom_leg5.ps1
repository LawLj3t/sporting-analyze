Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\sporting analyze\betslip-crops\leg5_crop.png")

for ($y = 0; $y -lt $bmp.Height; $y++) {
    $row = ""
    for ($x = 10; $x -lt 150; $x++) {
        $p = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $p.R + 0.587 * $p.G + 0.114 * $p.B)
        if ($lum -lt 50) { $row += "#" }
        elseif ($lum -lt 100) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}
$bmp.Dispose()
