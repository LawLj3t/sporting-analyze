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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\b11d26e7-5366-4cea-b6d6-f2ef43185ab8.png")

# Let's save the row crops with high resolution and inspect each cell individually
function GetCellText($rx, $ry, $rw, $rh, $id) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $p = "C:\sporting analyze\betslip-crops\cell_$id.png"
    $scaled.Save($p, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($p)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    return $ocr.Text
}

Write-Output "--- OU SECTION ---"
Write-Output ("Row 1 Left (Tài mốc 1): " + (GetCellText 0 75 190 28 "ou_r1_c1"))
Write-Output ("Row 1 Right (Xỉu mốc 1): " + (GetCellText 190 75 185 28 "ou_r1_c2"))
Write-Output ("Row 2 Left (Tài mốc 2): " + (GetCellText 0 103 190 28 "ou_r2_c1"))
Write-Output ("Row 2 Right (Xỉu mốc 2): " + (GetCellText 190 103 185 28 "ou_r2_c2"))

Write-Output "--- HDP SECTION ---"
Write-Output ("HDP Row 1 Left (Bournemouth mốc 1): " + (GetCellText 380 15 185 28 "hdp_r1_c1"))
Write-Output ("HDP Row 1 Right (Stoke City mốc 1): " + (GetCellText 565 15 190 28 "hdp_r1_c2"))
Write-Output ("HDP Row 2 Left (Bournemouth mốc 2): " + (GetCellText 380 43 185 28 "hdp_r2_c1"))
Write-Output ("HDP Row 2 Right (Stoke City mốc 2): " + (GetCellText 565 43 190 28 "hdp_r2_c2"))

$bmp.Dispose()
