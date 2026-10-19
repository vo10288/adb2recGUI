# adb2rec-gui — Android screenshot, video e audio

**Autore:** Antonio “Visi@n” Broi — antonio@tsurugi-linux.org  
**Progetto:** Tsurugi Linux — https://tsurugi-linux.org  
**Licenza del programma:** MIT  
**Documentazione aggiornata:** 19 ottobre 2026

Interfaccia Python/Tkinter per screenshot Android, registrazione dello schermo con audio interno e anteprima sul computer, elaborazione video, compressione e calcolo degli hash.

## Requisito fondamentale: scrcpy aggiornato, completo di scrcpy-server

> Usare una release ufficiale recente di **scrcpy insieme al suo scrcpy-server della stessa identica versione**. Non basta aggiornare o copiare il solo eseguibile `scrcpy`. Conservare tutti i file dell'archivio ufficiale nella loro cartella.

Al 19 ottobre 2026 la release ufficiale più recente verificata è **scrcpy 5.0.1**. Gli esempi seguenti si riferiscono a questa versione; per aggiornamenti successivi consultare sempre la [pagina ufficiale delle release](https://github.com/Genymobile/scrcpy/releases/latest).

| Componente | Funzione |
| --- | --- |
| `scrcpy` | Client eseguito sul computer: anteprima e salvataggio del flusso audio/video. |
| `scrcpy-server` | Componente eseguito sul telefono, trasferito e avviato automaticamente dal client tramite ADB. Non si installa manualmente come una normale app. |
| `adb` | Comunicazione con il dispositivo Android autorizzato. |
| `ffmpeg` | Riparazione/ricodifica dei filmati e ottimizzazione OCR. |

Client e server con versioni diverse non sono compatibili. Per esempio, non abbinare un client 5.0.1 a un server 5.0 o 1.25.

Le vecchie versioni distribuite nei repository di alcune distribuzioni possono non funzionare con Android recente. Errori come `NoSuchMethodException`, `IClipboard` o `SurfaceControl.createDisplay` possono indicare questa incompatibilità.

## Installazione su Tsurugi Linux / Ubuntu x86_64

### 1. Dipendenze del programma

```bash
sudo apt update
sudo apt install python3 python3-tk adb ffmpeg wget tar coreutils
```

`jp2a` è opzionale: viene utilizzato per il banner. Il programma richiede inoltre la locale `en_US.UTF-8`. Se all'avvio compare `unsupported locale setting`:

```bash
sudo apt install locales
sudo locale-gen en_US.UTF-8
```

### 2. Pacchetto ufficiale già compilato

Verificare l'architettura:

```bash
uname -m
```

I comandi seguenti sono per `x86_64`:

```bash
cd "$HOME"
wget https://github.com/Genymobile/scrcpy/releases/download/v5.0.1/scrcpy-linux-x86_64-v5.0.1.tar.gz
```

Verificare il checksum pubblicato nella documentazione ufficiale per questa specifica release:

```bash
printf '%s  %s\n' \
  '9f969d30cc574816077edecda65719c1c70b0aee1df1ba5fa00779ac07b8fd6e' \
  'scrcpy-linux-x86_64-v5.0.1.tar.gz' | sha256sum -c -
```

Procedere solo se la verifica restituisce `OK`:

```bash
tar -xzf scrcpy-linux-x86_64-v5.0.1.tar.gz
ls -l "$HOME/scrcpy-linux-x86_64-v5.0.1/scrcpy" \
      "$HOME/scrcpy-linux-x86_64-v5.0.1/scrcpy-server"
```

Mantenere l'intera cartella estratta. Il pacchetto pronto all'uso evita la compilazione locale del client e delle sue dipendenze di sviluppo, come SDL3.

### 3. Impostare esplicitamente client e server

Nel terminale da cui si avvia adb2rec-gui:

```bash
export SCRCPY_BINARY="$HOME/scrcpy-linux-x86_64-v5.0.1/scrcpy"
export SCRCPY_SERVER_PATH="$HOME/scrcpy-linux-x86_64-v5.0.1/scrcpy-server"
"$SCRCPY_BINARY" --version
```

- `SCRCPY_BINARY` è la variabile letta da **adb2rec-gui** per scegliere il client.
- `SCRCPY_SERVER_PATH` è letta da **scrcpy**, e indica il server abbinato.
- Queste impostazioni valgono per il terminale corrente e per i processi avviati da esso.
- Se si aggiorna scrcpy, aggiornare **entrambi** i percorsi.

La build portabile cerca normalmente il server vicino al proprio eseguibile; indicarlo esplicitamente evita ambiguità dovute ad altre installazioni o variabili già configurate.

### 4. Rendere scrcpy disponibile nel PATH

Non occorre copiare il solo eseguibile in `/usr/bin`. Per usarlo dal terminale mantenendo il pacchetto completo:

```bash
export PATH="$HOME/scrcpy-linux-x86_64-v5.0.1:$PATH"
hash -r
command -v scrcpy
scrcpy --version
```

Per rendere persistenti PATH e variabili, inserire le tre righe `export` appropriate in `~/.bashrc` se si usa Bash. Le applicazioni lanciate da un menu grafico potrebbero non ereditare questo file: in quel caso usare un launcher che imposti le variabili oppure avviare il programma dal terminale configurato.

adb2rec-gui sceglie il client nell'ordine:

1. Percorso definito in `SCRCPY_BINARY`.
2. Copie eseguibili in `~/scrcpy-linux-x86_64-v*/scrcpy`, ordinate per data di modifica più recente, non per numero di versione.
3. `scrcpy` trovato nel PATH.

Impostare `SCRCPY_BINARY` è il metodo consigliato quando sono presenti più versioni.

## Avvio di adb2rec-gui

Dalla cartella contenente il programma:

```bash
python3 ./adb2rec-gui
```

Per avviarlo direttamente:

```bash
chmod +x ./adb2rec-gui
./adb2rec-gui
```

Lo shebang originale punta a `/opt/virtualenv/computer_vision/bin/python3`: l'avvio diretto richiede che questo interprete esista e supporti Tkinter. `python3 ./adb2rec-gui` permette invece di scegliere il Python disponibile sul sistema. Avviare con l'utente normale configurato per accedere al dispositivo, così output e percorsi rimangono nella sua home.

## Collegamento del telefono

1. Abilitare Opzioni sviluppatore e Debug USB.
2. Collegare il telefono via USB e autorizzare il computer sul dispositivo.
3. Controllare:

```bash
adb devices -l
```

Lo stato deve essere `device`, non `unauthorized` o `offline`. Per l'uso standard mantenere un solo dispositivo ADB collegato.

Il pulsante **ADB CONNECT CABLE** configura anche ADB TCP/IP sulla porta **7777**. Per la sola acquisizione USB, se `adb devices -l` vede già il dispositivo, non occorre premere quel pulsante. Per Wi-Fi, dopo la configurazione via cavo, usare **ADB CONNECT WIFI** con l'indirizzo IP del telefono; PC e telefono devono comunicare sulla stessa rete. A fine uso Wi-Fi è possibile tornare alla modalità USB con `adb usb`.

## Registrare schermo e audio con anteprima

Premere **SCREEN RECORD**:

- Si apre l'anteprima dello schermo sul computer, con riproduzione dell'audio ricevuto.
- Il file contiene video H.264, bitrate video impostato a 4 Mbit/s, e audio interno AAC.
- Il microfono non è la sorgente selezionata.
- Ogni segmento dura al massimo **180 secondi**; il successivo riparte dopo l'elaborazione del precedente.
- L'anteprima è senza controllo remoto (`--no-control`): interagire sul telefono.
- **STOP SCREEN RECORD** interrompe la sequenza e attende la finalizzazione del file corrente.

Per terminare tutta la sequenza usare il pulsante STOP della GUI. Chiudere soltanto la finestra scrcpy può far avviare il segmento successivo. Attendere la conclusione della riparazione prima di comprimere o spostare i file.

Il comando di registrazione usato dal programma equivale a:

```bash
"$SCRCPY_BINARY" \
  --record="temp_1.mp4" \
  --video-bit-rate=4M --video-codec=h264 \
  --audio-source=output --audio-codec=aac --require-audio \
  --time-limit=180 --no-control
```

L'audio richiede Android 11 o successivo; su Android 11 lo schermo deve essere sbloccato all'avvio della cattura audio. La disponibilità concreta dipende dal dispositivo e dal contenuto. Le app possono limitare la cattura: un file con traccia audio può comunque contenere silenzio. I contenuti protetti possono risultare neri. Il programma richiede l'avvio della cattura audio con `--require-audio`, ma non verifica automaticamente che la traccia contenga suono udibile.

## Screenshot e altre funzioni

| Pulsante | Comportamento |
| --- | --- |
| SCREENSHOT | Acquisizione ripetuta PNG tramite ADB `screencap`. |
| SCREENSHOT UP / DOWN | Acquisizione ripetuta con swipe alle coordinate predefinite del programma. |
| STOP SCREENSHOT | Arresto della sequenza screenshot. |
| REPAIR EXISTING VIDEOS | Ricodifica dei filmati MP4 esistenti e creazione di versioni ottimizzate OCR. Le tracce audio presenti vengono mantenute tramite ricodifica AAC. |
| COMPRESS FILES AND CALCULATE HASH | Creazione degli archivi e calcolo MD5/SHA-256, con organizzazione sotto l'Android ID se disponibile. |

Gli swipe usano coordinate fisse: controllarne il risultato sul dispositivo. Avviare compressione e hash solo dopo avere fermato screenshot e registrazione.

## Cartelle e file prodotti

Cartella base:

```text
~/02.computer_vision/04.video2ocr/
```

| Percorso | Contenuto |
| --- | --- |
| `screenshot/<timestamp>/` | Screenshot PNG numerati. |
| `screenrecord/<timestamp>/` | Segmenti MP4 e log `scrcpy_<numero>.log`. |
| `repaired_videos/` | Elaborazioni generate dal pulsante di riparazione dei video esistenti. |
| `compressfiles/` | Archivi compressi. |
| `hashfiles/` | Hash MD5 e SHA-256 degli archivi. |

La registrazione scrive prima `temp_<numero>.mp4`, poi genera `<numero>.mp4` tramite FFmpeg. Se la riparazione riesce, il temporaneo viene eliminato; se fallisce, il programma tenta di conservare/rinominare l'originale. Dopo la compressione, le cartelle possono essere spostate nella sottocartella identificata dall'Android ID.

**Limiti da considerare nell'uso forense:** la riparazione e l'ottimizzazione OCR ricodificano il contenuto; il programma non conserva sempre anche il flusso originale. Tra segmenti sono possibili interruzioni, anche durante l'elaborazione FFmpeg. Gli hash riguardano gli archivi prodotti e non dimostrano da soli completezza della registrazione o autenticità della schermata sorgente. La procedura interagisce con un dispositivo acceso e non costituisce un'acquisizione fisica o filesystem.

## Controllo di un filmato

Registrare una breve prova con contenuto audio noto e verificare sia immagine sia suono:

```bash
ffprobe -v error -show_entries stream=index,codec_type,codec_name \
  -of json "/percorso/al/filmato.mp4"
```

Devono comparire le tracce `video` e `audio`; ascoltare anche il risultato.

## Risoluzione dei problemi

| Problema | Verifica |
| --- | --- |
| Viene avviata la vecchia versione | `command -v scrcpy`, `scrcpy --version`, `printf '%s\n' "$SCRCPY_BINARY"`. Controllare anche `Using scrcpy:` nel terminale della GUI. |
| Server non trovato o versione non corrispondente | Verificare `SCRCPY_SERVER_PATH`; usare client e server dallo stesso archivio ufficiale. |
| `NoSuchMethodException`, `IClipboard`, `SurfaceControl` | Aggiornare insieme client e server; verificare che non venga richiamata una copia obsoleta. |
| Audio non disponibile | Controllare versione Android, autorizzazione ADB e log `scrcpy_<numero>.log`; provare contenuto non protetto e schermo sbloccato. |
| Dispositivo non rilevato | Controllare cavo dati, autorizzazione sul telefono, `adb devices -l` e presenza di più dispositivi. |
| `Dependency sdl3 not found` in compilazione | Usare il pacchetto ufficiale già compilato oppure seguire integralmente le dipendenze della documentazione upstream. |
| `unsupported locale setting` | Generare `en_US.UTF-8` come indicato sopra. |
| Tkinter non disponibile | Installare `python3-tk` e verificare l'interprete con cui si avvia il programma. |

## Aggiornamenti

Scaricare l'ultima release ufficiale, verificarne il checksum, estrarla in una nuova cartella e aggiornare insieme `SCRCPY_BINARY`, `SCRCPY_SERVER_PATH` e l'eventuale PATH. Ripetere una breve prova di registrazione con audio prima dell'uso operativo. Il checksum riportato in questo README vale soltanto per l'archivio Linux x86_64 della versione 5.0.1.

## Riferimenti

- [scrcpy: release ufficiali](https://github.com/Genymobile/scrcpy/releases/latest)
- [Installazione Linux e checksum](https://github.com/Genymobile/scrcpy/blob/master/doc/linux.md)
- [Architettura client/server e corrispondenza delle versioni](https://github.com/Genymobile/scrcpy/blob/master/doc/develop.md)
- [Registrazione](https://github.com/Genymobile/scrcpy/blob/master/doc/recording.md)
- [Audio](https://github.com/Genymobile/scrcpy/blob/master/doc/audio.md)

scrcpy, ADB e FFmpeg sono progetti esterni con le rispettive licenze. Non sono inclusi in questo README né nel solo script Python.
