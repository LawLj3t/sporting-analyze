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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\6ed653f7-900c-438d-b23c-25fb74167ddf.png")

function GetOcrText($rx, $ry, $rw, $rh) {
    $rect = New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 3), ($crop.Height * 3))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmpPath = "C:\sporting analyze\liverpool-crops\cell_tmp.png"
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

Write-Output "=== ASIAN HANDICAP ROWS ==="
for ($r = 0; $r -lt 5; $r++) {
    $y = 28 + $r * 25.5
    $leftText = GetOcrText 382 ([int]$y) 155 24
    $leftOdds = GetOcrText 538 ([int]$y) 38 24
    $rightText = GetOcrText 578 ([int]$y) 138 24
    $rightOdds = GetOcrText 718 ([int]$y) 38 24
    Write-Output "Row $r - [$leftText] Odds: $leftOdds  |  [$rightText] Odds: $rightOdds"
}

Write-Output "`n=== TOTAL GOALS O/U ROWS ==="
for ($r = 0; $r -lt 5; $r++) {
    $y = 85 + $r * 25.5
    $overText = GetOcrText 10 ([int]$y) 140 24
    $overOdds = GetOcrText 152 ([int]$y) 40 24
    $underText = GetOcrText 194 ([int]$y) 140 24
    $underOdds = GetOcrText 336 ([int]$y) 40 24
    Write-Output "Row $r - [$overText] Odds: $overOdds  |  [$underText] Odds: $underOdds"
}

$bmp.Dispose()
