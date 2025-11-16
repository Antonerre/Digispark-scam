Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$url = 'https://i.pinimg.com/736x/ae/bd/9f/aebd9fd41b68f2304476a54d93e0e9c9.jpg'

$imgW = 300
$imgH = 200
$step = 10
$delayMs = 50
$spawnMs = 100
$waitBeforeStartMs = 5000

$tempFile = Join-Path $env:TEMP ("dvd_spawn_" + [Guid]::NewGuid().ToString() + ".png")
Write-Host "Скачиваем картинку..."
Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing

Start-Sleep -Milliseconds $waitBeforeStartMs
Write-Host "Начинаем..."

$img = [System.Drawing.Bitmap]::FromFile($tempFile)

$screenWidth = [System.Windows.Forms.SystemInformation]::VirtualScreen.Width
$screenHeight = [System.Windows.Forms.SystemInformation]::VirtualScreen.Height

$dvdForm = New-Object System.Windows.Forms.Form
$dvdForm.FormBorderStyle = 'None'
$dvdForm.StartPosition = 'Manual'
$dvdForm.TopMost = $true
$dvdForm.ShowInTaskbar = $false
$dvdForm.Width = $imgW
$dvdForm.Height = $imgH
$dvdForm.BackColor = [System.Drawing.Color]::Black
$dvdForm.Opacity = 0.95

$dvdPic = New-Object System.Windows.Forms.PictureBox
$dvdPic.Dock = 'Fill'
$dvdPic.SizeMode = 'Zoom'
$dvdPic.Image = New-Object System.Drawing.Bitmap($img)
$dvdForm.Controls.Add($dvdPic)

$x = Get-Random -Minimum 0 -Maximum ($screenWidth - $imgW)
$y = Get-Random -Minimum 0 -Maximum ($screenHeight - $imgH)
$dvdForm.Left = $x
$dvdForm.Top  = $y

$dvdForm.Show()

$dx = $step
$dy = $step
$lastSpawn = [DateTime]::Now

while ($true) {
    $x += $dx
    $y += $dy

    if ($x + $imgW -ge $screenWidth -or $x -le 0) { $dx = -$dx; $x += $dx }
    if ($y + $imgH -ge $screenHeight -or $y -le 0) { $dy = -$dy; $y += $dy }

    $dvdForm.Left = $x
    $dvdForm.Top  = $y

    if (([DateTime]::Now - $lastSpawn).TotalMilliseconds -ge $spawnMs) {
        $newForm = New-Object System.Windows.Forms.Form
        $newForm.FormBorderStyle = 'None'
        $newForm.StartPosition = 'Manual'
        $newForm.TopMost = $true
        $newForm.ShowInTaskbar = $false
        $newForm.Width = $imgW
        $newForm.Height = $imgH
        $newForm.BackColor = [System.Drawing.Color]::Black
        $newForm.Opacity = 0.95

        $newPic = New-Object System.Windows.Forms.PictureBox
        $newPic.Dock = 'Fill'
        $newPic.SizeMode = 'Zoom'
        $newPic.Image = New-Object System.Drawing.Bitmap($img)
        $newForm.Controls.Add($newPic)

        $newForm.Left = $x
        $newForm.Top  = $y

        $newForm.Show()
        $lastSpawn = [DateTime]::Now
    }

    Start-Sleep -Milliseconds $delayMs
}