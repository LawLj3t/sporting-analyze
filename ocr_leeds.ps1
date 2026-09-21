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
    
    $tmpPath = "C:\sporting analyze\leeds-crops\tmp_$title.png"
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

New-Item -ItemType Directory -Force -Path "C:\sporting analyze\leeds-crops" | Out-Null
$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\28d1c3ac-2e0f-494a-badd-fb0655e1a4d3.png")

# Left Top: 1X2 (y:0..55, x:0..375)
OcrCrop $bmp 0 0 375 55 "1X2"

# Left Mid: FT Total Goals O/U (y:55..215, x:0..375)
OcrCrop $bmp 0 55 375 160 "FT_TOTAL_GOALS"

# Left Lower: HT Total Goals O/U (y:215..355, x:0..375)
OcrCrop $bmp 0 215 375 140 "HT_TOTAL_GOALS"

# Left Bottom: BTTS (y:355..410, x:0..375)
OcrCrop $bmp 0 355 375 55 "BTTS"

# Right Top: FT Asian Handicap (y:0..160, x:375..375)
OcrCrop $bmp 375 0 375 160 "FT_ASIAN_HDP"

# Right Mid: Alternative O/U (y:160..370, x:375..375)
OcrCrop $bmp 375 160 375 210 "ALT_TOTAL_GOALS"

# Right Bottom: Corners O/U (y:370..410, x:375..375)
OcrCrop $bmp 375 370 375 40 "CORNERS"

$bmp.Dispose()
