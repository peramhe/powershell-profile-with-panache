<#
.SYNOPSIS
PowerShell profile template with panache.

.DESCRIPTION
This script is intended to be used as a PowerShell profile script. It displays a title and subtitle in a fancy ASCII art style when the PowerShell console is started.

.NOTES
The title and subtitle are defined as multi-line strings and can be easily customized.

Known issues:
- If the console window is too small, the title and subtitle may not be displayed correctly.

Author:
    Henri Perämäki
#>

$Title = @"

░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓███████▓▒░ ░▒▓███████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░ ░▒▓███████▓▒░ ░▒▓██████▓▒░░▒▓████████▓▒░▒▓██████▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░
░▒▓█▓▒░       ░▒▓██████▓▒░ ░▒▓█████████████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓████████▓▒░

"@

$Subtitle = @"
                                                                   
   ad88                               88  88     ad88              
  d8"                                 88  ""    d8"                
  88                                  88        88                 
MM88MMM   ,adPPYba,   8b,dPPYba,      88  88  MM88MMM   ,adPPYba,  
  88     a8"     "8a  88P'   "Y8      88  88    88     a8P_____88  
  88     8b       d8  88              88  88    88     8PP"""""""  
  88     "8a,   ,a8"  88              88  88    88     "8b,   ,aa  
  88      '"YbbdP"'   88              88  88    88      '"Ybbd8"'  
                                                                   
"@

# Split the title and subtitle into matrices of characters
$MatrixTitle = $Title -split "`n" | % {, $_.ToCharArray()}
$MatrixSubTitle = $Subtitle -split "`n" | % {, $_.ToCharArray()}

$TitleWidth = ($MatrixTitle | %{$_.length} | Measure-Object -Maximum).Maximum
$SubtitleWidth = ($MatrixSubTitle | %{$_.length} | Measure-Object -Maximum).Maximum

$MinimumWindowSize = @{
    X = [math]::max($TitleWidth, $SubtitleWidth) + 10
    Y = $MatrixTitle.Count + $MatrixSubTitle.Count + 10
}

If ([Console]::WindowWidth -lt $MinimumWindowSize.X -or [Console]::WindowHeight -lt $MinimumWindowSize.Y) {
    [Console]::SetWindowSize([math]::max([Console]::WindowWidth, $MinimumWindowSize.X), [math]::max([Console]::WindowHeight, $MinimumWindowSize.Y))
    $HadToResize = $true
}


$Positions = @()

# Generate random positions for each element in $MatrixTitle
for ($i = 0; $i -lt $MatrixTitle.Count; $i++) {
    for ($j = 0; $j -lt $MatrixTitle[$i].Length; $j++) {
        $Positions += [PSCustomObject]@{ X = $j; Y = $i }
    }
}

# Shuffle the positions array
$Positions = $Positions | Sort-Object { Get-Random }

# Draw each element in random order
foreach ($Pos in $Positions) {
    [Console]::SetCursorPosition($Pos.X, $Pos.Y)
    Write-Host -NoNewline $MatrixTitle[$Pos.Y][$Pos.X]
    (Get-Random -Maximum 20) -eq 4 ? [System.Threading.Thread]::Sleep(1) : $null
}

$SubtitleOffsetY = $MatrixTitle.Count
$SubtitleOffsetX = [int](($TitleWidth / 2) - ($SubtitleWidth / 2))
$Iteration = 0
"DarkGray", "Gray", "Green" | ForEach-Object {
    $Iteration++
    # Direction of the sweep
    if ($Iteration -eq 1 -or $Iteration -ge 3) {
        $Init = {$script:col = $MatrixSubTitle[0].Length - 1}
        $Cond = {$script:col -ge 0}
        $Iter = {$script:col--}
    } else {
        $Init = {$script:col = 0}
        $Cond = {$script:col -lt $MatrixSubTitle[0].Length}
        $Iter = {$script:col++}
    }
    for (&$Init; &$Cond; &$Iter) {
        $ForegroundColor = $_
        for ($row = 0; $row -lt $MatrixSubTitle.Count; $row++) {
            [Console]::SetCursorPosition($SubtitleOffsetX + $col, $SubtitleOffsetY + $row)
            Write-Host -NoNewline $MatrixSubTitle[$row][$col] -ForegroundColor $ForegroundColor
        }
        
        ($Iteration -eq 1 -and (Get-Random -Maximum 3) -eq 2) ? [System.Threading.Thread]::Sleep(1) : $null
    }
}

# Reset cursor position
[Console]::SetCursorPosition(0, $SubtitleOffsetY + $MatrixSubTitle.Count + 2)

If ($HadToResize) {
    Write-Host "Note: Resized console to fit the title which may cause suboptimal experience."
}
