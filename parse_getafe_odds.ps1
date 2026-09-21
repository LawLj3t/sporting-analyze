Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

function PrintBox($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 150) { $row += "#" }
            elseif ($lum -gt 85) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output $row }
    }
}

# 1X2 Getafe odds: x:80..125, y:30..45
PrintBox 80 28 45 17 "1X2 Getafe"
# 1X2 Hoa odds: x:205..250, y:30..45
PrintBox 205 28 45 17 "1X2 Hoa"
# 1X2 Malaga odds: x:330..375, y:30..45
PrintBox 330 28 45 17 "1X2 Malaga"

# FT Asian Handicap:
# Row 0 (Getafe -1.0 vs Malaga +1.0)
PrintBox 530 28 45 17 "HDP Row 0 Left (Getafe -1.0)"
PrintBox 715 28 45 17 "HDP Row 0 Right (Malaga +1.0)"

# Row 1 (Getafe -0.75 vs Malaga +0.75)
PrintBox 530 53 45 17 "HDP Row 1 Left (Getafe -0.75)"
PrintBox 715 53 45 17 "HDP Row 1 Right (Malaga +0.75)"

# Row 2 (Getafe -0.5 vs Malaga +0.5)
PrintBox 530 78 45 17 "HDP Row 2 Left (Getafe -0.5)"
PrintBox 715 78 45 17 "HDP Row 2 Right (Malaga +0.5)"

# Row 3 (Getafe -0.25 vs Malaga +0.25)
PrintBox 530 103 45 17 "HDP Row 3 Left (Getafe -0.25)"
PrintBox 715 103 45 17 "HDP Row 3 Right (Malaga +0.25)"

# Row 4 (Getafe 0 vs Malaga 0)
PrintBox 530 128 45 17 "HDP Row 4 Left (Getafe 0)"
PrintBox 715 128 45 17 "HDP Row 4 Right (Malaga 0)"

# Bottom Left:
# What are the rows in Bottom Left?
# Let's check text around y:220..360
$bmp.Dispose()
