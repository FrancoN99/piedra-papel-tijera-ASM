
.8086
jumps
.model small
.stack 100h
 
.data
 
    mensajePiedra db "PC eligio: Piedra", 0dh,0ah,24h
    mensajePapel  db "PC eligio: Papel", 0dh,0ah,24h
    mensajeTijera db "PC eligio: Tijera", 0dh,0ah,24h
    cartel db "Piedra, Papel o Tijera!", 0dh,0ah,24h
    cartel2 db "1=Piedra 2=Papel 3=Tijera", 0dh,0ah,24h
    mensajeEmpate db "Usted ha empatado", 0dh,0ah,24h
    mensajePierdePc1 db "Usted ha ganado! Llego a 3 puntos",0dh,0ah,24h
    mensajeGanaPc1 db "Usted ha perdido! La Cpu llego a 3 Cpu",0dh,0ah,24h
    mensajePierdePc db "Usted ha ganado! Suma 1 punto",0dh,0ah,24h
    mensajeGanaPc db "Usted ha perdido! Suma un 1 punto la Cpu",0dh,0ah,24h
    eleccion db 0
    eleccionPc db 0
    contadorCpu db "0", 0dh,0ah,24h
    contadorUsu db "0", 0dh,0ah,24h
    PuntajeUsu db "Su puntaje es: ",24h
    PuntajeCpu db "Puntaje de Cpu: ",24h
    msgNoTsr db "Primero ejecute mint.com",0dh,0ah,24h
    msgContinuar db "Presione una tecla...",24h
    lblUsu db "USTED",24h
    lblCpu db "CPU",24h
 
    ; ---- menu principal ----
    msgMenu1 db 0dh,0ah,"   1. P1 vs COM",0dh,0ah,24h
    msgMenu2 db "   2. P1 vs P2",0dh,0ah,24h
    msgMenu3 db "   3. Stats",0dh,0ah,24h
    msgMenu4 db "   4. Exit",0dh,0ah,0dh,0ah,24h
    msgMenuOp db "Elija una opcion: ",24h
 
    ; ---- modo P1 vs COM ----
    msgTituloCom db "== Jugador 1 vs COM ==",0dh,0ah,24h
 
    ; ---- modo P1 vs P2 ----
    msgTituloP2 db "== Jugador 1 vs Jugador 2 ==",0dh,0ah,24h
    msgCtrlP1 db "P1: 1=Piedra 2=Papel 3=Tijera",0dh,0ah,24h
    msgCtrlP2 db "P2: J=Piedra K=Papel L=Tijera",0dh,0ah,24h
    ; ambos textos miden 25 caracteres para que uno tape completamente al otro
    msgEspP1   db "P1: esperando eleccion...",24h
    msgListoP1 db "P1: LISTO!               ",24h
    msgEspP2   db "P2: esperando eleccion...",24h
    msgListoP2 db "P2: LISTO!               ",24h
    listo1 db 0
    listo2 db 0
    lblJ1 db "JUGADOR 1",24h
    lblJ2 db "JUGADOR 2",24h
    PuntajeP1 db "Puntaje Jugador 1: ",24h
    PuntajeP2 db "Puntaje Jugador 2: ",24h
    msgEmpateP2 db "Empate en la ronda",0dh,0ah,24h
    msgRondaJ1 db "Jugador 1 gana la ronda",0dh,0ah,24h
    msgRondaJ2 db "Jugador 2 gana la ronda",0dh,0ah,24h
    msgPartidaJ1 db "JUGADOR 1 GANA LA PARTIDA!",0dh,0ah,24h
    msgPartidaJ2 db "JUGADOR 2 GANA LA PARTIDA!",0dh,0ah,24h
 
    ; ---- estadisticas ----
    msgStats db "-- Historial acumulado --",0dh,0ah,24h
    msgStTitCom db 0dh,0ah,"[P1 vs COM]",0dh,0ah,24h
    msgStTitP2  db 0dh,0ah,"[P1 vs P2]",0dh,0ah,24h
    msgStUsu db "Ganadas por usted: ",24h
    msgStPc  db "Ganadas por la Cpu: ",24h
    msgStJ1  db "Ganadas por Jugador 1: ",24h
    msgStJ2  db "Ganadas por Jugador 2: ",24h
    msgStEmp db "Empates: ",24h
    nroUsu db "000",0dh,0ah,24h
    nroPc  db "000",0dh,0ah,24h
    nroEmp db "000",0dh,0ah,24h
    nroJ1  db "000",0dh,0ah,24h
    nroJ2  db "000",0dh,0ah,24h
    nroEmp2 db "000",0dh,0ah,24h
    statU db 0
    statP db 0
    statE db 0
 
    ; contadores locales del modo P1 vs P2 (rondas)
    p2Gan1 db 0
    p2Gan2 db 0
    p2Emp  db 0
 
    fPiedra db "PIEDRA.BMP",0
    fPapel  db "PAPEL.BMP",0
    fTijera db "TIJERA.BMP",0
    tablaImg dw offset fPiedra, offset fPapel, offset fTijera
 
.code
 
extrn imprimir:proc
extrn saltito:proc
extrn r2a:proc
extrn dibujaBmp:proc
 
main proc
    mov ax, @data
    mov ds, ax
 
    ; ---- verificar que mint.com este instalado ----
    mov ax, 3581h
    int 21h                 ; ES:BX = vector actual de INT 81h
    mov ax, es
    or  ax, bx
    jz  noInstalado         ; vector en 0:0 -> no hay nada
    mov ah, 0FFh
    int 81h                 ; pedir firma
    cmp ax, 0A55Ah
    jne noInstalado
    jmp menu
 
noInstalado:
    lea bx, msgNoTsr
    push bx
    call imprimir
    mov ax, 4C00h
    int 21h
 
; ======================= MENU PRINCIPAL =======================
menu:
    call pantallaGrafica    ; limpia la pantalla (modo 13h)
 
    lea bx, cartel
    push bx
    call imprimir
 
    lea bx, msgMenu1
    push bx
    call imprimir
    lea bx, msgMenu2
    push bx
    call imprimir
    lea bx, msgMenu3
    push bx
    call imprimir
    lea bx, msgMenu4
    push bx
    call imprimir
 
    lea bx, msgMenuOp
    push bx
    call imprimir
 
    mov ah, 8               ; leer tecla sin eco
    int 21h
 
    cmp al, "1"
    je  partidaCom
    cmp al, "2"
    je  partidaP2
    cmp al, "3"
    je  estadisticas
    cmp al, "4"
    je  fin
    jmp menu
 
; ======================= P1 vs COM =======================
partidaCom:
    mov contadorUsu, "0"    ; puntajes de la partida en cero
    mov contadorCpu, "0"
 
vuelta:
    call pantallaGrafica
 
    lea bx, msgTituloCom
    push bx
    call imprimir
 
    lea bx, cartel2
    push bx
    call imprimir
 
    lea bx, PuntajeUsu
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    lea bx, PuntajeCpu
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    mov ah, 8               ; leer tecla sin eco
    int 21h
 
    cmp al,"1"
    je piedra
 
    cmp al,"2"
    je papel
 
    cmp al,"3"
    je tijera
 
    jmp vuelta
 
piedra:
    mov eleccion,0
    jmp pc
 
papel:
    mov eleccion,1
    jmp pc
 
tijera:
    mov eleccion,2
 
; ---------------- jugada de la PC y dibujo ----------------
pc:
    mov ah, 0
    int 81h                 ; AL = jugada de la PC (0, 1 o 2)
    mov eleccionPc, al
 
    ; etiquetas sobre las imagenes
    mov dh, 5
    mov dl, 6
    call ubica
    lea bx, lblUsu
    push bx
    call imprimir
 
    mov dh, 5
    mov dl, 28
    call ubica
    lea bx, lblCpu
    push bx
    call imprimir
 
    call dibujaImagenes     ; usuario a la izquierda, PC a la derecha
 
    call textoBlanco        ; la paleta del BMP pisa los colores del texto
    mov dh, 18
    mov dl, 0
    call ubica
 
    mov al, eleccionPc
    cmp al, 0
    je  msgPiedra
    cmp al, 1
    je  msgPapel
    lea bx, mensajeTijera
    jmp muestraPc
msgPiedra:
    lea bx, mensajePiedra
    jmp muestraPc
msgPapel:
    lea bx, mensajePapel
muestraPc:
    push bx
    call imprimir
 
    mov al, eleccion        ; usuario
    mov bl, eleccionPc      ; PC
    mov ah, 1
    int 81h                 ; AL = 0 empate, 1 gana usuario, 2 gana PC
    mov ah, 2
    int 81h                 ; registra la ronda en el historial (AL no cambia)
 
    cmp al, 0
    je  empate
    cmp al, 1
    je  pierdePc
    jmp ganaPc
 
; ---------------- resultados de cada ronda ----------------
empate:
    lea bx, mensajeEmpate
    push bx
    call imprimir
    call esperaTecla
    jmp vuelta
 
pierdePc:
    inc contadorUsu
    cmp contadorUsu, "3"
    je  ganaUsu
    lea bx, mensajePierdePc
    push bx
    call imprimir
 
    lea bx, PuntajeCpu
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    lea bx, PuntajeUsu
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    call esperaTecla
    jmp vuelta
 
ganaPc:
    inc contadorCpu
    cmp contadorCpu,"3"
    je  ganaCpu
    lea bx, mensajeGanaPc
    push bx
    call imprimir
 
    lea bx, PuntajeCpu
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    lea bx, PuntajeUsu
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    call esperaTecla
    jmp vuelta
 
; ---------------- fin de la partida vs COM ----------------
ganaUsu:
    lea bx, mensajePierdePc1
    push bx
    call imprimir
 
    lea bx, PuntajeUsu
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    call esperaTecla
    jmp menu
 
ganaCpu:
    lea bx, mensajeGanaPc1
    push bx
    call imprimir
 
    lea bx, PuntajeCpu
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    call esperaTecla
    jmp menu
 
; ======================= P1 vs P2 =======================
partidaP2:
    mov contadorUsu, "0"    ; contadorUsu = puntos J1, contadorCpu = puntos J2
    mov contadorCpu, "0"
 
rondaP2:
    call pantallaGrafica
 
    lea bx, msgTituloP2
    push bx
    call imprimir
 
    lea bx, PuntajeP1
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    lea bx, PuntajeP2
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    mov dh, 5
    mov dl, 0
    call ubica
    lea bx, msgCtrlP1
    push bx
    call imprimir
    lea bx, msgCtrlP2
    push bx
    call imprimir
 
    mov listo1, 0
    mov listo2, 0
    call vaciaTeclado       ; descarta teclas viejas del buffer
    call muestraEstado
 
; ---------- espera simultanea: cada jugador elige cuando quiere ----------
esperaP2:
    mov ah, 1
    int 16h                 ; hay tecla? (ZF=1 -> no hay)
    jz  esperaP2
    mov ah, 0
    int 16h                 ; AL = tecla (se saca del buffer)
 
    cmp al, 1Bh             ; ESC -> volver al menu
    jne noEsc
    jmp menu
noEsc:
    cmp al, "1"
    je  p1k0
    cmp al, "2"
    je  p1k1
    cmp al, "3"
    je  p1k2
    cmp al, "j"
    je  p2k0
    cmp al, "J"
    je  p2k0
    cmp al, "k"
    je  p2k1
    cmp al, "K"
    je  p2k1
    cmp al, "l"
    je  p2k2
    cmp al, "L"
    je  p2k2
    jmp chequeaListos       ; tecla que no sirve: se ignora
 
p1k0:
    mov bl, 0
    jmp setP1
p1k1:
    mov bl, 1
    jmp setP1
p1k2:
    mov bl, 2
setP1:
    cmp listo1, 0
    jne chequeaListos       ; P1 ya eligio: no puede cambiar
    mov eleccion, bl
    mov listo1, 1
    call muestraEstado
    jmp chequeaListos
 
p2k0:
    mov bl, 0
    jmp setP2
p2k1:
    mov bl, 1
    jmp setP2
p2k2:
    mov bl, 2
setP2:
    cmp listo2, 0
    jne chequeaListos       ; P2 ya eligio: no puede cambiar
    mov eleccionPc, bl      ; (eleccionPc guarda la jugada de J2)
    mov listo2, 1
    call muestraEstado
 
chequeaListos:
    cmp listo1, 1
    jne esperaP2
    cmp listo2, 1
    jne esperaP2
 
    ; ---------- mostrar jugadas ----------
    call pantallaGrafica
 
    mov dh, 5
    mov dl, 3
    call ubica
    lea bx, lblJ1
    push bx
    call imprimir
 
    mov dh, 5
    mov dl, 28
    call ubica
    lea bx, lblJ2
    push bx
    call imprimir
 
    call dibujaImagenes
 
    call textoBlanco
    mov dh, 18
    mov dl, 0
    call ubica
 
    mov al, eleccion        ; jugador 1
    mov bl, eleccionPc      ; jugador 2
    mov ah, 1
    int 81h                 ; AL = 0 empate, 1 gana J1, 2 gana J2
 
    cmp al, 0
    je  empateP2
    cmp al, 1
    je  ganaRondaJ1
    jmp ganaRondaJ2
 
empateP2:
    inc p2Emp
    lea bx, msgEmpateP2
    push bx
    call imprimir
    call esperaTecla
    jmp rondaP2
 
ganaRondaJ1:
    inc p2Gan1
    inc contadorUsu
    cmp contadorUsu, "3"
    je  ganaPartidaJ1
    lea bx, msgRondaJ1
    push bx
    call imprimir
 
    lea bx, PuntajeP1
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    lea bx, PuntajeP2
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    call esperaTecla
    jmp rondaP2
 
ganaRondaJ2:
    inc p2Gan2
    inc contadorCpu
    cmp contadorCpu, "3"
    je  ganaPartidaJ2
    lea bx, msgRondaJ2
    push bx
    call imprimir
 
    lea bx, PuntajeP1
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    lea bx, PuntajeP2
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    call esperaTecla
    jmp rondaP2
 
ganaPartidaJ1:
    lea bx, msgPartidaJ1
    push bx
    call imprimir
 
    lea bx, PuntajeP1
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir
 
    call esperaTecla
    jmp menu
 
ganaPartidaJ2:
    lea bx, msgPartidaJ2
    push bx
    call imprimir
 
    lea bx, PuntajeP2
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir
 
    call esperaTecla
    jmp menu
 
; ======================= STATS =======================
estadisticas:
    mov ah, 3
    int 81h                 ; AX = ganadas usuario, BX = ganadas PC, CX = empates
    mov statU, al
    mov statP, bl
    mov statE, cl
 
    ; r2a SUMA sobre el texto, asi que hay que dejarlo en "000" cada vez
    lea bx, nroUsu
    call reset3
    lea bx, nroPc
    call reset3
    lea bx, nroEmp
    call reset3
    lea bx, nroJ1
    call reset3
    lea bx, nroJ2
    call reset3
    lea bx, nroEmp2
    call reset3
 
    mov dl, statU
    lea bx, nroUsu
    call r2a
 
    mov dl, statP
    lea bx, nroPc
    call r2a
 
    mov dl, statE
    lea bx, nroEmp
    call r2a
 
    mov dl, p2Gan1
    lea bx, nroJ1
    call r2a
 
    mov dl, p2Gan2
    lea bx, nroJ2
    call r2a
 
    mov dl, p2Emp
    lea bx, nroEmp2
    call r2a
 
    call pantallaGrafica    ; pantalla limpia para las estadisticas
 
    lea bx, msgStats
    push bx
    call imprimir
 
    lea bx, msgStTitCom
    push bx
    call imprimir
 
    lea bx, msgStUsu
    push bx
    call imprimir
    lea bx, nroUsu
    push bx
    call imprimir
 
    lea bx, msgStPc
    push bx
    call imprimir
    lea bx, nroPc
    push bx
    call imprimir
 
    lea bx, msgStEmp
    push bx
    call imprimir
    lea bx, nroEmp
    push bx
    call imprimir
 
    lea bx, msgStTitP2
    push bx
    call imprimir
 
    lea bx, msgStJ1
    push bx
    call imprimir
    lea bx, nroJ1
    push bx
    call imprimir
 
    lea bx, msgStJ2
    push bx
    call imprimir
    lea bx, nroJ2
    push bx
    call imprimir
 
    lea bx, msgStEmp
    push bx
    call imprimir
    lea bx, nroEmp2
    push bx
    call imprimir
 
    call esperaTecla
    jmp menu
 
; ======================= EXIT =======================
fin:
    call pantallaTexto
    mov ax, 4C00h
    int 21h
main endp
 
;=======================================================================
; Rutinas auxiliares (locales a este archivo)
;=======================================================================
 
; Pone modo grafico 13h (320x200, 256 colores). Tambien limpia la pantalla
; y restaura la paleta por defecto.
pantallaGrafica proc
    push ax
    mov ax, 0013h
    int 10h
    pop ax
    ret
pantallaGrafica endp
 
; Vuelve al modo texto 80x25
pantallaTexto proc
    push ax
    mov ax, 0003h
    int 10h
    pop ax
    ret
pantallaTexto endp
 
; Posiciona el cursor: DH = fila, DL = columna (en modo 13h: 25 filas x 40 columnas)
ubica proc
    push ax
    push bx
    xor bh, bh
    mov ah, 2
    int 10h
    pop bx
    pop ax
    ret
ubica endp
 
; Fuerza los indices de color 7 y 15 a blanco, para que el texto se vea
; despues de cargar la paleta de un BMP
textoBlanco proc
    push ax
    push dx
 
    mov dx, 3C8h
    mov al, 7
    out dx, al
    inc dx
    mov al, 63
    out dx, al
    out dx, al
    out dx, al
 
    mov dx, 3C8h
    mov al, 15
    out dx, al
    inc dx
    mov al, 63
    out dx, al
    out dx, al
    out dx, al
 
    pop dx
    pop ax
    ret
textoBlanco endp
 
; Dibuja la imagen de "eleccion" a la izquierda y la de "eleccionPc" a la derecha
dibujaImagenes proc
    push ax
    push bx
 
    mov bl, eleccion
    xor bh, bh
    shl bx, 1
    push tablaImg[bx]
    mov ax, 20
    push ax
    mov ax, 48
    push ax
    call dibujaBmp
 
    mov bl, eleccionPc
    xor bh, bh
    shl bx, 1
    push tablaImg[bx]
    mov ax, 220
    push ax
    mov ax, 48
    push ax
    call dibujaBmp
 
    pop bx
    pop ax
    ret
dibujaImagenes endp
 
;  Descarta todas las teclas pendientes del buffer del teclado
vaciaTeclado proc
    push ax
vaciaLoop:
    mov ah, 1
    int 16h
    jz  vaciaFin
    mov ah, 0
    int 16h
    jmp vaciaLoop
vaciaFin:
    pop ax
    ret
vaciaTeclado endp
 
; Dibuja el estado de cada jugador (esperando / LISTO) segun listo1 y listo2.
; Solo muestra si ya eligieron, nunca que eligieron.
muestraEstado proc
    push ax
    push bx
    push dx
 
    mov dh, 10
    mov dl, 0
    call ubica
    cmp listo1, 0
    jne estL1
    lea bx, msgEspP1
    jmp estP1
estL1:
    lea bx, msgListoP1
estP1:
    push bx
    call imprimir
 
    mov dh, 12
    mov dl, 0
    call ubica
    cmp listo2, 0
    jne estL2
    lea bx, msgEspP2
    jmp estP2
estL2:
    lea bx, msgListoP2
estP2:
    push bx
    call imprimir
 
    pop dx
    pop bx
    pop ax
    ret
muestraEstado endp
 
; Deja en "000" el texto de 3 bytes apuntado por BX
reset3 proc
    mov byte ptr [bx], "0"
    mov byte ptr [bx+1], "0"
    mov byte ptr [bx+2], "0"
    ret
reset3 endp
 
; Muestra "Presione una tecla..." y espera una tecla (sin eco)
esperaTecla proc
    push ax
    push bx
    lea bx, msgContinuar
    push bx
    call imprimir
    mov ah, 8
    int 21h
    pop bx
    pop ax
    ret
esperaTecla endp
 
end main
 