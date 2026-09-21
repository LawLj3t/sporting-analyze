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

function RunOcr($path, $label) {
    Write-Output "`n========================================================"
    Write-Output "[$label]: $path"
    Write-Output "========================================================"
    $bmp = [System.Drawing.Bitmap]::FromFile($path)
    Write-Output "Size: $($bmp.Width) x $($bmp.Height)"
    
    $scaled = New-Object System.Drawing.Bitmap(($bmp.Width * 2), ($bmp.Height * 2))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($bmp, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $bmp.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\tmp_confirm.png"
    $scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()

    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])

    foreach ($line in $ocr.Lines) {
        Write-Output $line.Text
    }
}

RunOcr "C:\Users\HLC2023\.factory\temp\images\da42d8e3\53f0d306-1bdb-40ac-b5e8-5edc9893dd97.png" "Image 1"
RunOcr "C:\Users\HLC2023\.factory\temp\images\da42d8e3\12e017a7-78da-4cc7-bd1c-9383ab5f44c4.png" "Image 2"
