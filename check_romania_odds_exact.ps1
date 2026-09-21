Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\0677a1fe-f693-4b98-9352-008ec46e2912.png")

function CheckBox($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            if ($c.R -gt 150 -and $c.G -lt 100) { $row += "R" }
            elseif ($c.R -lt 100 -and $c.G -lt 100) { $row += "#" }
            elseif ($c.R -lt 150 -and $c.G -lt 150) { $row += "." }
            else { $row += " " }
        }
        if ($row.Trim() -ne "") { Write-Output ("y:{0,2} | {1}" -f $y, $row) }
    }
}

# Left O/U 2.5, 2.75, 3.0
CheckBox 145 80 50 18 "Left Over 2.5"
CheckBox 325 80 50 18 "Left Under 2.5"
CheckBox 145 105 50 18 "Left Over 2.75"
CheckBox 325 105 50 18 "Left Under 2.75"
CheckBox 145 130 50 18 "Left Over 3.0"
CheckBox 325 130 50 18 "Left Under 3.0"

# Right HDP
CheckBox 525 25 50 18 "Right HDP Row 0 Home (-1.25)"
CheckBox 710 25 50 18 "Right HDP Row 0 Away (+1.25)"
CheckBox 525 50 50 18 "Right HDP Row 1 Home (-1.0)"
CheckBox 710 50 50 18 "Right HDP Row 1 Away (+1.0)"
CheckBox 525 75 50 18 "Right HDP Row 2 Home (-0.75)"
CheckBox 710 75 50 18 "Right HDP Row 2 Away (+0.75)"

$bmp.Dispose()
