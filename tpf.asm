.8086
jumps
.model small
.stack 100h

.data
    ;mensajes generales
    mensajePiedra db "PC eligio: Piedra", 0dh,0ah,24h
    mensajePapel  db "PC eligio: Papel", 0dh,0ah,24h
    mensajeTijera db "PC eligio: Tijera", 0dh,0ah,24h
    cartel db "Piedra, Papel o Tijera!", 0dh,0ah,24h
    cartel2 db "1 = Piedra | 2 = Papel | 3 = Tijera", 0dh,0ah,24h
    mensajeEmpate db "Usted ha empatado", 0dh,0ah,24h
    mensajePierdePc1 db "Usted ha ganado! Llego a 3 puntos",0dh,0ah,24h
    mensajeGanaPc1 db "Usted ha perdido! La CPU llego a 3 puntos",0dh,0ah,24h
    mensajePierdePc db "Usted ha ganado! Suma 1 punto",0dh,0ah,24h
    mensajeGanaPc db "Usted ha perdido! Suma un 1 punto la CPU",0dh,0ah,24h
    eleccion db 0
    eleccionPc db 0
    contadorCpu db "0", 0dh,0ah,24h
    contadorUsu db "0", 0dh,0ah,24h
    PuntajeUsu db "Su puntaje es: ",24h
    PuntajeCpu db "Puntaje de CPU: ",24h
    msgNoTsr db "Primero ejecute la interrupcion",0dh,0ah,24h
    msgContinuar db "Presione una tecla...",24h
    tituloUsu db "USTED",24h
    tituloCPU db "CPU",24h
    comando_ansi db 1Bh, '[2J$'


    ; mensajes menu principal
    msgMenu1 db 0dh,0ah,"   1. P1 vs COM",0dh,0ah,24h
    msgMenu2 db "   2. P1 vs P2",0dh,0ah,24h
    msgMenu3 db "   3. Stats",0dh,0ah,24h
    msgMenu4 db "   4. Exit",0dh,0ah,0dh,0ah,24h
    msgMenuOp db "Elija una opcion: ",24h

    ; modalidad P1 vs COM
    msgTituloVSCPU db "== Jugador 1 vs COM ==",0dh,0ah,24h

    ; modadalidad P1 vs P2
    msgTituloP2 db "== Jugador 1 vs Jugador 2 ==",0dh,0ah,24h
    msgCtrlP1 db "P1: 1 = Piedra 2 = Papel 3 = Tijera",0dh,0ah,24h
    msgCtrlP2 db "P2: J = Piedra K = Papel L = Tijera",0dh,0ah,24h
    
    ;miden lo mismo para que uno tape al otro al imprimir y no tener que limpiar
    msgEspP1   db "P1: esperando eleccion...",24h
    msgListoP1 db "P1: LISTO!               ",24h
    msgEspP2   db "P2: esperando eleccion...",24h
    msgListoP2 db "P2: LISTO!               ",24h

    listo1 db 0
    listo2 db 0
    tituloJ1 db "JUGADOR 1",24h
    tituloJ2 db "JUGADOR 2",24h
    PuntajeP1 db "Puntaje Jugador 1: ",24h
    PuntajeP2 db "Puntaje Jugador 2: ",24h
    msgEmpateP2 db "Empate en la ronda",0dh,0ah,24h
    msgRondaJ1 db "Jugador 1 gana la ronda",0dh,0ah,24h
    msgRondaJ2 db "Jugador 2 gana la ronda",0dh,0ah,24h
    msgPartidaJ1 db "JUGADOR 1 GANA LA PARTIDA!",0dh,0ah,24h
    msgPartidaJ2 db "JUGADOR 2 GANA LA PARTIDA!",0dh,0ah,24h
                                                        

    ; 
    msgStats db "-- Historial acumulado --",0dh,0ah,24h
    msgTituloCom db 0dh,0ah,"[P1 vs COM]",0dh,0ah,24h
    msgTituloJ2  db 0dh,0ah,"[P1 vs P2]",0dh,0ah,24h
    msgGanadasUsu db "Ganadas por usted: ",24h
    msgGanadasPC  db "Ganadas por la CPU: ",24h
    msgGanadasJ1  db "Ganadas por Jugador 1: ",24h
    msgGanadasJ2  db "Ganadas por Jugador 2: ",24h
    msgTotalEmpates db "Empates: ",24h
    nroUsu db "000",0dh,0ah,24h
    nroPc  db "000",0dh,0ah,24h
    nroEmp db "000",0dh,0ah,24h
    nroJ1  db "000",0dh,0ah,24h
    nroJ2  db "000",0dh,0ah,24h
    nroEmp2 db "000",0dh,0ah,24h
    statsUsu db 0
    statsPC db 0
    statsEmpate db 0

    ; contadores locales de rondas P1 vs P2
    p2Gan1 db 0
    p2Gan2 db 0
    p2Emp  db 0

    ; IMAGENES ASCII cada una 6 lineas de 19 caracteres
    ; orden 0=Piedra 1=Papel 2=Tijera
    arteIzq0    db "    _______       ",24h
                db "---'   ____)      ",24h
                db "      (_____)     ",24h
                db "      (_____)     ",24h
                db "      (____)      ",24h 
                db "---.__(___)       ",24h

    arteIzq1    db "     _______      ",24h
                db "---'    ____)____ ",24h
                db "           ______)",24h
                db "          _______)",24h
                db "         _______) ",24h
                db "---.__________)   ",24h

    arteIzq2    db "    _______       ",24h
                db "---'   ____)____  ",24h
                db "          ______) ",24h
                db "       __________)",24h
                db "      (____)      ",24h
                db "---.__(___)       ",24h

    arteDer0    db "       _______    ",24h
                db "      (____   '---",24h
                db "     (_____)      ",24h
                db "     (_____)      ",24h
                db "      (____)      ",24h
                db "       (___)__.---",24h

    arteDer1    db "      _______     ",24h
                db " ____(____   '----",24h
                db "(______           ",24h
                db "(_______          ",24h
                db " (_______         ",24h
                db "    (_________.---",24h

    arteDer2    db "       _______    ",24h
                db "  ____(____   '---",24h
                db " (______          ",24h
                db "(__________       ",24h
                db "      (____)      ",24h
                db "       (___)__.---",24h


    ;tabla de dibujos: AL SER UN DW CADA OFFSET DE LAS MANOS OCUPA 2BYTES (16 BITS)

    tablaIzq dw offset arteIzq0, offset arteIzq1, offset arteIzq2
    tablaDer dw offset arteDer0, offset arteDer1, offset arteDer2
    selectIzq dw 0
    selectDer dw 0
    filaDib db 0
    msgVs db "VS",24h
 


.code

extrn imprimir:NEAR
extrn saltito:NEAR
extrn r2a:NEAR
extrn limpiaPantalla:NEAR
extrn ubica:NEAR
extrn reset3:NEAR


main proc
    mov ax, @data
    mov ds, ax

    ; verifica si la interrupcion propia está instalada
    mov ax, 3581h
    int 21h                 ; ES:BX = vector actual de INT 81h
    mov ax, es
    or  ax, bx
    jz  noInstalado         ; vector en 0:0 es q no hay nada
    mov ah, 0FFh
    int 81h                 ; pedir firma
    cmp ax, 0A55Ah
    jne noInstalado
    jmp menu

noInstalado:
    lea bx, msgNoTsr ;INTERRUPCION NO INSTALADA
    push bx
    call imprimir
    mov ax, 4C00h
    int 21h

; MENSAJES DEL MENU PRINCIPAL
menu:
    lea dx, comando_ansi
    call limpiaPantalla    

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

    mov ah, 8               ; leer tecla del menu
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

; P1 VS COM
partidaCom:
    mov contadorUsu, "0"    ; comienza el contador en cero
    mov contadorCpu, "0"

vuelta:
    lea dx, comando_ansi
    call limpiaPantalla

    lea bx, msgTituloVSCPU
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

    mov ah, 8               ; leer tecla
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

; ELECCIÓN DE LA PC Y SU DIBUJO
pc:
    mov ah, 0
    int 81h                 ; AL = jugada de la PC (0, 1 o 2)
    mov eleccionPc, al      ; movemos lo que trajimos de AL a la eleccion PC

    ; etiquetas sobre las imagenes
    mov dh, 5
    mov dl, 17
    call ubica
    lea bx, tituloUsu ;TITULO DE USUARIO
    push bx
    call imprimir

    mov dh, 5
    mov dl, 57
    call ubica
    lea bx, tituloCPU ;TITULO DE LA CPU
    push bx
    call imprimir

    call dibujaImagenes     ; usuario a la izquierda, PC a la derecha

    mov dh, 14
    mov dl, 0
    call ubica

    mov al, eleccionPc ;depende la eleccion imprime
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
    int 81h                 ; registra la ronda en el historial en la interrupcion

    cmp al, 0
    je  empate
    cmp al, 1
    je  pierdePc
    jmp ganaPc

; MENSAJES DE RESULTADOS DESPUES DE CADA RONDA
empate:
    lea bx, mensajeEmpate
    push bx
    call imprimir
    call esperaTecla
    jmp vuelta

pierdePc:
    inc contadorUsu
    cmp contadorUsu, "3" ;VERIFICA SI EL USUARIO LLEGÓ A 3 RONDAS GANADAS
    je  ganaUsu
    lea bx, mensajePierdePc ;pierde la ronda la pc
    push bx
    call imprimir

    lea bx, PuntajeCpu ;puntajes actuales
    push bx
    call imprimir
    lea bx, contadorCpu;puntajes actuales
    push bx
    call imprimir

    lea bx, PuntajeUsu;puntajes actuales
    push bx
    call imprimir
    lea bx, contadorUsu;puntajes actuales
    push bx
    call imprimir

    call esperaTecla
    jmp vuelta

ganaPc:
    inc contadorCpu
    cmp contadorCpu,"3" ;CONFIRMA SI LA PC LLEGÓ A 3 PUNTOS
    je  ganaCpu
    lea bx, mensajeGanaPc ;GANA LA RONDA
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
    jmp vuelta ;JUEGA OTRA RONDA

; final de la partida J1 VS COM
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

; JUGADOR 1 VS JUGADOR 2
partidaP2:
    mov contadorUsu, "0"    ; contadorUsu = puntos J1, contadorCpu = puntos J2
    mov contadorCpu, "0"

rondaP2:
    lea dx, comando_ansi
    call limpiaPantalla

    lea bx, msgTituloP2     ;ARMA TODO EL SET DE JUGADOR 1 VS JUGADOR 2
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
    lea bx, contadorCpu ;USA CONTADORCPU PARA CONTAR LAS DEL JUGADOR 2
    push bx
    call imprimir

    mov dh, 5
    mov dl, 0
    call ubica
    lea bx, msgCtrlP1 ;controles del JUGADOR 1
    push bx
    call imprimir
    lea bx, msgCtrlP2 ;controles del JUGADOR 2
    push bx
    call imprimir

    mov listo1, 0 ;cada que empieza la ronda setea los parametros de listo de ambos jugadores en 0
    mov listo2, 0
    call muestraEstado ; imprime listo o esperando

; ESPERA LA TECLA DE AMBOS JUGADORES, CADA UNO CUANDO QUIERE
espera_teclas:
    mov ah, 8
    int 21h                 ; ESPERA UNA TECLA

    cmp al, 1Bh             ; ESC es para volver al menu
    jne noEsc
    jmp menu
noEsc:
    cmp al, "1"
    je  jugador1caso1
    cmp al, "2"
    je  jugador1caso2        ;CONTROLES DEL JUGADOR 1
    cmp al, "3"
    je  jugador1caso3

    cmp al, "j"
    je  jugador2caso1
    cmp al, "J"
    je  jugador2caso1        ;CONTROLES DEL JUGADOR 2

    cmp al, "k"
    je  jugador2caso2
    cmp al, "K"
    je  jugador2caso2

    cmp al, "l"
    je  jugador2caso3
    cmp al, "L"
    je  jugador2caso3

    jmp chequeaListos       ; tecla que no sirve no pasa

jugador1caso1: ;CASO PIEDRA
    mov bl, 0
    jmp setP1
jugador1caso2: ;CASO PAPEL
    mov bl, 1
    jmp setP1
jugador1caso3: ;CASO TIJERA
    mov bl, 2
setP1:
    cmp listo1, 0
    jne chequeaListos       ; P1 ya eligio no puede cambiar
    mov eleccion, bl
    mov listo1, 1
    call muestraEstado ;IMPRIME ESPERANDO O LISTO
    jmp chequeaListos

jugador2caso1: ;CASO PIEDRA
    mov bl, 0
    jmp setP2 ;
jugador2caso2: ;CASO PAPEL
    mov bl, 1
    jmp setP2
jugador2caso3: ;CASO TIJERA
    mov bl, 2
setP2:
    cmp listo2, 0
    jne chequeaListos       ; P2 ya eligio no puede cambiar
    mov eleccionPc, bl      ; se usa eleccionpc para el jugador 2
    mov listo2, 1
    call muestraEstado

chequeaListos:
    cmp listo1, 1
    jne espera_teclas   ;SI AMBOS LISTOS ESTÁN EN 1, SIGUE A IMPRIMIR
    cmp listo2, 1
    jne espera_teclas

    ; DIBUJA LAS JUGADAS
    lea dx, comando_ansi
    call limpiaPantalla

    mov dh, 5
    mov dl, 16
    call ubica
    lea bx, tituloJ1 ;etiqueta de jugador 1
    push bx
    call imprimir

    mov dh, 5
    mov dl, 54
    call ubica
    lea bx, tituloJ2 ;etiqueta de jugador 2
    push bx
    call imprimir

    call dibujaImagenes ;IMPRIME EL ASCII DE AMBAS JUGADAS

    mov dh, 14
    mov dl, 0
    call ubica

    mov al, eleccion        ; jugador 1
    mov bl, eleccionPc      ; jugador 2
    mov ah, 1
    int 81h                 ; AL = 0 empate, 1 gana J1, 2 gana J2

    cmp al, 0 ;EMPATE
    je  empateP2
    cmp al, 1 ;GANA JUGADOR 1
    je  ganaRondaJ1
    jmp ganaRondaJ2 ;GANA JUGADOR 2

empateP2:
    inc p2Emp ;CONTADOR LOCAL DE EMPATES
    lea bx, msgEmpateP2 ;MENSAJE DE EMPATES
    push bx
    call imprimir 
    call esperaTecla
    jmp rondaP2

ganaRondaJ1:
    inc p2Gan1 ;CONTADOR LOCAL DE JUGADOR 1
    inc contadorUsu
    cmp contadorUsu, "3" ;COMPARA QUE NO HAYA GANADO LAS 3 RONDAS
    je  ganaPartidaJ1 ;SI GANÓ 3 RONDAS, GANA LA PARTIDA
    lea bx, msgRondaJ1
    push bx
    call imprimir

    lea bx, PuntajeP1   ;puntajes actuales
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir

    lea bx, PuntajeP2   ;puntajes actuales
    push bx
    call imprimir
    lea bx, contadorCpu
    push bx
    call imprimir

    call esperaTecla
    jmp rondaP2

ganaRondaJ2:
    inc p2Gan2 ;CONTADOR LOCAL JUGADORES 2
    inc contadorCpu
    cmp contadorCpu, "3" ;compara que no haya ganado la partida, al ganar 3 rondas
    je  ganaPartidaJ2
    lea bx, msgRondaJ2
    push bx
    call imprimir

    lea bx, PuntajeP1   ;puntajes actuales
    push bx
    call imprimir
    lea bx, contadorUsu
    push bx
    call imprimir

    lea bx, PuntajeP2 ;puntajes actuales
    push bx
    call imprimir
    lea bx, contadorCpu ;CONTADOR CPU SE USA PARA EL J2
    push bx
    call imprimir

    call esperaTecla
    jmp rondaP2

ganaPartidaJ1:
    lea bx, msgPartidaJ1 ;gano partida, y vuelve al menu
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
    lea bx, msgPartidaJ2    ;gano partida, y vuelve al menu
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


estadisticas:
    mov ah, 3
    int 81h                 ; AX = ganadas usuario, BX = ganadas PC, CX = empates
    mov statsUsu, al        ; LLENA LAS VARIABLES LOCALES CON LAS ESTADISTICAS QUE DA LA INTERRUPCION
    mov statsPC, bl
    mov statsEmpate, cl

    ; r2a suma sobre el texto, asi que hay que dejar todas las variables en 000 cada vez
    lea bx, nroUsu  ;LIMPIA
    call reset3 

    lea bx, nroPc ;LIMPIA  
    call reset3

    lea bx, nroEmp;LIMPIA
    call reset3

    lea bx, nroJ1;LIMPIA
    call reset3

    lea bx, nroJ2;LIMPIA
    call reset3

    lea bx, nroEmp2;LIMPIA
    call reset3

    mov dl, statsUsu ;PASA EL CONTADOR DE STATS A REG, PARA IMPRIMIR
    lea bx, nroUsu
    call r2a

    mov dl, statsPC;PASA EL CONTADOR DE STATS A REG, PARA IMPRIMIR
    lea bx, nroPc
    call r2a

    mov dl, statsEmpate;PASA EL CONTADOR DE STATS A REG, PARA IMPRIMIR
    lea bx, nroEmp
    call r2a

    mov dl, p2Gan1;PASA EL CONTADOR DE STATS A REG, PARA IMPRIMIR
    lea bx, nroJ1
    call r2a

    mov dl, p2Gan2;PASA EL CONTADOR DE STATS A REG, PARA IMPRIMIR
    lea bx, nroJ2
    call r2a

    mov dl, p2Emp;PASA EL CONTADOR DE STATS A REG, PARA IMPRIMIR
    lea bx, nroEmp2
    call r2a

    lea dx, comando_ansi
    call limpiaPantalla    

    ;COMIENZA A IMPRIMIR CADA MENSAJITO

    lea bx, msgStats
    push bx
    call imprimir

    lea bx, msgTituloCom
    push bx
    call imprimir

    lea bx, msgGanadasUsu
    push bx
    call imprimir
    lea bx, nroUsu
    push bx
    call imprimir

    lea bx, msgGanadasPC
    push bx
    call imprimir
    lea bx, nroPc
    push bx
    call imprimir

    lea bx,msgTotalEmpates
    push bx
    call imprimir
    lea bx, nroEmp
    push bx
    call imprimir

    lea bx, msgTituloJ2
    push bx
    call imprimir

    lea bx, msgGanadasJ1
    push bx
    call imprimir
    lea bx, nroJ1
    push bx
    call imprimir

    lea bx, msgGanadasJ2
    push bx
    call imprimir
    lea bx, nroJ2
    push bx
    call imprimir

    lea bx,msgTotalEmpates
    push bx
    call imprimir
    lea bx, nroEmp2
    push bx
    call imprimir

    call esperaTecla
    jmp menu

fin:
    lea dx, comando_ansi
    call limpiaPantalla
    mov ax, 4C00h
    int 21h
main endp


; Dibuja el estado de cada jugador ESPERANDO O LISTO egun listo1 y listo2

muestraEstado proc
    push ax
    push bx
    push dx

    mov dh, 10
    mov dl, 0
    call ubica
    cmp listo1, 0
    jne estL1 ;si el estado del jugador1 es 1, imprime el mensaje de listo, si es 0 sigue esperando
    lea bx, msgEspP1 
    jmp estP1
estL1: 
    lea bx, msgListoP1 ;IMPRIME JUGADOR 1 LISTO
estP1:
    push bx 
    call imprimir  ;SI NO ENTRA EN ESTL1 IMPRIME ESPERANDO

    mov dh, 12
    mov dl, 0
    call ubica
    cmp listo2, 0 ;COMPARA LO MISMO PARA EL JUGADOR 2
    jne estL2
    lea bx, msgEspP2
    jmp estP2
estL2:
    lea bx, msgListoP2
estP2:
    push bx
    call imprimir ;IMPRIME EL JUGADOR 2 LISTO

    pop dx
    pop bx
    pop ax
    ret
muestraEstado endp


; Muestra "Presione una tecla..." y espera una tecla
esperaTecla proc
    push ax
    push bx
    lea bx, msgContinuar ;MENSAJE PRESIONE UNA TECLA
    push bx
    call imprimir
    mov ah, 8
    int 21h         ;ESPERA UNA TECLA
    pop bx
    pop ax
    ret
esperaTecla endp


; Dibuja el ASCII "eleccion" a la izquierda y "eleccionPc" a la derecha
dibujaImagenes proc
    push ax
    push bx
    push dx
    

    xor bx, bx
    xor cx, cx ;LIMPIO LAS VARIABLES QUE USO 
    xor ax, ax

    mov al, eleccion ;MUEVO A AL LA ELECCIÓN DEL USUARIO
    mov cx, 2 ;REGISTRO AUXILIAR PARA MULTIPLICAR
    mul cx ; MULTIPLICO LA ELECCIÓN POR 2, PARA MOVERME ESOS ESPACIOS EN MEMORIA DE LA TABLAIZQ

    mov bx, ax ;MUEVO A BX LO QUE RECIÉN MULTIPLIQUÉ EN AX PARA USARLO COMO SUBINDICE
    mov ax, tablaIzq[bx]  ;TABLA CON TODOS LOS DIBUJOS PERO APUNTANDO AL QUE SELECCIONÉ  
    mov selectIzq, ax  ;PASA EL DIBUJO SELECCIONADO A UNA VARIABLE APARTE PARA TENER SOLO ESE


    xor bx, bx              ;HACE LO MISMO PARA LA ELECCION PC
    xor cx, cx
    xor ax, ax

    mov al, eleccionPc
    mov cx, 2
    mul cx

    mov bx, ax
    mov ax, tablaDer[bx]
    mov selectDer, ax 

    mov filaDib, 7 ;Comienza a dibujar en la fila 7, y va incremetando hasta la 13
dibLoop:
    mov dh, filaDib
    mov dl, 12 ;
    call ubica
    push selectIzq ;Pasa a la pila para utilizar imprimir 
    call imprimir

    mov dh, filaDib
    mov dl, 50
    call ubica
    push selectDer ;Pasa a la pila para imprimir
    call imprimir

    add selectIzq, 19 ;Pasa a la siguiente linea del dibujo seleccionado sumando 19 caracteres
    add selectDer, 19
    inc filaDib
    cmp filaDib, 13
    jb  dibLoop

    mov dh, 9               ; VS en el medio
    mov dl, 38
    call ubica
    lea bx, msgVs
    push bx
    call imprimir

    pop dx
    pop bx
    pop ax
    ret
dibujaImagenes endp
end
