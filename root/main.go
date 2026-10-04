package main

import (
    "fmt"
    "net"
    "os"
    "strings"

    "github.com/webview/webview_go"
)

func main() {
    debug := true
    w := webview.New(debug)
    defer w.Destroy()
    w.SetTitle("Browser")
    w.SetSize(800, 600, webview.HintNone)
    w.Navigate("https://duckduckgo.com")

    // === CREAZIONE SOCKET PER COMUNICAZIONE CON PANEL ===
    socketPath := "/tmp/brow.03.sock"
    os.Remove(socketPath) // Rimuove se già esiste
    ln, err := net.Listen("unix", socketPath)
    if err != nil {
        fmt.Println("Errore apertura socket:", err)
        return
    }
    defer ln.Close()

    // === THREAD PER GESTIONE COMANDI IN BACKGROUND ===
    go func() {
        for {
            conn, err := ln.Accept()
            if err != nil {
                continue
            }

            buf := make([]byte, 1024)
            n, _ := conn.Read(buf)
            command := strings.TrimSpace(string(buf[:n]))
            fmt.Println("Ricevuto comando:", command)

            switch command {
            case "reload":
                w.Dispatch(func() {
                    w.Eval("location.reload();")
                })
            case "back":
                w.Dispatch(func() {
                    w.Eval("history.back();")
                })
            default:
                fmt.Println("Comando sconosciuto:", command)
            }

            conn.Close()
        }
    }()

    // === LANCIA L'INTERFACCIA PRINCIPALE ===
    w.Run()
}
