Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\457d7641-9fa6-4879-b199-f44bab36f406.png")

function PrintBox($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            if ($x -lt $bmp.Width -and $y -lt $bmp.Height) {
                $c = $bmp.GetPixel($x, $y)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 150) { $row += "#" }
                elseif ($lum -gt 85) { $row += "." }
                else { $row += " " }
            }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

# 1X2 Atletico: x:90..130, y:28..45
PrintBox 90 28 40 17 "1X2 Atletico"

# 1X2 Real Madrid: x:330..375, y:28..45
PrintBox 330 28 45 17 "1X2 Real Madrid"

# HDP Row 2 Left (Atletico +0.5): x:530..575, y:78..95
PrintBox 530 78 45 17 "HDP Atletico +0.5"

# HDP Row 2 Right (Real Madrid -0.5): x:710..755, y:78..95
PrintBox 710 78 45 17 "HDP Real Madrid -0.5"

# BTTS: y:230..260, x:140..190 & x:330..375
PrintBox 140 240 50 17 "BTTS Co Odds"
PrintBox 330 240 50 17 "BTTS Khong Odds"

# Corners Tai 10.0: x:515..560, y:390..410
PrintBox 515 390 45 20 "Corners Tai 10.0"
PrintBox 710 390 45 20 "Corners Xiu 10.0"

$bmp.Dispose()
