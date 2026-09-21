Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\304ed8b5-2305-4274-9581-abc7fefef604.png")

Write-Output "--- EXACT PIXELS (Line 1, y:12..24) ---"
for ($y = 12; $y -lt 24; $y++) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 90) { $row += "#" }
        elseif ($lum -lt 150) { $row += "." }
        else { $row += " " }
    }
    Write-Output ("y:{0,2} | {1}" -f $y, $row)
}

Write-Output "--- EXACT PIXELS (Line 2, y:32..44) ---"
for ($y = 32; $y -lt 44; $y++) {
    $row = ""
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -lt 90) { $row += "#" }
        elseif ($lum -lt 150) { $row += "." }
        else { $row += " " }
    }
    Write-Output ("y:{0,2} | {1}" -f $y, $row)
}

$bmp.Dispose()
