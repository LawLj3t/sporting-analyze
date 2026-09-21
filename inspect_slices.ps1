Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\304ed8b5-2305-4274-9581-abc7fefef604.png")

function SliceChars($y0, $h, $xStart, $xEnd, $step) {
    for ($y = $y0; $y -lt ($y0 + $h); $y++) {
        $row = ""
        for ($x = $xStart; $x -lt $xEnd; $x += $step) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 90) { $row += "#" }
            elseif ($lum -lt 150) { $row += "." }
            else { $row += " " }
        }
        Write-Output ("y:{0,2} | {1}" -f $y, $row)
    }
}

Write-Output "=== LINE 1 text (x: 55 to 195) ==="
SliceChars 13 9 55 195 1

Write-Output "=== LINE 2 text (x: 55 to 195) ==="
SliceChars 33 9 55 195 1

$bmp.Dispose()
