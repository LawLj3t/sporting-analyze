Add-Type -AssemblyName System.Runtime.WindowsRuntime
Add-Type -AssemblyName System.Drawing

$asTaskGeneric = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { 
    $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' 
} | Select-Object -First 1

function AwaitWinRT($asyncOp, $type) {
    $m = $asTaskGeneric.MakeGenericMethod($type)
    $task = $m.Invoke($null, @($asyncOp))
    return $task.Result
}

[Windows.Media.Ocr.OcrEngine, Windows.Foundation, ContentType = WindowsRuntime] | Out-Null
[Windows.Graphics.Imaging.BitmapDecoder, Windows.Foundation, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Foundation, ContentType = WindowsRuntime] | Out-Null

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\28d1c3ac-2e0f-494a-badd-fb0655e1a4d3.png")

function GetOcrText($rx, $ry, $rw, $rh) {
    $rect = New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmpPath = "C:\sporting analyze\leeds-crops\cell_tmp.png"
    $scaled.Save($tmpPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmpPath)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    return ($ocr.Text -replace "`r`n", " ")
}

Write-Output "=== HDP ROW 2 (Leeds -0.5/1.0 vs CP +0.5/1.0) ==="
$hdp2LeftOdds = GetOcrText 530 80 45 25
$hdp2RightOdds = GetOcrText 710 80 45 25
Write-Output "Leeds -0.5/1.0 Odds: $hdp2LeftOdds  |  CP +0.5/1.0 Odds: $hdp2RightOdds"

Write-Output "`n=== ALL 5 HDP ROWS ==="
for ($r = 0; $r -lt 5; $r++) {
    $y = 28 + $r * 25.5
    $leftText = GetOcrText 380 ([int]$y) 150 24
    $leftOdds = GetOcrText 530 ([int]$y) 45 24
    $rightText = GetOcrText 575 ([int]$y) 135 24
    $rightOdds = GetOcrText 710 ([int]$y) 45 24
    Write-Output "Row $r - [$leftText] $leftOdds  |  [$rightText] $rightOdds"
}

Write-Output "`n=== CORNERS ==="
$cornerOver = GetOcrText 530 380 45 25
$cornerUnder = GetOcrText 710 380 45 25
Write-Output "Corners Over Odds: $cornerOver  |  Corners Under Odds: $cornerUnder"

$bmp.Dispose()
