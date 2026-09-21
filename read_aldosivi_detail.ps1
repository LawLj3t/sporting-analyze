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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\a600665e-208e-497f-b94e-79dd6dadf85c.png")

function OcrSubRect($rx, $ry, $rw, $rh, $name) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\aldo_$name.png"
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

# Left 1X2
OcrSubRect 0 25 370 30 "Left_1X2"

# Right HDP Row 0
OcrSubRect 375 25 390 30 "Right_HDP_0"

# Right HDP Row 1
OcrSubRect 375 50 390 28 "Right_HDP_1"

# Right HDP Row 2
OcrSubRect 375 75 390 28 "Right_HDP_2"

# Right HDP Row 3
OcrSubRect 375 100 390 28 "Right_HDP_3"

# Left BTTS (y: 130..160)
OcrSubRect 0 130 370 30 "Left_BTTS"

# Right Total Goals header & rows (y: 110..260)
OcrSubRect 375 110 390 30 "Right_Goals_Header"
OcrSubRect 375 135 390 30 "Right_Goals_Row0"
OcrSubRect 375 160 390 30 "Right_Goals_Row1"
OcrSubRect 375 185 390 30 "Right_Goals_Row2"
OcrSubRect 375 210 390 30 "Right_Goals_Row3"
OcrSubRect 375 235 390 30 "Right_Goals_Row4"

$bmp.Dispose()
