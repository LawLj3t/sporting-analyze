Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

function RenderAsciiBlock($x, $y, $w, $h, $label) {
    Write-Output "`n=== $label ==="
    for ($j = $y; $j -lt ($y + $h); $j += 1) {
        $line = ""
        for ($i = $x; $i -lt ($x + $w); $i += 1) {
            if ($i -ge 0 -and $i -lt $bmp.Width -and $j -ge 0 -and $j -lt $bmp.Height) {
                $c = $bmp.GetPixel($i, $j)
                $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
                if ($lum -gt 130) { $line += "#" }
                elseif ($lum -gt 80) { $line += "+" }
                else { $line += "." }
            }
        }
        Write-Output $line
    }
}

for ($idx = 1; $idx -le 13; $idx++) {
    $y = 5 + ($idx - 1) * 56
    RenderAsciiBlock 20 $y 170 15 "Leg $idx Selection Name (y=$y)"
    RenderAsciiBlock 20 ($y + 25) 170 15 "Leg $idx Match Name (y=$($y+25))"
    RenderAsciiBlock 200 $y 35 15 "Leg $idx Odds (y=$y)"
}

$bmp.Dispose()
