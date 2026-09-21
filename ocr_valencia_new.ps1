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

$img = "C:\Users\HLC2023\.factory\temp\images\be5ee2f9\d94feffd-9b21-4c5a-b155-de696272f441.png"
$bmp = [System.Drawing.Bitmap]::FromFile($img)
Write-Output "Image size: $($bmp.Width) x $($bmp.Height)"

$scaled = New-Object System.Drawing.Bitmap(($bmp.Width * 2), ($bmp.Height * 2))
$g = [System.Drawing.Graphics]::FromImage($scaled)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($bmp, 0, 0, $scaled.Width, $scaled.Height)
$g.Dispose()
$bmp.Dispose()

$tmp = "C:\sporting analyze\betslip-crops\tmp_valencia_2x.png"
$scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
$scaled.Dispose()

$file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
$stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
$decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
$sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
$engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
$ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])

Write-Output "=== FULL OCR TEXT ==="
Write-Output $ocr.Text

Write-Output "`n=== BOUNDS ==="
foreach ($line in $ocr.Lines) {
    $firstWord = $line.Words | Select-Object -First 1
    $y = [int]([double]$firstWord.BoundingRect.Y / 2)
    $x = [int]([double]$firstWord.BoundingRect.X / 2)
    Write-Output ("[{0,3}, {1,3}] {2}" -f $y, $x, $line.Text)
}
