Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\b3a53b86-51a9-4df3-af21-edb005c7e277.png")

# Let's inspect the title at y:215..240, x:0..380
for ($y = 215; $y -lt 240; $y++) {
    $row = ""
    for ($x = 0; $x -lt 380; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 85) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") {
        Write-Output $row
    }
}

# Also inspect BTTS title at y:350..370, x:0..380
Write-Output "--- BTTS TITLE ---"
for ($y = 350; $y -lt 370; $y++) {
    $row = ""
    for ($x = 0; $x -lt 380; $x++) {
        $c = $bmp.GetPixel($x, $y)
        $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
        if ($lum -gt 150) { $row += "#" }
        elseif ($lum -gt 85) { $row += "." }
        else { $row += " " }
    }
    if ($row.Trim() -ne "") {
        Write-Output $row
    }
}

$bmp.Dispose()
