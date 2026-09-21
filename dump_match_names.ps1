Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\920aea6b-2e0a-437e-98fe-054c172b9b4c.png")

# Let's inspect the text area from X: 45 to 216, for each match
# Match 1: Y: 0 to 100
# Match 2: Y: 100 to 210
# Match 3: Y: 210 to 320
# Match 4: Y: 320 to 430
# Match 5: Y: 430 to 540
# Match 6: Y: 540 to 640

function DumpTextRegion($y1, $y2, $label) {
    Write-Output "================ $label ================"
    for ($y = $y1; $y -le $y2; $y += 2) {
        $line = ""
        for ($x = 45; $x -lt 216; $x += 2) {
            $c = $bmp.GetPixel($x, $y)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -lt 130) {
                $line += "#"
            } else {
                $line += " "
            }
        }
        if ($line.Trim().Length -gt 0) {
            Write-Output ("Y:{0,3} | {1}" -f $y, $line)
        }
    }
}

DumpTextRegion 10 90 "Match 1"
DumpTextRegion 100 190 "Match 2"
DumpTextRegion 200 300 "Match 3"
DumpTextRegion 310 410 "Match 4"
DumpTextRegion 420 520 "Match 5"
DumpTextRegion 530 630 "Match 6"

$bmp.Dispose()
