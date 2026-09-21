param (
    [string]$ImagePath = "C:\Users\HLC2023\.factory\temp\images\b08c7cb2\62397e67-cbae-4ac0-8a49-23f522f67185.jpeg"
)

Add-Type -AssemblyName System.Drawing

[Windows.Media.Ocr.OcrEngine, Windows.Foundation, ContentType = WindowsRuntime] | Out-Null
[Windows.Graphics.Imaging.BitmapDecoder, Windows.Foundation, ContentType = WindowsRuntime] | Out-Null
[Windows.Storage.StorageFile, Windows.Foundation, ContentType = WindowsRuntime] | Out-Null

function Await($task) {
    while (-not $task.IsCompleted) {
        Start-Sleep -Milliseconds 50
    }
    return $task.GetResults()
}

$fileTask = [Windows.Storage.StorageFile]::GetFileFromPathAsync($ImagePath)
$file = Await $fileTask

$streamTask = $file.OpenAsync([Windows.Storage.FileAccessMode]::Read)
$stream = Await $streamTask

$decoderTask = [Windows.Graphics.Imaging.BitmapDecoder]::CreateAsync($stream)
$decoder = Await $decoderTask

$bitmapTask = $decoder.GetSoftwareBitmapAsync()
$bitmap = Await $bitmapTask

$engine = [Windows.Media.Ocr.OcrEngine]::TryCreateFromUserProfileLanguages()
$ocrTask = $engine.RecognizeAsync($bitmap)
$ocrResult = Await $ocrTask

Write-Output "=== FULL TEXT ==="
Write-Output $ocrResult.Text

Write-Output "`n=== LINES WITH BOUNDS ==="
foreach ($line in $ocrResult.Lines) {
    $words = ($line.Words | ForEach-Object { "$($_.Text) [x:$($_.BoundingRect.X),y:$($_.BoundingRect.Y),w:$($_.BoundingRect.Width),h:$($_.BoundingRect.Height)]" }) -join " "
    Write-Output "$($line.Text) --- $words"
}
