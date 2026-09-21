Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\920aea6b-2e0a-437e-98fe-054c172b9b4c.png")

# Let's inspect a few sample points to see background and text colors
$colors = @{}
for ($y = 0; $y -lt $bmp.Height; $y += 10) {
    for ($x = 0; $x -lt $bmp.Width; $x += 10) {
        $c = $bmp.GetPixel($x, $y)
        $k = ("R{0}G{1}B{2}" -f [Math]::Round($c.R/20)*20, [Math]::Round($c.G/20)*20, [Math]::Round($c.B/20)*20)
        $colors[$k]++
    }
}

$colors.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 10 | ForEach-Object {
    Write-Output ("Color {0}: {1}" -f $_.Key, $_.Value)
}

$bmp.Dispose()
