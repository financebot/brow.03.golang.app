package main

import (
    "fmt"
    "net"
    "fyne.io/fyne/v2"
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
