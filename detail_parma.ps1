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

function InspectCrop($path, $scaleFactor = 3) {
    $bmp = [System.Drawing.Bitmap]::FromFile($path)
    $scaled = New-Object System.Drawing.Bitmap(($bmp.Width * $scaleFactor), ($bmp.Height * $scaleFactor))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($bmp, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $bmp.Dispose()
    
    $tmp = "C:\sporting analyze\parma-crops\tmp_inspect.png"
    $scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    Write-Output "=== FILE: $path ==="
    foreach ($line in $ocr.Lines) {
        $wStr = ($line.Words | ForEach-Object { "$($_.Text) [x:$([int]($_.BoundingRect.X / $scaleFactor)), y:$([int]($_.BoundingRect.Y / $scaleFactor))]" }) -join " "
        Write-Output "Line: $($line.Text)"
        Write-Output "  Words: $wStr"
    }
}

InspectCrop "C:\sporting analyze\parma-crops\crop_1x2.png"
InspectCrop "C:\sporting analyze\parma-crops\crop_ou_goals.png"
InspectCrop "C:\sporting analyze\parma-crops\crop_btts.png"
InspectCrop "C:\sporting analyze\parma-crops\crop_asian_hdp.png"
InspectCrop "C:\sporting analyze\parma-crops\crop_right_bottom.png"
