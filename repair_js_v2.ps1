$content = Get-Content "e:/ramras/script.js" -Raw -Encoding utf8

$commentsToRemove = @(
    "// Store items {name, price, qty, img}",
    "// Default",
    "// Auto open",
    "// Prevent submission",
    "// Reset class and add error"
)

foreach ($comment in $commentsToRemove) {
    $pattern = [Regex]::Escape($comment)
    # Check if match exists
    if ($content -match $pattern) {
        Write-Host "Removing: $comment"
        $content = $content -replace $pattern, ""
    }
    else {
        Write-Host "Not found: $comment"
    }
}

Set-Content "e:/ramras/script.js" -Value $content -Encoding utf8
Write-Host "Repair complete and saved."
