$targetExtensions = @(".html", ".css", ".js", ".php")
$ignoreFiles = @("obfuscate.ps1", "task.md", "implementation_plan.md")
$protectionScript = "<script>document.addEventListener('contextmenu',event=>event.preventDefault());document.onkeydown=function(e){if(e.keyCode==123||(e.ctrlKey&&e.shiftKey&&(e.keyCode==73||e.keyCode==74))||(e.ctrlKey&&(e.keyCode==85||e.keyCode==83))){return false}};</script>"

Function Minify-Html($content) {
    $content = $content -replace "<!--.*?-->", "" 
    $content = $content -replace ">\s+<", "><"
    $content = $content -replace "\s+", " "
    return $content.Trim()
}

Function Minify-Css($content) {
    $content = $content -replace "/\*[^(\*/)]*\*/", ""
    $content = $content -replace "\s+", " "
    $content = $content -replace "\s*([{:;,])\s*", "`$1"
    return $content.Trim()
}

Function Minify-Js($content) {
    # Basic JS minification: remove comments and extra whitespace
    $content = $content -replace "/\*[\s\S]*?\*/", ""
    $lines = $content -split "`n"
    $minifiedLines = @()
    foreach ($line in $lines) {
        $line = $line.Trim()
        if ($line.StartsWith("//")) { continue }
        if ($line) { $minifiedLines += $line }
    }
    return $minifiedLines -join ""
}

Function Inject-Protection($content) {
    if ($content -match "</head>") {
        return $content -replace "</head>", ($protectionScript + "</head>")
    }
    return $content
}

Get-ChildItem -Recurse | ForEach-Object {
    if ($_.Name -in $ignoreFiles) { return }
    if ($_.Extension -in $targetExtensions) {
        Write-Host "Processing $($_.FullName)..."
        $content = Get-Content $_.FullName -Raw -Encoding utf8
        $originalLen = $content.Length
        $newContent = $content

        if ($_.Extension -eq ".html" -or $_.Extension -eq ".php") {
            $newContent = Minify-Html $content
            if ($newContent -match "<html") {
                $newContent = Inject-Protection $newContent
            }
        }
        elseif ($_.Extension -eq ".css") {
            $newContent = Minify-Css $content
        }
        elseif ($_.Extension -eq ".js") {
            $newContent = Minify-Js $content
        }

        Set-Content $_.FullName -Value $newContent -Encoding utf8
        Write-Host "  Size: $originalLen -> $($newContent.Length) bytes"
    }
}
