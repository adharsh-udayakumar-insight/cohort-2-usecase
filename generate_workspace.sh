#!/bin/bash
# generate_workspace.sh

echo "=== Generating Test Workspace ==="
BASE_DIR="./Projects"

# Create base directory
mkdir -p "$BASE_DIR"

for proj in WebApp API; do
    echo "[INFO] Creating project structure - $proj"
    mkdir -p "$BASE_DIR/$proj/src"
    mkdir -p "$BASE_DIR/$proj/docs"
    mkdir -p "$BASE_DIR/$proj/config"
    mkdir -p "$BASE_DIR/$proj/assets"

   
    echo "SECRET_KEY=supersecret" > "$BASE_DIR/$proj/.env"
    echo "*.log" > "$BASE_DIR/$proj/.gitignore"

    
    echo "console.log('Hello World');" > "$BASE_DIR/$proj/src/index.js"
    echo "<h1>Welcome</h1>" > "$BASE_DIR/$proj/src/index.html"
    echo "user=admin" > "$BASE_DIR/$proj/config/settings.conf"
    
    
    head -c 512 </dev/urandom > "$BASE_DIR/$proj/assets/icon.png" 2>/dev/null
    head -c 2048 </dev/urandom > "$BASE_DIR/$proj/assets/data.bin" 2>/dev/null
done


mkdir -p "$BASE_DIR/WebApp/empty_dir"


mkdir -p "$BASE_DIR/InaccessibleProject"
echo "Top secret data." > "$BASE_DIR/InaccessibleProject/secret.txt"
chmod 000 "$BASE_DIR/InaccessibleProject"
echo "[INFO] Created inaccessible directory at $BASE_DIR/InaccessibleProject"

echo "complete"
