Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

function PrintGrid($rx, $ry, $rw, $rh, $title) {
    Write-Output "=== $title ==="
    # Print column header
    $header1 = "   "
    $header2 = "   "
    for ($x = 0; $x -lt $rw; $x++) {
        $header1 += [string]([int]($x / 10))
        $header2 += [string]($x % 10)
    }
    Write-Output $header1
    Write-Output $header2
    
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $lineNum = "{0,2} " -f ($y - $ry)
        $row = $lineNum
        for ($x = $rx; $x -lt ($rx + $rw); $x++) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 150) { $row += "#" }
            elseif ($lum -gt 85) { $row += "." }
            else { $row += " " }
        }
        Write-Output $row
    }
}

PrintGrid 345 30 25 12 "1X2 Malaga Digits Detailed"
PrintGrid 725 80 25 12 "Malaga +0.5 Odds Detailed"
PrintGrid 540 347 25 12 "Corners Over 8.5 Detailed"
PrintGrid 728 347 25 12 "Corners Under 8.5 Detailed"

$bmp.Dispose()
