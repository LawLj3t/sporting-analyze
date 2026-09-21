Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\ef58c555-4e2c-41cf-ab69-1996a751299f.png")

for ($y = 44; $y -lt 60; $y++) {
    $row = ""
    for ($x = 155; $x -lt 195; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 100) { $row += "#" }
        elseif ($lum -lt 160) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
}

$bmp.Dispose()
