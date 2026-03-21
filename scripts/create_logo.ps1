Add-Type -AssemblyName System.Drawing

$width = 1024
$height = 1024
$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)

$bgColor = [System.Drawing.Color]::FromArgb(15, 110, 86)
$g.Clear($bgColor)

$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$font = New-Object System.Drawing.Font("Arial", 200, [System.Drawing.FontStyle]::Bold)
$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center
$rect = New-Object System.Drawing.RectangleF(0, 0, $width, $height)
$g.DrawString("A", $font, $brush, $rect, $sf)

$g.Dispose()
$bmp.Save("$PSScriptRoot\..\assets\images\logo.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()

Write-Host "logo.png created successfully at assets/images/logo.png"
