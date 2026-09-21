Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\304ed8b5-2305-4274-9581-abc7fefef604.png")

function PrintLetterGrid($x0, $x1, $y0, $y1) {
    for ($y = $y0; $y -le $y1; $y++) {
        $line = ""
        for ($x = $x0; $x -le $x1; $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 60) { $line += "@" }
            elseif ($lum -lt 100) { $line += "#" }
            elseif ($lum -lt 140) { $line += "=" }
            elseif ($lum -lt 180) { $line += "." }
            else { $line += " " }
        }
        Write-Output ("{0,2}: {1}" -f $y, $line)
    }
}

Write-Output "=== LINE 1 (x: 55..185, y: 14..22) ==="
PrintLetterGrid 55 185 14 22

Write-Output "=== LINE 2 (x: 55..185, y: 34..42) ==="
PrintLetterGrid 55 185 34 42

$bmp.Dispose()
