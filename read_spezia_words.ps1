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

$imgFile = "C:\Users\HLC2023\.factory\temp\images\ae08ec05\e604320a-379a-4cc1-adb7-f8f805be6692.png"
$file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($imgFile)) ([Windows.Storage.StorageFile])
$stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
$decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
$sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
$engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
$ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])

$words = @()
foreach ($line in $ocr.Lines) {
    foreach ($w in $line.Words) {
        $words += [PSCustomObject]@{
            Text = $w.Text
            X = [int]$w.BoundingRect.X
            Y = [int]$w.BoundingRect.Y
            W = [int]$w.BoundingRect.Width
            H = [int]$w.BoundingRect.Height
        }
    }
}

$words | Sort-Object { $_.Y } | ForEach-Object {
    Write-Output ("Y:{0,3} X:{1,3} W:{2,2} H:{3,2} | {4}" -f $_.Y, $_.X, $_.W, $_.H, $_.Text)
}
