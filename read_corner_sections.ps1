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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\1b244b93-a154-4c10-976c-91c13b73ac3c.png")

function OcrSubRect($rx, $ry, $rw, $rh, $name) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\corner_$name.png"
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

# 1. Top Left: Main Corner Over/Under
OcrSubRect 0 0 375 55 "Top_Left_Corner_OU"

# 2. Top Right: Corner Handicap or 1X2
OcrSubRect 380 0 395 55 "Top_Right_Corner"

# 3. Mid Right: Corner Handicap lines
OcrSubRect 380 60 395 55 "Mid_Right_Corner_HDP"

# 4. Mid Right: Corner 1X2 lines
OcrSubRect 380 115 395 55 "Mid_Right_Corner_1X2"

# 5. Lower Right: Corner bands / other
OcrSubRect 380 165 395 105 "Lower_Right_Corner"

$bmp.Dispose()
