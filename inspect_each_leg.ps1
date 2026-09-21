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

# Each item is roughly 50 to 58 pixels tall.
# Let's inspect each slice:
# Leg 1: y: 0 to 55
# Leg 2: y: 55 to 110
# Leg 3: y: 110 to 165
# Leg 4: y: 165 to 220
# Leg 5: y: 220 to 275
# Leg 6: y: 275 to 330
# Leg 7: y: 330 to 385
# Leg 8: y: 385 to 440
# Leg 9: y: 440 to 495
# Leg 10: y: 495 to 550
# Leg 11: y: 550 to 605
# Leg 12: y: 605 to 660
# Leg 13: y: 660 to 720
# Bottom bar: y: 720 to 752 (13 Gập, 179.04)

for ($i = 0; $i -lt 13; $i++) {
    $yStart = [int]($i * 55.5)
    $h = 58
    if ($yStart + $h -gt $bmp.Height) { $h = $bmp.Height - $yStart }
    
    $rect = New-Object System.Drawing.Rectangle(0, $yStart, $bmp.Width, $h)
    $crop = $bmp.Clone($rect, $bmp.PixelFormat)
    
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 4), ($crop.Height * 4))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\tmp_leg_$($i+1).png"
    $scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    $txt = ($ocr.Lines | ForEach-Object { $_.Text }) -join " | "
    Write-Output ("LEG {0,2} (y:{1,3}..{2,3}): {3}" -f ($i+1), $yStart, ($yStart+$h), $txt)
}

$bmp.Dispose()
