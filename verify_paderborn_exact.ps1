Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\5e3e9fc9-8e78-4d93-9460-d0ab2ee9c385.png")

function RenderAscii($x, $y, $w, $h, $label) {
    Write-Output "`n========================================================"
    Write-Output "ASCII: $label (x:$x, y:$y, w:$w, h:$h)"
    Write-Output "========================================================"
    for ($j = $y; $j -lt ($y + $h); $j += 1) {
        $line = ""
        for ($i = $x; $i -lt ($x + $w); $i += 1) {
            if ($i -ge 0 -and $i -lt $bmp.Width -and $j -ge 0 -and $j -lt $bmp.Height) {
                $c = $bmp.GetPixel($i, $j)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 130) {
                    $line += "#"
                } elseif ($lum -gt 80) {
                    $line += "+"
                } else {
                    $line += "."
                }
            }
        }
        Write-Output $line
    }
}

# HDP Line 3 Right (Hoffenheim -0.75 odds)
RenderAscii 720 75 45 18 "Hoffenheim -0.75 odds"

# O/U Over 3.0 odds
RenderAscii 150 105 45 18 "O/U Over 3.0 odds"

# Corners Line & Odds
RenderAscii 390 365 50 20 "Corners Line"
RenderAscii 535 365 45 20 "Corners Over 10.0"
RenderAscii 720 365 45 20 "Corners Under 10.0"

$bmp.Dispose()
