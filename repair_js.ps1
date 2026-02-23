$content = Get-Content "e:/ramras/script.js" -Raw -Encoding utf8

# List of known comments to remove.
# We must be careful to match exactly.
$commentsToRemove = @(
    "// Store items {name, price, qty, img}",
    "// Default",
    "// Auto open",
    "// Prevent submission",
    "// Reset class and add error"
)

foreach ($comment in $commentsToRemove) {
    # Escape special regex characters in the comment string?
    # -replace uses regex.
    # [Regex]::Escape($comment) helps.
    $pattern = [Regex]::Escape($comment)
    $content = $content -replace $pattern, ""
}

# Verify if other // exist (excluding http:// https://)
$indices = [regex]::Matches($content, "//").Index
foreach ($idx in $indices) {
    if ($idx -gt 0) {
        $prevChar = $content[$idx - 1]
        if ($prevChar -ne ':') {
            # Potential issue
            $context = $content.Substring([Math]::Max(0, $idx - 10), [Math]::Min($content.Length - $idx + 10, 50))
            Write-Host "Potential remaining comment at index $idx: ...$context..."
        }
    }
}

Set-Content "e:/ramras/script.js" -Value $content -Encoding utf8
Write-Host "Repair complete."
