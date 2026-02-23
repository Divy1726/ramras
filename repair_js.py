import re

file_path = 'e:/ramras/script.js'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix known issue: // Store items ...
# We'll use a regex to find // comments that are NOT inside strings (simple approximation)
# Or just target the specific one we saw.
# The specific one: "// Store items {name, price, qty, img}"
content = content.replace('// Store items {name, price, qty, img}', '')

# Check for other // occurrences
# We print them to see if we need to fix more
indices = [m.start() for m in re.finditer('//', content)]
print(f"Found // at: {indices}")
for idx in indices:
    print(f"Context: {content[idx-10:idx+50]}")

# Save fixed content
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
