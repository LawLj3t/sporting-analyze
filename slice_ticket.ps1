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

$img = "C:\Users\HLC2023\.factory\temp\images\da42d8e3\ebcd726c-d908-42d2-ba24-9bb703b4305a.png"
$bmp = [System.Drawing.Bitmap]::FromFile($img)

New-Item -ItemType Directory -Force -Path "C:\sporting analyze\ticket-crops" | Out-Null

# Height is 444. Bottom has "7 Gập" around y=415-444.
# So top 0 to 415 has the items. 415 / 7 = 59.2 pixels per item!
for ($i = 0; $i -lt 7; $i++) {
    $y = [int]($i * 59.3)
    $h = [int][Math]::Min(59, $bmp.Height - $y)
    $rect = New-Object System.Drawing.Rectangle(0, $y, $bmp.Width, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    $cropPath = "C:\sporting analyze\ticket-crops\leg_$i.png"
    $crop.Save($cropPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $crop.Dispose()

    # Run OCR on this crop
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($cropPath)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    Write-Output "--- LEG $i (y=$y..$($y+$h)) ---"
    Write-Output $ocr.Text
}

$bmp.Dispose()
