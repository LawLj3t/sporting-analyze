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
                # In this UI, text is white/bright on dark background
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

# 1X2 odds
RenderAscii 90 25 35 15 "1X2 Parma"
RenderAscii 210 25 35 15 "1X2 Hoa"
RenderAscii 335 25 35 15 "1X2 Genoa"

# Asian Handicap lines & odds
RenderAscii 525 25 45 15 "HDP Line 1 Left (Parma -0.5 odds)"
RenderAscii 715 25 40 15 "HDP Line 1 Right (Genoa +0.5 odds)"

RenderAscii 525 50 45 15 "HDP Line 2 Left (Parma -0.25 odds)"
RenderAscii 715 50 40 15 "HDP Line 2 Right (Genoa +0.25 odds)"

RenderAscii 525 75 45 15 "HDP Line 3 Left (Parma 0 odds)"
RenderAscii 715 75 40 15 "HDP Line 3 Right (Genoa 0 odds)"

RenderAscii 525 100 45 15 "HDP Line 4 Left (Parma +0.25 odds)"
RenderAscii 715 100 40 15 "HDP Line 4 Right (Genoa -0.25 odds)"

RenderAscii 525 125 45 15 "HDP Line 5 Left (Parma +0.5 odds)"
RenderAscii 715 125 40 15 "HDP Line 5 Right (Genoa -0.5 odds)"

# O/U Goals odds (crop_ou_goals)
RenderAscii 145 18 45 15 "O/U Over 1.5"
RenderAscii 145 44 45 15 "O/U Over 1.75"
RenderAscii 145 69 45 15 "O/U Over 2.0"
RenderAscii 145 95 45 15 "O/U Over 2.25"
RenderAscii 145 120 45 15 "O/U Over 2.5"

RenderAscii 335 18 40 15 "O/U Under 1.5"
RenderAscii 335 44 40 15 "O/U Under 1.75"
RenderAscii 335 69 40 15 "O/U Under 2.0"
RenderAscii 335 95 40 15 "O/U Under 2.25"
RenderAscii 335 120 40 15 "O/U Under 2.5"

# BTTS
RenderAscii 5 220 200 40 "BTTS Title / Area"
RenderAscii 145 260 45 20 "BTTS Yes Odds"
RenderAscii 330 260 45 20 "BTTS No Odds"

# Corners
RenderAscii 380 320 250 25 "Corners Title"
RenderAscii 530 345 45 20 "Corners Over 8.5"
RenderAscii 715 345 45 20 "Corners Under 8.5"

$bmp.Dispose()
