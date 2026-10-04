#!/bin/bash
# run.brow.03.webview.sh - Avvia mini-browser WebView

export BASE_DIR="/mnt/bkp.05.03/ws.03.cst.apps/brow.03/root"
cd "$BASE_DIR"

if [[ ! -f ./brow.03.webview ]]; then
    echo "[-] Binario non trovato. Compilo ora..."
    bash make.brow.03.webview.sh
fi

echo "[+] Avvio browser..."
./brow.03.webview
