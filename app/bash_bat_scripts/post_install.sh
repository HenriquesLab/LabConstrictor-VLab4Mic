#!/bin/bash
set -e
echo "Running post_install" > "$PREFIX/menuinst_debug.log"

"$PREFIX/bin/python" -m pip install -r "$PREFIX/VLab4Mic/requirements.txt" >> "$PREFIX/menuinst_debug.log"

# Check if the running platform is macOS or Linux and install additional requirements if the corresponding file exists
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Detected macOS platform" >> "$PREFIX/menuinst_debug.log"
        
    if [ -f "$PREFIX/VLab4Mic/requirements-macos.txt" ]; then
        "$PREFIX/bin/python" -m pip install -r "$PREFIX/VLab4Mic/requirements-macos.txt" >> "$PREFIX/menuinst_debug.log"
    fi

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Detected Linux platform" >> "$PREFIX/menuinst_debug.log"

    if [ -f "$PREFIX/VLab4Mic/requirements-linux.txt" ]; then
        "$PREFIX/bin/python" -m pip install -r "$PREFIX/VLab4Mic/requirements-linux.txt" >> "$PREFIX/menuinst_debug.log"
    fi

else
    echo "Unknown platform: $OSTYPE" >> "$PREFIX/menuinst_debug.log"
fi

PROJECT_ROOT="$PREFIX/VLab4Mic"
if [ -f "$PROJECT_ROOT/setup.py" ]; then
    echo "Found setup.py, installing VLab4Mic package locally" >> "$PREFIX/menuinst_debug.log" 
    "$PREFIX/bin/python" -m pip install "$PROJECT_ROOT" >> "$PREFIX/menuinst_debug.log"
else
    echo "No setup.py detected, skipping local pip install" >> "$PREFIX/menuinst_debug.log"
fi
"$PREFIX/bin/python" "$PREFIX/VLab4Mic/include_path.py" --path "$PREFIX" --files "$PREFIX/VLab4Mic/notebook_launcher.json" --keyword "BASE_PATH_KEYWORD" >> "$PREFIX/menuinst_debug.log"
"$PREFIX/bin/python" "$PREFIX/VLab4Mic/include_path.py" --path "$PREFIX" --files "$PREFIX/pre_uninstall.sh" --keyword "BASE_PATH" >> "$PREFIX/menuinst_debug.log"
"$PREFIX/bin/python" "$PREFIX/VLab4Mic/include_path.py" --path "$PREFIX" --files "$PREFIX/uninstall.sh" --keyword "BASE_PATH" >> "$PREFIX/menuinst_debug.log"
"$PREFIX/bin/python" "$PREFIX/VLab4Mic/hide_code_cells.py" "$PREFIX/VLab4Mic" >> "$PREFIX/menuinst_debug.log"
"$PREFIX/bin/python" -c "import os, sys; print('Python:', sys.executable); print('Prefix:', os.environ.get('PREFIX'))" >> "$PREFIX/menuinst_debug.log"
"$PREFIX/bin/python" -c "from menuinst.api import install; import os; print(install(os.path.join('$PREFIX', 'VLab4Mic', 'notebook_launcher.json')))" >> "$PREFIX/menuinst_debug.log" 2>&1

if [ -t 0 ]; then
    echo
    read -rp "Press Enter to close the installer..." _
fi