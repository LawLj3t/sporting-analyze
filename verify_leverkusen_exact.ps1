Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\9cc355fa-ffc3-4b44-828e-3c5000d4f697.png")

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

# Check Corners title, line, odds
RenderAscii 400 370 250 20 "Corners Title"
RenderAscii 390 400 60 20 "Corners Line (9.5?)"
RenderAscii 535 400 50 20 "Corners Over odds (1.64?)"
RenderAscii 720 400 45 20 "Corners Under odds (1.96?)"

# Check BTTS title & labels
RenderAscii 5 285 200 20 "BTTS Title"
RenderAscii 5 300 80 20 "BTTS Yes label"
RenderAscii 145 300 45 20 "BTTS Yes odds"
RenderAscii 195 300 80 20 "BTTS No label"
RenderAscii 335 300 45 20 "BTTS No odds"

$bmp.Dispose()
