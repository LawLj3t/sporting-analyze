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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\da42d8e3\2250296a-6e80-40a6-9f66-6b06b8ed2058.png")

for ($i = 0; $i -lt 13; $i++) {
    $yStart = [int]($i * 55.5)
    $h = 56
    
    # Left: team & bet name (x: 0 to 185)
    # Right: odds (x: 185 to 236)
    $rectLeft = New-Object System.Drawing.Rectangle(0, $yStart, 185, $h)
    $cropLeft = $bmp.Clone($rectLeft, $bmp.PixelFormat)
    $scaledLeft = New-Object System.Drawing.Bitmap(($cropLeft.Width * 4), ($cropLeft.Height * 4))
    $gL = [System.Drawing.Graphics]::FromImage($scaledLeft)
    $gL.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gL.DrawImage($cropLeft, 0, 0, $scaledLeft.Width, $scaledLeft.Height)
    $gL.Dispose()
    $cropLeft.Dispose()
    $tmpL = "C:\sporting analyze\betslip-crops\tmp_L_$($i+1).png"
    $scaledLeft.Save($tmpL, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaledLeft.Dispose()
    
    $fileL = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmpL)) ([Windows.Storage.StorageFile])
    $streamL = AwaitWinRT ($fileL.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoderL = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($streamL)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmapL = AwaitWinRT ($decoderL.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocrL = AwaitWinRT ($engine.RecognizeAsync($sbitmapL)) ([Windows.Media.Ocr.OcrResult])
    $txtL = ($ocrL.Lines | ForEach-Object { $_.Text }) -join " "

    # Odds on right
    $rectRight = New-Object System.Drawing.Rectangle(180, $yStart, ($bmp.Width - 180), $h)
    $cropRight = $bmp.Clone($rectRight, $bmp.PixelFormat)
    $scaledRight = New-Object System.Drawing.Bitmap(($cropRight.Width * 4), ($cropRight.Height * 4))
    $gR = [System.Drawing.Graphics]::FromImage($scaledRight)
    $gR.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gR.DrawImage($cropRight, 0, 0, $scaledRight.Width, $scaledRight.Height)
    $gR.Dispose()
    $cropRight.Dispose()
    $tmpR = "C:\sporting analyze\betslip-crops\tmp_R_$($i+1).png"
    $scaledRight.Save($tmpR, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaledRight.Dispose()
    
    $fileR = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmpR)) ([Windows.Storage.StorageFile])
    $streamR = AwaitWinRT ($fileR.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoderR = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($streamR)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmapR = AwaitWinRT ($decoderR.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $ocrR = AwaitWinRT ($engine.RecognizeAsync($sbitmapR)) ([Windows.Media.Ocr.OcrResult])
    $txtR = ($ocrR.Lines | ForEach-Object { $_.Text }) -join " "

    Write-Output ("LEG {0,2}: [{1,-8}] | {2}" -f ($i+1), $txtR, $txtL)
}

$bmp.Dispose()
