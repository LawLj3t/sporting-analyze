Add-Type -AssemblyName System.Drawing

$img1 = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\fce34188\31eb0110-6447-49b9-821e-7a8e9b11475f.png")
Write-Output "Image 1 Width: $($img1.Width), Height: $($img1.Height)"

# Sample colors at various points
$samples = @(
    @{x=10; y=10},
    @{x=50; y=50},
    @{x=100; y=70},
    @{x=250; y=70},
    @{x=400; y=70}
)
foreach ($s in $samples) {
    $c = $img1.GetPixel($s.x, $s.y)
    Write-Output "Pixel ($($s.x),$($s.y)): R=$($c.R) G=$($c.G) B=$($c.B) Hex=#($c.R.ToString('X2'))$($c.G.ToString('X2'))$($c.B.ToString('X2'))"
}

$img1.Dispose()
