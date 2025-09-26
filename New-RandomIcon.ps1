function New-RandomIcon {
    param (
        [int]$Width = 512,
        [int]$Height = 512,
        [string]$OutputPath,
        [string]$IconName
    )
    # Ensure the output directory exists
    New-Item -ItemType Directory -Path $OutputPath -Force

    Add-Type -AssemblyName System.Drawing

    # Create a new blank bitmap
    $Bitmap = New-Object System.Drawing.Bitmap $Width, $Height
    $Graphics = [System.Drawing.Graphics]::FromImage($Bitmap)

    # Fill the background with a random color
    $Random = New-Object Random
    $BackgroundColor = [System.Drawing.Color]::FromArgb(
        $Random.Next(0, 256),
        $Random.Next(0, 256),
        $Random.Next(0, 256)
    )
    $Graphics.Clear($BackgroundColor)

    # Draw random shapes
    for ($i = 0; $i -lt 50; $i++) {
        $ShapeColor = [System.Drawing.Color]::FromArgb(
            $Random.Next(0, 256),
            $Random.Next(0, 256),
            $Random.Next(0, 256)
        )
        $Brush = New-Object System.Drawing.SolidBrush $ShapeColor

        $ShapeType = $Random.Next(0, 2)
        $X = $Random.Next(0, $Width)
        $Y = $Random.Next(0, $Height)
        $ShapeWidth = $Random.Next(20, 100)
        $ShapeHeight = $Random.Next(20, 100)

        if ($ShapeType -eq 0) {
            # Draw rectangle
            $Graphics.FillRectangle($Brush, $X, $Y, $ShapeWidth, $ShapeHeight)
        }
        else {
            # Draw ellipse
            $Graphics.FillEllipse($Brush, $X, $Y, $ShapeWidth, $ShapeHeight)
        }

        $Brush.Dispose()
    }

    # Save the image
    $Bitmap.Save((Join-Path $OutputPath "$IconName.png"), [System.Drawing.Imaging.ImageFormat]::Png)

    # Dispose of objects
    $Graphics.Dispose()
    $Bitmap.Dispose()
}