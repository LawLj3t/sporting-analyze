Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\3baaa4fb-9ce1-44d2-990b-8b6685b6a64c.png")

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

# In original image, O/U Goals table is at y: 65 to 225
# Lines are at approx y = 85, 111, 136, 162, 188
RenderAscii 145 80 45 15 "O/U Over 1.5"
RenderAscii 145 105 45 15 "O/U Over 1.75"
RenderAscii 145 130 45 15 "O/U Over 2.0"
RenderAscii 145 155 45 15 "O/U Over 2.25"
RenderAscii 145 180 45 15 "O/U Over 2.5"

RenderAscii 335 80 40 15 "O/U Under 1.5"
RenderAscii 335 105 40 15 "O/U Under 1.75"
RenderAscii 335 130 40 15 "O/U Under 2.0"
RenderAscii 335 155 40 15 "O/U Under 2.25"
RenderAscii 335 180 40 15 "O/U Under 2.5"

# BTTS table: let's check y from 220 to 280
RenderAscii 145 260 45 20 "BTTS Yes Odds (x:145, y:260)"
RenderAscii 330 260 45 20 "BTTS No Odds (x:330, y:260)"

# Also let's check line labels for BTTS
RenderAscii 10 230 180 20 "BTTS Title"
RenderAscii 10 260 80 20 "BTTS Option 1 (Có?)"
RenderAscii 190 260 80 20 "BTTS Option 2 (Không?)"

$bmp.Dispose()
