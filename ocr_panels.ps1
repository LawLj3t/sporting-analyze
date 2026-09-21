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
    # Scale 2x for OCR
    $bmp = [System.Drawing.Bitmap]::FromFile($path)
    $scaled = New-Object System.Drawing.Bitmap(($bmp.Width * 2), ($bmp.Height * 2))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($bmp, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $bmp.Dispose()
    $tmpPath = "$path.scaled.png"
    $scaled.Save($tmpPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()

    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmpPath)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])

    Write-Output "========================================="
    Write-Output "PANEL: $label"
    Write-Output "========================================="
    foreach ($line in $ocr.Lines) {
        $parts = @()
        foreach ($w in $line.Words) {
            $x = [int]($w.BoundingRect.X / 2)
            $y = [int]($w.BoundingRect.Y / 2)
            $parts += "$($w.Text)($x,$y)"
        }
        Write-Output ($parts -join " ")
    }
}

RunOcr "C:\sporting analyze\mancity-crops\left_panel.png" "LEFT (x:0..380)"
RunOcr "C:\sporting analyze\mancity-crops\right_panel.png" "RIGHT (x:380..759)"
