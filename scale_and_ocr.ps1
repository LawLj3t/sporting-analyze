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

New-Item -ItemType Directory -Force -Path "C:\sporting analyze\ticket-crops-scaled" | Out-Null

for ($i = 0; $i -lt 7; $i++) {
    $y = [int]($i * 59.3)
    $h = [int][Math]::Min(59, $bmp.Height - $y)
    $rect = New-Object System.Drawing.Rectangle(0, $y, $bmp.Width, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)

    # Scale 4x
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()

    $scaledPath = "C:\sporting analyze\ticket-crops-scaled\leg_${i}_4x.png"
    $scaled.Save($scaledPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()

    # OCR on 4x image
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($scaledPath)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])

    Write-Output "=== LEG $i ==="
    foreach ($line in $ocr.Lines) {
        Write-Output $line.Text
    }
}

$bmp.Dispose()
