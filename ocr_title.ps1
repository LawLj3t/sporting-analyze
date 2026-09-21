Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Runtime.WindowsRuntime

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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\b3a53b86-51a9-4df3-af21-edb005c7e277.png")
$rect = New-Object System.Drawing.Rectangle(25, 218, 300, 16)
$crop = $bmp.Clone($rect, $bmp.PixelFormat)

$scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
$g = [System.Drawing.Graphics]::FromImage($scaled)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
$g.Dispose()

$tmp = "C:\sporting analyze\mancity-crops\title_test.png"
$scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
$scaled.Dispose()
$crop.Dispose()

# Also BTTS title
$rect2 = New-Object System.Drawing.Rectangle(25, 352, 300, 16)
$crop2 = $bmp.Clone($rect2, $bmp.PixelFormat)
$scaled2 = New-Object System.Drawing.Bitmap(($crop2.Width * 4), ($crop2.Height * 4))
$g2 = [System.Drawing.Graphics]::FromImage($scaled2)
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g2.DrawImage($crop2, 0, 0, $scaled2.Width, $scaled2.Height)
$g2.Dispose()

$tmp2 = "C:\sporting analyze\mancity-crops\title_btts.png"
$scaled2.Save($tmp2, [System.Drawing.Imaging.ImageFormat]::Png)
$scaled2.Dispose()
$crop2.Dispose()

$bmp.Dispose()

function DoOcr($path, $label) {
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($path)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    Write-Output "[$label]: $($ocr.Text)"
}

DoOcr $tmp "Lower Left Title"
DoOcr $tmp2 "BTTS Title"
