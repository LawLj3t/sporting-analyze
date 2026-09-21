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

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\ae08ec05\b11d26e7-5366-4cea-b6d6-f2ef43185ab8.png")

# Let's crop exact boxes around the 4 numbers in OU:
# Row 1 Tai: (Col 1, Col 2)
# Row 2 Xiu: (Col 1, Col 2)

function CropAndOcr($x, $y, $w, $h, $label) {
    $crop = $bmp.Clone((New-Object System.Drawing.Rectangle($x, $y, $w, $h)), $bmp.PixelFormat)
    $scaled = New-Object System.Drawing.Bitmap(($crop.Width * 5), ($crop.Height * 5))
    $g = [System.Drawing.Graphics]::FromImage($scaled)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($crop, 0, 0, $scaled.Width, $scaled.Height)
    $g.Dispose()
    $crop.Dispose()
    
    $tmp = "C:\sporting analyze\betslip-crops\ou_box_$label.png"
    $scaled.Save($tmp, [System.Drawing.Imaging.ImageFormat]::Png)
    $scaled.Dispose()
    
    $file = AwaitWinRT ([Windows.Storage.StorageFile]::GetFileFromPathAsync($tmp)) ([Windows.Storage.StorageFile])
    $stream = AwaitWinRT ($file.OpenAsync([Windows.Storage.FileAccessMode]::Read)) ([Windows.Storage.Streams.IRandomAccessStream])
    $decoder = AwaitWinRT ([Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)) ([Windows.Graphics.Imaging.BitmapDecoder])
    $sbitmap = AwaitWinRT ($decoder.GetSoftwareBitmapAsync()) ([Windows.Graphics.Imaging.SoftwareBitmap])
    $engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
    $ocr = AwaitWinRT ($engine.RecognizeAsync($sbitmap)) ([Windows.Media.Ocr.OcrResult])
    
    Write-Output ("{0}: {1}" -f $label, $ocr.Text)
}

# Looking at words:
# Y: 84 X: 25 W:31 H: 8 | 3.5/40
# Y: 84 X: 9 W:13 H: 7 | Tbi
# Y: 109 X:158 W:20 H: 8 | 206
# Y: 109 X:195 W:13 H: 8 | xiu
# Let's crop:
CropAndOcr 140 75 70 30 "Tai_Col1_Odds"
CropAndOcr 300 75 70 30 "Tai_Col2_Odds"
CropAndOcr 140 105 70 30 "Xiu_Col1_Odds"
CropAndOcr 300 105 70 30 "Xiu_Col2_Odds"

# Also check HDP:
# Col 1: Bournemouth -1.0/1.5 & Stoke City +1.0/1.5
# Col 2: Bournemouth -1.0 & Stoke City +1.0
CropAndOcr 520 20 60 30 "HDP_Col1_Home"
CropAndOcr 700 20 60 30 "HDP_Col2_Home"
CropAndOcr 520 50 60 30 "HDP_Col1_Away"
CropAndOcr 700 50 60 30 "HDP_Col2_Away"

$bmp.Dispose()
