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

$imgs = @(
    "C:\Users\HLC2023\.factory\temp\images\fce34188\31eb0110-6447-49b9-821e-7a8e9b11475f.png",
    "C:\Users\HLC2023\.factory\temp\images\fce34188\9a9d0b98-b79f-43e3-bce4-73c57db2e89a.png"
)

$engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()

for ($i = 0; $i -lt $imgs.Count; $i++) {
    Write-Output "================ IMAGE $($i+1) ================"
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($imgs[$i])) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $bitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    Write-Output "Dimensions: $($bitmap.PixelWidth) x $($bitmap.PixelHeight)"
    $ocr = AwaitWinRT ($engine.RecognizeAsync($bitmap)) ([Windows.Media.Ocr.OcrResult])
    foreach ($line in $ocr.Lines) {
        Write-Output "$($line.Text)"
    }
}
