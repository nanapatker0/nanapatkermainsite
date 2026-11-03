$root = $PSScriptRoot
$art = Join-Path $root 'art'
$illus = Join-Path $art 'illus'
$moments = Join-Path $art 'moments'
$music = Join-Path $root 'music'

New-Item -ItemType Directory -Force -Path $illus | Out-Null
New-Item -ItemType Directory -Force -Path $moments | Out-Null
New-Item -ItemType Directory -Force -Path $music | Out-Null

Add-Type -AssemblyName System.Drawing

function New-PlaceholderImage([string]$path, [string]$bgHex, [string]$accentHex, [string]$label, [int]$width = 1200, [int]$height = 1800, [string]$format = 'Jpeg') {
    $bg = [System.Drawing.ColorTranslator]::FromHtml($bgHex)
    $accent = [System.Drawing.ColorTranslator]::FromHtml($accentHex)
    $img = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($img)
    $g.Clear($bg)

    $light = [System.Drawing.Color]::FromArgb(60, $accent.R, $accent.G, $accent.B)
    $line = [System.Drawing.Color]::FromArgb(180, $accent.R, $accent.G, $accent.B)
    $brush = New-Object System.Drawing.SolidBrush($accent)
    $lightBrush = New-Object System.Drawing.SolidBrush($light)
    $linePen = New-Object System.Drawing.Pen($line, 8)

    $g.FillRectangle($lightBrush, 120, 200, $width - 240, $height - 400)
    $g.DrawRectangle($linePen, 80, 120, $width - 160, $height - 240)
    $g.DrawLine($linePen, 220, 250, $width - 220, 250)
    $g.DrawLine($linePen, 220, $height - 250, $width - 220, $height - 250)

    $g.FillEllipse($brush, 150, 230, 60, 60)
    $g.FillEllipse($brush, $width - 210, 230, 60, 60)
    $g.FillEllipse($brush, 150, $height - 290, 60, 60)
    $g.FillEllipse($brush, $width - 210, $height - 290, 60, 60)

    $font = New-Object System.Drawing.Font('Georgia', 72, [System.Drawing.FontStyle]::Bold)
    $small = New-Object System.Drawing.Font('Segoe UI', 28, [System.Drawing.FontStyle]::Bold)
    $labelBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 74, 20, 38))
    $g.DrawString($label, $font, $labelBrush, 120, 520)
    $g.DrawString('Wedding Invitation', $small, $labelBrush, 120, 660)

    $g.Dispose()

    $fmt = switch ($format) {
        'Png' { [System.Drawing.Imaging.ImageFormat]::Png }
        'Jpeg' { [System.Drawing.Imaging.ImageFormat]::Jpeg }
        default { [System.Drawing.Imaging.ImageFormat]::Jpeg }
    }

    $img.Save($path, $fmt)
    $img.Dispose()
}

$artList = @(
    @{ Path = (Join-Path $illus 'mahal-doors.jpg'); bg = '#f7ecd9'; accent = '#a8462c'; label = 'MAHAL' },
    @{ Path = (Join-Path $illus 'mahal-hero.jpg'); bg = '#f7ecd9'; accent = '#a8462c'; label = 'VIHAAN' },
    @{ Path = (Join-Path $illus 'mahal-card.jpg'); bg = '#f7ecd9'; accent = '#a8462c'; label = 'KAVYA' },
    @{ Path = (Join-Path $illus 'khat-envelope.jpg'); bg = '#fbf3ea'; accent = '#b2566c'; label = 'KHAT' },
    @{ Path = (Join-Path $illus 'khat-hero.jpg'); bg = '#fbf3ea'; accent = '#b2566c'; label = 'LOVE' },
    @{ Path = (Join-Path $illus 'khat-card.jpg'); bg = '#fbf3ea'; accent = '#b2566c'; label = 'FOREVER' },
    @{ Path = (Join-Path $illus 'gopuram-doors.jpg'); bg = '#fbf5e8'; accent = '#a6175a'; label = 'GOPURAM' },
    @{ Path = (Join-Path $illus 'gopuram-hero.jpg'); bg = '#fbf5e8'; accent = '#a6175a'; label = 'OUR DAY' },
    @{ Path = (Join-Path $illus 'gopuram-card.jpg'); bg = '#fbf5e8'; accent = '#a6175a'; label = 'TOGETHER' },
    @{ Path = (Join-Path $illus 'bagh-gate.jpg'); bg = '#f3eadb'; accent = '#b5603a'; label = 'BAGH' },
    @{ Path = (Join-Path $illus 'bagh-hero.jpg'); bg = '#f3eadb'; accent = '#b5603a'; label = 'GARDEN' },
    @{ Path = (Join-Path $illus 'bagh-card.jpg'); bg = '#f3eadb'; accent = '#b5603a'; label = 'BLESSINGS' },
    @{ Path = (Join-Path $illus 'haveli-arrival.jpg'); bg = '#f8f3e8'; accent = '#9c4a3c'; label = 'HAVELI' },
    @{ Path = (Join-Path $illus 'haveli-gate.jpg'); bg = '#f8f3e8'; accent = '#9c4a3c'; label = 'ARRIVAL' },
    @{ Path = (Join-Path $illus 'haveli-card.jpg'); bg = '#f8f3e8'; accent = '#9c4a3c'; label = 'CARD' },
    @{ Path = (Join-Path $illus 'mandir-gate.jpg'); bg = '#f7ebd5'; accent = '#a8573a'; label = 'MANDIR' },
    @{ Path = (Join-Path $illus 'mandir-temple.jpg'); bg = '#f7ebd5'; accent = '#a8573a'; label = 'TEMPLE' },
    @{ Path = (Join-Path $illus 'mandir-card.jpg'); bg = '#f7ebd5'; accent = '#a8573a'; label = 'INVITATION' },
    @{ Path = (Join-Path $illus 'haveli-monogram.jpg'); bg = '#f7ebd5'; accent = '#5a1f2b'; label = 'VK' },
    @{ Path = (Join-Path $illus 'haveli-frame.png'); bg = '#f8f3e8'; accent = '#9c4a3c'; label = 'FRAMED'; format = 'Png' }
)

foreach ($entry in $artList) {
    $format = if ($entry.ContainsKey('format')) { $entry.format } else { 'Jpeg' }
    New-PlaceholderImage -path $entry.Path -bgHex $entry.bg -accentHex $entry.accent -label $entry.label -format $format
}

# Gallery placeholders
for ($i = 1; $i -le 4; $i++) {
    $path = Join-Path $moments ("m{0}.jpg" -f $i)
    New-PlaceholderImage -path $path -bgHex '#f7ecd9' -accentHex '#a8462c' -label "Photo $i" -width 900 -height 1125
}

# Blank audio placeholders for the invite files that reference music
@('sajna.m4a', 'krishna-flute.m4a') | ForEach-Object {
    $path = Join-Path $music $_
    [System.IO.File]::WriteAllBytes($path, @())
}

Write-Host "Assets restored into $art and $music"
