$ExecutionContext.SessionState.LanguageMode = "FullLanguage"

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
$MatriceTitle = $Title -split "`n" | % {, $_.ToCharArray()}
$MatriceSubTitle = $Subtitle -split "`n" | % {, $_.ToCharArray()}

$Positions = @()

# Generate random positions for each element in $MatriceTitle
for ($i = 0; $i -lt $MatriceTitle.Count; $i++) {
    for ($j = 0; $j -lt $MatriceTitle[$i].Length; $j++) {
        $Positions += [PSCustomObject]@{ X = $j; Y = $i }
    }
}

# Shuffle the positions array
$Positions = $Positions | Sort-Object { Get-Random }

# Draw each element in random order
foreach ($Pos in $Positions) {
    [Console]::SetCursorPosition($Pos.X, $Pos.Y)
    Write-Host -NoNewline $MatriceTitle[$Pos.Y][$Pos.X]
    (Get-Random -Maximum 20) -eq 4 ? [System.Threading.Thread]::Sleep(1) : $null
}

$SubtitleOffsetY = $MatriceTitle.Count
$SubtitleOffsetX = [int]((($MatriceTitle | %{$_.length} | Measure-Object -Maximum).Maximum / 2) - (($MatriceSubTitle | %{$_.length} | Measure-Object -Maximum).Maximum / 2))

for ($col = $MatriceSubTitle[0].Length - 1; $col -ge 0; $col--) {
    for ($row = 0; $row -lt $MatriceSubTitle.Count; $row++) {
        [Console]::SetCursorPosition($SubtitleOffsetX + $col, $SubtitleOffsetY + $row)
        Write-Host -NoNewline $MatriceSubTitle[$row][$col]
    }
    [System.Threading.Thread]::Sleep(1)
}

# Reset cursor position
[Console]::SetCursorPosition(0, $SubtitleOffsetY + $MatriceSubTitle.Count + 2)