Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\3baaa4fb-9ce1-44d2-990b-8b6685b6a64c.png")

function RenderAsciiBlock($x, $y, $w, $h, $label) {
    Write-Output "`n=== ASCII: $label ==="
    for ($j = $y; $j -lt ($y + $h); $j++) {
        $line = ""
        for ($i = $x; $i -lt ($x + $w); $i++) {
            $c = $bmp.GetPixel($i, $j)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 130) { $line += "#" }
            elseif ($lum -gt 70) { $line += "+" }
            else { $line += "." }
        }
        Write-Output $line
    }
}

# Over 1.5 odds
RenderAsciiBlock 150 82 35 12 "Over 1.5 odds"
# Under 1.5 odds
RenderAsciiBlock 336 82 35 12 "Under 1.5 odds"
# Over 2.0 odds
RenderAsciiBlock 150 133 35 12 "Over 2.0 odds"
# Under 2.0 odds
RenderAsciiBlock 336 133 35 12 "Under 2.0 odds"

# Corners lines & odds
RenderAsciiBlock 385 340 180 15 "Corners Title Text"
RenderAsciiBlock 20 360 40 15 "Corners Over line"
RenderAsciiBlock 155 360 35 15 "Corners Over odds"
RenderAsciiBlock 340 360 35 15 "Corners Under odds"

$bmp.Dispose()
