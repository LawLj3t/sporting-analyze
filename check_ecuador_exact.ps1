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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\e425b642-cb66-4d98-bf90-371b42b81431.png")

function CheckCrop($x, $y, $w, $h, $name) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($x, $y, $w, $h)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 5), ($crop.Height * 5))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\ecuador_exact_$name.png"
    $scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    Write-Output ("{0}: {1}" -f $name, $ocr.Text)
}

CheckCrop 0 25 120 30 "1X2_Home"
CheckCrop 130 25 110 30 "1X2_Draw"
CheckCrop 250 25 120 30 "1X2_Away"

CheckCrop 380 40 180 30 "HDP_Row2_Home"
CheckCrop 560 40 190 30 "HDP_Row2_Away"

CheckCrop 0 75 190 30 "OU_Row1_Tai"
CheckCrop 190 75 190 30 "OU_Row1_Xiu"
CheckCrop 0 105 190 30 "OU_Row2_Tai"
CheckCrop 190 105 190 30 "OU_Row2_Xiu"

$bmp.Dispose()
