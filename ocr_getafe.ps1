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

function OcrCrop($bmp, $rx, $ry, $rw, $rh, $title) {
    $rect = New-Object System.Drawing.Rectangle($rx, $ry, $rw, $rh)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 3), ($crop.Height * 3))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmpPath = "C:\sporting analyze\getafe-crops\tmp_$title.png"
    $scaled.Save($tmpPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmpPath)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    Write-Output ">>> SECTION: $title <<<"
    foreach ($line in $ocr.Lines) {
        Write-Output $line.Text
    }
}

New-Item -ItemType Directory -Force -Path "C:\sporting analyze\getafe-crops" | Out-Null
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\aa405832-8d81-4861-a8a7-a84cd682ab8f.png")

# Full Left Column
OcrCrop $bmp 0 0 383 180 "LEFT_TOP"
OcrCrop $bmp 0 180 383 196 "LEFT_BOTTOM"

# Full Right Column
OcrCrop $bmp 383 0 383 180 "RIGHT_TOP"
OcrCrop $bmp 383 180 383 196 "RIGHT_BOTTOM"

$bmp.Dispose()
