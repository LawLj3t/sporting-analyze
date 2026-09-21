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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\0677a1fe-f693-4b98-9352-008ec46e2912.png")

function OcrSubRect($rx, $ry, $rw, $rh, $name) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\rom_$name.png"
    $scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    Write-Output ("=== {0} === : {1}" -f $name, $ocr.Text)
}

# 1. Left 1X2 (y: 20..55)
OcrSubRect 0 20 370 35 "Left_1X2"

# 2. Left O/U rows (y: 75..160)
OcrSubRect 0 75 370 85 "Left_OU_Rows"

# 3. Left BTTS (y: 190..240)
OcrSubRect 0 190 370 50 "Left_BTTS"

# 4. Right HDP rows (y: 20..115)
OcrSubRect 375 20 380 95 "Right_HDP_Rows"

# 5. Right Total Goals rows (y: 120..295)
OcrSubRect 375 120 380 175 "Right_Goals_Rows"

# 6. Right Bottom (y: 295..351)
OcrSubRect 375 295 380 55 "Right_Bottom_Rows"

$bmp.Dispose()
