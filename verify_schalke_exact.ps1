Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\86c9ae72-d2f1-4e01-9717-adf835bbbf8d.png")

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

# 1X2
RenderAscii 100 20 40 18 "1X2 Schalke"
RenderAscii 220 20 40 18 "1X2 Hoa"
RenderAscii 345 20 40 18 "1X2 Elversberg"

# HDP Line 4 Left (Schalke -0.25)
RenderAscii 530 95 50 18 "HDP Line 4 Left (Schalke -0.25 odds)"
RenderAscii 725 95 45 18 "HDP Line 4 Right (Elversberg +0.25 odds)"

# HDP Line 3 (Schalke -0.5)
RenderAscii 530 70 50 18 "HDP Line 3 Left (Schalke -0.5 odds)"
RenderAscii 725 70 45 18 "HDP Line 3 Right (Elversberg +0.5 odds)"

# HDP Line 5 (Schalke 0)
RenderAscii 530 120 50 18 "HDP Line 5 Left (Schalke 0 odds)"
RenderAscii 725 120 45 18 "HDP Line 5 Right (Elversberg 0 odds)"

# O/U Goals lines
RenderAscii 155 75 45 18 "O/U Over 2.5"
RenderAscii 155 100 45 18 "O/U Over 2.75"
RenderAscii 155 125 45 18 "O/U Over 3.0"
RenderAscii 155 150 45 18 "O/U Over 3.25"
RenderAscii 155 175 45 18 "O/U Over 3.5"

RenderAscii 340 75 45 18 "O/U Under 2.5"
RenderAscii 340 100 45 18 "O/U Under 2.75"
RenderAscii 340 125 45 18 "O/U Under 3.0"
RenderAscii 340 150 45 18 "O/U Under 3.25"
RenderAscii 340 175 45 18 "O/U Under 3.5"

# BTTS
RenderAscii 155 260 45 18 "BTTS Yes"
RenderAscii 340 260 45 18 "BTTS No"

# Corners
RenderAscii 535 360 50 20 "Corners Over 9.5"
RenderAscii 725 360 45 20 "Corners Under 9.5"

$bmp.Dispose()
