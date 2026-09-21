Add-Type -AssemblyName System.Drawing

$currPath = "C:\Users\HLC2023\.factory\temp\images\da42d8e3\ebcd726c-d908-42d2-ba24-9bb703b4305a.png"
$currImg = [System.Drawing.Bitmap]::FromFile($currPath)

Write-Output "Image width: $($currImg.Width), height: $($currImg.Height)"

# Let's crop each of the 7 items from currImg and see if they differ from betslip-crops\item_*.png
for ($i = 0; $i -lt 7; $i++) {
    $cropFile = "C:\sporting analyze\betslip-crops\item_$i.png"
    if (Test-Path $cropFile) {
        $prevItem = [System.Drawing.Bitmap]::FromFile($cropFile)
        Write-Output "Item $i in betslip-crops: $($prevItem.Width)x$($prevItem.Height)"
        $prevItem.Dispose()
    }
}

$currImg.Dispose()
