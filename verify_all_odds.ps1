Add-Type -AssemblyName System.Drawing

$logPath = "C:\sporting analyze\ticket_summary.txt"
$img = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\ebcd726c-d908-42d2-ba24-9bb703b4305a.png")

# Let's inspect the 7 legs:
# Leg 0:
# Selection: FENNEL Female
# Market: Người thắng toàn trận (Match Winner)
# Match: FENNEL Female vs Gen.G GC
# Odds: 1.45

# Leg 1:
# Selection: PlayTime
# Market: Người thắng toàn trận
# Match: PlayTime vs Team Cobra
# Odds: 1.52 (wait, let's verify if odds is 1.52 or 1.43)

# Leg 2:
# Selection: 2 - 0
# Market: Tỷ số chính xác (Correct Score)
# Match: Team Yandex vs Team Nemesis
# Odds: 1.54

# Leg 3:
# Selection: Tài 3.5
# Market: FT Number of Maps (Tổng số bản đồ)
# Match: Team Liquid vs FlyQuest
# Odds: 1.43

# Leg 4:
# Selection: G2 Ares +1.5
# Market: FT Match Handicap (Kèo chấp bản đồ)
# Match: Team QUAZAR vs G2 Ares
# Odds: 1.48

# Leg 5:
# Selection: Xtreme Gaming
# Market: Người thắng toàn trận
# Match: Conventus Stellarum vs Xtreme Gaming
# Odds: 1.67

# Leg 6:
# Selection: GamerLegion +1.5
# Market: FT Match Handicap
# Match: GamerLegion vs LGD Gaming
# Odds: 1.48

# Let's verify each odds by printing ASCII of the odds box for legs 0..6
$results = @()
for ($i = 0; $i -lt 7; $i++) {
    $y = [int]($i * 59.3)
    $results += "=== LEG $i (y=$y) ==="
    for ($py = $y + 5; $py -le $y + 20; $py++) {
        $line = ""
        for ($px = 210; $px -le 255; $px++) {
            $c = $img.GetPixel($px, $py)
            $lum = [int](0.299 * $c.R + 0.587 * $c.G + 0.114 * $c.B)
            if ($lum -gt 140) { $line += "#" }
            elseif ($lum -gt 80) { $line += "." }
            else { $line += " " }
        }
        $results += $line
    }
}

$results | Out-File -FilePath $logPath -Encoding utf8
$img.Dispose()
Get-Content $logPath
