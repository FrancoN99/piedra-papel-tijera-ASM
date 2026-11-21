.8086
.model small
.stack 100h

JUMPS
.data
.code
        public r2a 
        public imprimir
        public saltito
        public limpiaPantalla
        public ubica
        public reset3

       
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

imprimir proc   ;antes de imprimir se tiene que pushear el offset de lo que querramos imprimir
        push bp
        mov bp,sp
        push bx

        mov dx, ss:[bp+4] ;BP+0 ES EL BP | BP+2 ES EL IP | BP+4 EL OFFSET DE LO QUE PUSHEAMOS
        mov ah,9
        int 21h

        pop bx
        pop bp
        ret 2
imprimir endp

;Limpia la pantalla con secuencia ANSI PROBANDO RECIBIR EN DX EL COMANDO ANSI
limpiaPantalla proc
    push ax
    push dx

    mov ah, 09h         
    int 21h         

    pop dx
    pop ax
    ret
limpiaPantalla endp

; Posiciona el cursor: DH = fila, DL = columna 25x80
ubica proc
    push ax
    push bx
    push dx

    xor bh, bh
    mov ah, 2 ;02H DE LA INT10 SETEA EL CURSOR EN ESA POSICION
    int 10h

    pop dx
    pop bx
    pop ax
    ret
ubica endp




; Deja en "000" el texto apuntado por BX
reset3 proc
    push bx
    mov byte ptr [bx], "0"
    mov byte ptr [bx+1], "0"
    mov byte ptr [bx+2], "0"
    pop bx
    ret
reset3 endp




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



end