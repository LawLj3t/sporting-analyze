Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\304ed8b5-2305-4274-9581-abc7fefef604.png")

Write-Output "--- ICON 1 (Line 1: x:15..55, y:12..24) Colors ---"
for ($y = 12; $y -lt 24; $y++) {
    $row = ""
    for ($x = 15; $x -lt 55; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 200 -and $c.B -gt 200) { $row += "W" }
        elseif ($c.B -gt 150 -and $c.R -lt 100) { $row += "B" }
        elseif ($c.R -gt 150 -and $c.G -lt 100) { $row += "R" }
        elseif ($c.G -gt 150 -and $c.R -lt 100) { $row += "G" }
        elseif ($c.R -gt 150 -and $c.G -gt 150) { $row += "Y" }
        else { $row += "." }
    }
    Write-Output ("y:{0,2} | {1}" -f $y, $row)
}

Write-Output "--- ICON 2 (Line 2: x:15..55, y:32..44) Colors ---"
for ($y = 32; $y -lt 44; $y++) {
    $row = ""
    for ($x = 15; $x -lt 55; $x++) {
        $c = $bmp.GetPixel($x, $y)
        if ($c.R -gt 200 -and $c.B -gt 200) { $row += "W" }
        elseif ($c.B -gt 150 -and $c.R -lt 100) { $row += "B" }
        elseif ($c.R -gt 150 -and $c.G -lt 100) { $row += "R" }
        elseif ($c.G -gt 150 -and $c.R -lt 100) { $row += "G" }
        elseif ($c.R -gt 150 -and $c.G -gt 150) { $row += "Y" }
        else { $row += "." }
    }
    Write-Output ("y:{0,2} | {1}" -f $y, $row)
}

$bmp.Dispose()
