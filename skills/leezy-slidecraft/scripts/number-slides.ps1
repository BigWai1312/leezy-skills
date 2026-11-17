param(
    [Parameter(Mandatory=$true)][string]$InputPath,
    [Parameter(Mandatory=$true)][string]$OutputPath,
    [string]$FontName = '微软雅黑'
)
$ErrorActionPreference = 'Stop'
$source = (Resolve-Path -LiteralPath $InputPath).Path
$destination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
if ($source -eq $destination -or (Test-Path -LiteralPath $destination)) {
    throw 'Output must be a new file, not the input or an existing file.'
}
if ([IO.Path]::GetExtension($destination) -ne '.pptx') { throw 'Output must be .pptx.' }
if ([IO.Path]::GetExtension($source) -ne '.pptx') { throw 'Only .pptx inputs are supported; preserve macro-enabled files separately.' }
if (-not (Test-Path -LiteralPath (Split-Path -Parent $destination))) { throw 'Create the output directory first.' }
$app = $null
$deck = $null
$initialCount = -1
try {
    $app = New-Object -ComObject PowerPoint.Application
    $initialCount = $app.Presentations.Count
    $deck = $app.Presentations.Open($source, -1, 0, 0)
    if ($deck.Slides.Count -eq 0) { throw 'Input has no slides.' }
    foreach ($slide in $deck.Slides) {
        if ($slide.DisplayMasterShapes -ne -1) {
            throw "Slide $($slide.SlideIndex) hides master graphics. Inspect it before applying master numbering."
        }
    }
    $scaleX = $deck.PageSetup.SlideWidth / 960
    $scaleY = $deck.PageSetup.SlideHeight / 540
    $deck.PageSetup.FirstSlideNumber = 1
    foreach ($design in $deck.Designs) {
        $master = $design.SlideMaster
        $master.HeadersFooters.SlideNumber.Visible = 0
        foreach ($layout in $master.CustomLayouts) { $layout.HeadersFooters.SlideNumber.Visible = 0 }
        for ($i=$master.Shapes.Count; $i -ge 1; $i--) {
            if ($master.Shapes.Item($i).Name -in @('SC_SlideNumber','AutoSlideNumber')) { $master.Shapes.Item($i).Delete() }
        }
        $number = $master.Shapes.AddTextbox(1, 900*$scaleX, 518*$scaleY, 42*$scaleX, 17*$scaleY)
        $number.Name = 'SC_SlideNumber'
        [void]$number.TextFrame.TextRange.InsertSlideNumber()
        $number.Fill.Visible = 0
        $number.Line.Visible = 0
        $number.TextFrame.MarginLeft = 0
        $number.TextFrame.MarginRight = 0
        $number.TextFrame.MarginTop = 0
        $number.TextFrame.MarginBottom = 0
        $number.TextFrame.VerticalAnchor = 3
        $number.TextFrame.WordWrap = 0
        $number.TextFrame.TextRange.Font.Name = $FontName
        $number.TextFrame.TextRange.Font.Size = 12*$scaleY
        $number.TextFrame.TextRange.Font.Bold = 0
        $number.TextFrame.TextRange.Font.Color.RGB = 0xB16701
        $number.TextFrame.TextRange.ParagraphFormat.Alignment = 3
    }
    foreach ($slide in $deck.Slides) { $slide.HeadersFooters.SlideNumber.Visible = 0 }
    $deck.SaveAs($destination,24)
    Write-Output "Created $destination with native master slide numbering. Inspect layout and existing manually typed page numbers."
}
finally {
    if ($null -ne $deck) { $deck.Close(); [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($deck) }
    if ($null -ne $app) {
        if ($initialCount -eq 0 -and $app.Presentations.Count -eq 0) { $app.Quit() }
        [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($app)
    }
}
