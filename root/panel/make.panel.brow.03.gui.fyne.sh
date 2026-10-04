#!/bin/bash
# make.panel.brow.03.gui.fyne.sh
# Crea pannello GUI nativa con Fyne (Reload / Back)

set -e

BASE_DIR="/mnt/bkp.05.03/ws.03.cst.apps/brow.03/root/panel"
cd "$BASE_DIR"

echo "[+] INSTALLAZIONE DIPENDENZE..."
apt update
apt install -y golang libgl1-mesa-dev xorg-dev

echo "[+] CREO main.go..."
cat > main.go << 'EOF'
package main

import (
    "fmt"
    "net"
    "fyne.io/fyne/v2/app"
    "fyne.io/fyne/v2/container"
    "fyne.io/fyne/v2/widget"
)

func sendCommand(cmd string) {
    conn, err := net.Dial("unix", "/tmp/brow.03.sock")
    if err != nil {
        fmt.Println("Errore connessione socket:", err)
        return
    }
    defer conn.Close()
    conn.Write([]byte(cmd + "\n"))
}

func main() {
    a := app.New()
    w := a.NewWindow("Browser Panel")
    w.Resize(fyne.NewSize(300, 150))

    reloadBtn := widget.NewButton("Reload", func() { sendCommand("reload") })
    backBtn := widget.NewButton("Back", func() { sendCommand("back") })

    w.SetContent(container.NewVBox(
        widget.NewLabel("Controllo Browser"),
        reloadBtn,
        backBtn,
    ))

    w.ShowAndRun()
}
EOF

echo "[+] CREO run.panel.brow.03.gui.fyne.sh..."
cat > run.panel.brow.03.gui.fyne.sh << 'EOF'
#!/bin/bash
# Avvia il pannello nativo
cd /mnt/bkp.05.03/ws.03.cst.apps/brow.03/root/panel
go run main.go
EOF

chmod +x run.panel.brow.03.gui.fyne.sh

echo "[+] INIZIALIZZO MODULO GO..."
go mod init panel.brow.03.gui.fyne || true
go get fyne.io/fyne/v2
go mod tidy

echo "[+] COMPILO BINARIO..."
go build -o panel.gui.bin main.go

echo "[✓] Pannello GUI creato! Usa ./run.panel.brow.03.gui.fyne.sh"

