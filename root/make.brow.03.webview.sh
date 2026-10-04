#!/bin/bash
# make.brow.03.webview.sh - Crea tutto: main.go, run.sh, dipendenze e binario

set -e
BASE_DIR="/mnt/bkp.05.03/ws.03.cst.apps/brow.03/root"
cd "$BASE_DIR"

echo "[+] INSTALLO DIPENDENZE DI SISTEMA..."
sudo apt update
sudo apt install -y libwebkit2gtk-4.0-dev golang

echo "[+] CREO FILE: main.go"
cat > main.go << 'EOF'
package main

import webview "github.com/webview/webview_go"

func main() {
    debug := true
    w := webview.New(debug)
    defer w.Destroy()

    w.SetTitle("Go Webview Browser")
    w.SetSize(1024, 768, webview.HintNone)
    w.Navigate("https://www.duckduckgo.com")
    w.Run()
}
EOF

echo "[+] CREO FILE: run.brow.03.webview.sh"
cat > run.brow.03.webview.sh << 'EOF'
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
EOF

chmod +x run.brow.03.webview.sh

echo "[+] INIZIALIZZO MODULO Go..."
go mod init brow.03.webview 2>/dev/null || true

echo "[+] INSTALLAZIONE MODULO webview_go..."
go get github.com/webview/webview_go
go mod tidy

echo "[+] COMPILO IL BROWSER..."
go build -o brow.03.webview main.go

echo "[✓] Tutto pronto! Usa ./run.brow.03.webview.sh per avviare."
