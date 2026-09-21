Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

# Let's save a crop of the odds column (x: 180 to 236) from top to bottom
$crop = $bmp.Clone((New-Object System.Drawing.Rectangle(180, 0, ($bmp.Width - 180), $bmp.Height)), $bmp.PixelFormat)
$crop.Save("C:\sporting analyze\betslip-crops\odds_column.png", [System.Drawing.Imaging.ImageFormat]::Png)
$crop.Dispose()
$bmp.Dispose()
Write-Output "Odds column saved."
