Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\b3a53b86-51a9-4df3-af21-edb005c7e277.png")

New-Item -ItemType Directory -Force -Path "C:\sporting analyze\mancity-crops" | Out-Null

# Let's save left half (x:0..380) and right half (x:380..759)
$left = $img.Clone((New-Object System.Drawing.Rectangle(0, 0, 380, $img.Height)), $img.PixelFormat)
$left.Save("C:\sporting analyze\mancity-crops\left_panel.png", [System.Drawing.Imaging.ImageFormat]::Png)
$left.Dispose()

$right = $img.Clone((New-Object System.Drawing.Rectangle(380, 0, ($img.Width - 380), $img.Height)), $img.PixelFormat)
$right.Save("C:\sporting analyze\mancity-crops\right_panel.png", [System.Drawing.Imaging.ImageFormat]::Png)
$right.Dispose()

$img.Dispose()
Write-Output "Panels saved."
