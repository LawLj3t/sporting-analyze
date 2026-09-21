Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

function PrintSubDense($bmp, $rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 90) { $row += "#" }
            elseif ($lum -lt 150) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,3} | {1}" -f $y, $row) }
    }
}

# 1. Corner Header (x:380..520, y:360..385)
PrintSubDense $bmp 380 360 160 25 "Corner Title"

# 2. Tai 10.0 (x:390..450, y:388..408)
PrintSubDense $bmp 390 388 60 20 "Tai 10.0 label"

# 3. Tai 10.0 Odds (x:525..575, y:388..408)
PrintSubDense $bmp 525 388 50 20 "Tai 10.0 Odds"

# 4. Xiu 10.0 (x:575..650, y:388..408)
PrintSubDense $bmp 575 388 75 20 "Xiu 10.0 label"

# 5. Xiu 10.0 Odds (x:710..760, y:388..408)
PrintSubDense $bmp 710 388 50 20 "Xiu 10.0 Odds"

$bmp.Dispose()
