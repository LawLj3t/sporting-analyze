Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\4bff4fa5\5886e54b-fd52-4f15-b503-70f6711522e5.png")

function PrintBoxAscii($bmp, $rx, $ry, $rw, $rh, $title) {
    Write-Output "`n========================================================"
    Write-Output "[$title] (x:$rx, y:$ry, w:$rw, h:$rh)"
    Write-Output "========================================================"
    for ($y = $ry; $y -lt ($ry + $rh); $y += 2) {
        $row = ""
        for ($x = $rx; $x -lt ($rx + $rw); $x += 2) {
            if ($x -lt $bmp.Width -and $y -lt $bmp.Height) {
                $c = $bmp.GetPixel($x, $y)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 150) { $row += "#" }
                elseif ($lum -gt 85) { $row += "." }
                else { $row += " " }
            }
        }
        if ($row.Trim() -ne "") {
            Write-Output $row
        }
    }
}

PrintBoxAscii $bmp 0 0 $bmp.Width 100 "Header and Navigation"
PrintBoxAscii $bmp 0 100 $bmp.Width ($bmp.Height - 100) "Odds and Markets"

$bmp.Dispose()
