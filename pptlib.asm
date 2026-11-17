.8086
.model small
.stack 100h

JUMPS
.data
    bmpHdr   db 54 dup(0)
    bmpPal   db 1024 dup(0)
    bmpRow   db 324 dup(0)
    bmpHnd   dw 0
    bmpAncho dw 0
    bmpAlto  dw 0
    bmpX     dw 0
    bmpY     dw 0
    bmpFila  dw 0
    bmpBytes dw 0
.code
        
        public cuentaCaracteres
        public r2a
        public cambio
        public soloLetras
        public carga
        public incremento
        public limpiaVar
        public limpiaAscii
        public cuentaIndividual
        public cuentoLetras
        public imprimir
        public num2bin
        public random
        public comparoPiedra
        public comparoPapel
        public comparoTijera
        public saltito
        public modoGrafico
        public modoTexto
        public posiciona
        public dibujaBmp

modoGrafico proc
    push ax
    mov ax, 0013h           ; 320x200, 256 colores
    int 10h
    pop ax
    ret
modoGrafico endp

modoTexto proc
    push ax
    mov ax, 0003h
    int 10h
    pop ax
    ret
modoTexto endp

; DH = fila, DL = columna (en modo 13h son 25 filas x 40 columnas)
posiciona proc
    push ax
    push bx
    xor bh, bh
    mov ah, 2
    int 10h
    pop bx
    pop ax
    ret
posiciona endp

; push offset nombre (ASCIIZ) ; push x ; push y ; call dibujaBmp
; BMP de 8 bits sin comprimir, ancho <= 320
dibujaBmp proc
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    mov ax, ss:[bp+6]
    mov bmpX, ax
    mov ax, ss:[bp+4]
    mov bmpY, ax

    mov dx, ss:[bp+8]       ; abrir
    mov ax, 3D00h
    int 21h
    jc  bmpFin
    mov bmpHnd, ax

    mov bx, bmpHnd          ; cabecera (54 bytes)
    mov cx, 54
    lea dx, bmpHdr
    mov ah, 3Fh
    int 21h
    jc  bmpCierra
    mov ax, word ptr bmpHdr[18]
    mov bmpAncho, ax
    mov ax, word ptr bmpHdr[22]
    mov bmpAlto, ax

    mov bx, bmpHnd          ; paleta (1024 bytes, formato B,G,R,0)
    mov cx, 1024
    lea dx, bmpPal
    mov ah, 3Fh
    int 21h
    jc  bmpCierra

    mov dx, 3C8h            ; cargar paleta en el VGA (6 bits por componente)
    xor al, al
    out dx, al
    inc dx
    lea si, bmpPal
    mov cx, 256
bmpPaleta:
    mov al, [si+2]          ; R
    shr al, 1
    shr al, 1
    out dx, al
    mov al, [si+1]          ; G
    shr al, 1
    shr al, 1
    out dx, al
    mov al, [si]            ; B
    shr al, 1
    shr al, 1
    out dx, al
    add si, 4
    loop bmpPaleta

    mov bx, bmpHnd          ; ir al inicio de los pixeles
    mov dx, word ptr bmpHdr[10]
    xor cx, cx
    mov ax, 4200h
    int 21h

    mov ax, bmpAncho        ; cada fila se rellena a multiplo de 4
    add ax, 3
    and ax, 0FFFCh
    mov bmpBytes, ax
    mov ax, bmpAlto
    mov bmpFila, ax

bmpLoop:
    cmp bmpFila, 0
    je  bmpCierra
    mov bx, bmpHnd
    mov cx, bmpBytes
    lea dx, bmpRow
    mov ah, 3Fh
    int 21h
    jc  bmpCierra

    mov ax, bmpY            ; el BMP viene de abajo hacia arriba
    add ax, bmpFila
    dec ax
    mov cx, 320
    mul cx
    add ax, bmpX
    mov di, ax
    mov ax, 0A000h
    mov es, ax
    lea si, bmpRow
    mov cx, bmpAncho
    cld
    rep movsb
    dec bmpFila
    jmp bmpLoop

bmpCierra:
    mov bx, bmpHnd
    mov ah, 3Eh
    int 21h
bmpFin:
    pop es
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
dibujaBmp endp



saltito proc
    push ax             
    push dx

    mov ah, 02h        
    mov dl, 13         
    int 21h

    mov dl, 10          
    int 21h

    pop dx            
    pop ax
    ret                 
saltito endp

comparoPiedra proc
        push bp
        mov bp,sp
        push bx
        mov bx, ss:[bp+4]; entra la eleccion del usuario

        cmp byte ptr[bx], al
        je empate               
                                                                ;0 piedra, 1 papel, 2 tijera
        cmp byte ptr[bx], 1
        je pierdePc

        cmp byte ptr[bx],2
        je ganaPc
        empate:
        xor al,al
        mov al,0
        jmp finPiedra

        pierdePc:
        xor al,al
        mov al,1
        jmp finPiedra

        ganaPc:

        xor al,al
        mov al,2

finPiedra:

        pop bx
        pop bp
        ret 2
comparoPiedra endp

comparoPapel proc
        push bp
        mov bp,sp
        push bx
        mov bx, ss:[bp+4]; entra la eleccion del usuario

        cmp byte ptr[bx], al    ;0 piedra, 1 papel, 2 tijera
        je empatep              

        cmp byte ptr[bx], 2
        je pierdePcp

        cmp byte ptr[bx],0
        je ganaPcp

        empatep:
        xor al,al
        mov al,0
        jmp finPapel

        pierdePcp:
        xor al,al
        mov al,1
        jmp finPapel

        ganaPcp:

        xor al,al
        mov al,2

finPapel:

        pop bx
        pop bp
        ret 2

comparoPapel endp

comparoTijera proc
        push bp
        mov bp,sp
        push bx
        mov bx, ss:[bp+4]; entra la eleccion del usuario

        cmp byte ptr[bx], al    ;0 piedra, 1 papel, 2 tijera
        je empatet              

        cmp byte ptr[bx], 0
        je pierdePct

        cmp byte ptr[bx],1
        je ganaPct

        empatet:
        xor al,al
        mov al,0
        jmp finTijera

        pierdePct:
        xor al,al
        mov al,1
        jmp finTijera

        ganaPct:

        xor al,al
        mov al,2

finTijera:

        pop bx
        pop bp
        ret 2

comparoTijera endp


random proc
    push cx
    push dx

    mov ah, 2Ch
    int 21h             ; interrupcion que genera numeros random a partir de tiempo

    xor ax, ax
    mov al, dl
    mov cl, 3
    div cl              ; AL = cociente, AH = resto (0, 1 o 2)

    mov al, ah          ; Pasamos el resto a AL
    xor ah, ah

    pop dx
    pop cx
    ret
random endp

cuentoLetras proc
;SOLO CUENTA LETRAS
        push bp
        mov bp,sp
        push bx
        push si
        mov bx, ss:[bp+6]; offset de texto
        mov si, ss:[bp+4]; aca cuento cada vez que sea una letra
comparoMay:             
        cmp byte ptr [bx], 24h
        je finComparamay

        cmp byte ptr [bx], 41h
        jb  noEsletra1

        cmp byte ptr [bx], 5Ah
        jbe esLetra1    

        cmp byte ptr [bx], 61h
        jb  noEsletra1

        cmp byte ptr [bx], 7Ah
        jbe esLetra1
noEsletra1:
        inc bx
        jmp comparoMay
esLetra1:
        inc byte ptr [si]
        inc bx
        jmp comparoMay  
finComparamay:
        pop si
        pop bx                  
        pop bp

        ret 4


cuentoLetras endp

cuentaIndividual proc
;Cuenta individualmente cada caracter para poder mostrar cuantas coincidencias hay
                        ;lea bx,texto                   ;ss:[bp+8]
                        ;push bx

                        ;lea bx,caracteres[si]   ;ss:[bp+6] 
                        ;push bx

                        ;lea bx,contador                        ;ss:[bp+4]
                        ;push bx

                        ;call cuentaIndividual
        push bp
        mov bp,sp

        push bx
        push si
        push di

        mov bx,ss:[bp+8] ; texto
        mov si,ss:[bp+6] ; direccion caracter
        mov di,ss:[bp+4] ; contador

recorrer:
        cmp byte ptr [bx],24h
        je fin

        mov dl,byte ptr[si]
        cmp byte ptr[bx],dl
        jne seguir

        inc byte ptr [di]

seguir:
        inc bx
        jmp recorrer

        fin:
        pop di
        pop si
        pop bx
        pop bp
        ret 6

cuentaIndividual endp



limpiaAscii proc

        ;limpio limpio ese ascii
        push bp
        mov bp,sp
        push bx

        mov bx, ss: [bp+4]      
        mov byte ptr [bx], '0'
        mov byte ptr [bx+1], '0'
        mov byte ptr [bx+2], '0'

        pop bx
        pop bp

        ret 2


limpiaAscii endp

limpiaVar proc
        ;la variable vuelve limpita
        push bp
        mov bp,sp
        push bx

        mov bx, ss: [bp+4]      
        mov byte ptr [bx],0


        pop bx
        pop bp
        ret 2
limpiaVar endp


carga proc
;cargo un texto en bx
        push bp
        mov bp,sp
        push ax
        push bx
        mov bx, ss:[bp+4]               
        cargartexto:
        mov ah,1
        int 21h
        cmp al, 0dh
        je finCarga
        mov byte ptr[bx], al
        inc bx
jmp cargartexto 
finCarga:
        mov byte ptr[bx],24h
        pop bx
        pop ax
        pop bp
        ret 2           
carga endp
soloLetras proc
;Ignora caracteres especiales solo admite letras
        push bp
        mov bp,sp
        push bx
        push ax
        push si
        xor al,al
        mov bx, ss:[bp+6]       ;pongo en bx el offset de un texto
        mov si, ss:[bp+4]       ;lo mismo pero en si
busco:
        cmp byte ptr[bx],24h
        je  finBusco

        cmp byte ptr[bx], 41h
        jb noEsletra

        cmp byte ptr[bx], 5Ah
        jbe esLetra

        cmp byte ptr[bx], 61h
        jb  noEsletra

        cmp byte ptr[bx], 7Ah
        jbe esLetra
noEsletra:
        inc bx
jmp busco

esLetra:
        mov al,byte ptr[bx]
        mov byte ptr[si],al 
        inc si
        inc bx
jmp busco


finBusco:
        mov byte ptr[si],24h
        pop si
        pop ax
        pop bx
        pop bp
        ret 4
soloLetras endp

public num2bin

num2bin proc
; Convierte un valor enteroa su representacion binaria ASCII
;   ss:[bp+6] Offset de la variable donde se guardara el binario
;   ss:[bp+4] contador

                        ;lea bx, nroBin
                        ;push bx

                        ;mov bl, byte ptr [contadorBin]
                        ;xor bh,bh
                        ;push bx

                        ;call num2bin
        push bp
        mov bp, sp
        push ax
        push bx
        push cx

        mov bx, ss:[bp+6]   ; Offset destino para el texto binario
        mov ax, ss:[bp+4]   ; Valor del contador a convertir
        mov cx, 8           ; Cambiar a 16 si se trabaja con contadores de 16 bits

convertir_loop:
        shl al, 1           
        jc es_uno
        mov byte ptr [bx], '0'
        jmp sig_bit

es_uno:
        mov byte ptr [bx], '1'

sig_bit:
        inc bx
        loop convertir_loop

        mov byte ptr [bx], 24h

        pop cx
        pop bx
        pop ax
        pop bp
        ret 4
num2bin endp

imprimir proc   
        push bp
        mov bp,sp
        push bx

        mov dx, ss:[bp+4]
        mov ah,9
        int 21h

        pop bx
        pop bp
        ret 2
imprimir endp

cuentaCaracteres proc
;Toma un texto, una lista de caracteres y cuenta cuantas veces esta la lista en el texto. 
;Todo junto, no distingue caracteres
    push bp
    mov bp, sp
    push bx
    push si
    push di

    mov bx, ss:[bp+8]   ; Rescato Texto
    mov si, ss:[bp+6]   ; lista
    mov di, ss:[bp+4]   ; Rescato puntero al Contador

comparo:
    cmp byte ptr[bx], 24h
    je finCuenta
    cmp byte ptr[si], 24h
    je aumento

    mov al,byte ptr [si]
    cmp byte ptr[bx],al
    jne continua
    inc byte ptr[di]
    inc bx
    mov si, ss:[bp+6]   ; recupero lista cuando hay coincidencia 
    jmp comparo

aumento:
        inc bx
        mov si, ss:[bp+6]       ; recupero lista cuando pegue la vuelta
        jmp comparo

continua:
        inc si
        jmp comparo

finCuenta:

    pop di
    pop si
    pop bx
    pop bp
    ret 6
cuentaCaracteres endp

compara proc
        ;RECIBE EN DL UN CARACTER y lo COMPARA CON UNA VARIABLE QUE VIENE CON EL OFFSET EN [SI] FINALIZADO CON 24h
        ;DEVUELVE EN AL, 1 SI ESE CARACTER SE ENCUENTRA EN LA LISTA QUE VIENE EN [SI]
        push si
        xor al, al 
procesoCompara:
        cmp byte ptr [si],24h
        je finSinCompara
        cmp dl, byte ptr [si]
        je finCompara
        inc si 
jmp procesoCompara

finCompara:
        mov al,1
finSinCompara:
        pop si
        ret
compara endp

incremento proc
; simplemente suma 1 en un offset de bx
        push bp
        mov bp,sp
        push bx
        mov bx, ss:[bp+4]

        inc byte ptr[bx]

        pop bx
        pop bp
        ret 2
incremento endp

r2a proc  ;recibe en bx el offset de una variable de 3 bytes, y el numero a convertir por dl no mayor a 255
                ;lea bx,nroAscii
                        ;mov dl, contador
                        ;call r2a 


        push ax
        push dx

        add bx,2
        xor ax,ax
        mov al, dl
        mov dl, 10
        div dl
        add [bx],ah

        xor ah,ah
        dec bx
        div dl
        add [bx],ah

        xor ah,ah
        dec bx
        div dl
        add [bx],ah

        pop dx
        pop ax

        ret
r2a endp

cambio proc
        ;recibo texto por bx a modificar las letras a por las x

        push bp
        mov bp,sp

        push bx
        push si
        push ax

        mov bx, ss:[bp+6]
        mov si, ss:[bp+4]
        xor al,al
comparaciona:
        cmp byte ptr[bx],24h
        je fincambia
        cmp byte ptr[bx],"a"
        je  cambiox
        mov al,byte ptr[bx]
        mov byte ptr[si],al
        inc si
        inc bx
jmp comparaciona        
cambiox:
        mov byte ptr[si],"x"
        inc bx
        inc si
        jmp comparaciona
fincambia:
        pop ax  
        pop si
        pop bx
        pop bp
        ret 4

cambio endp
end
