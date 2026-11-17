.8086
.model small
.stack 100h

.data

    mensajePiedra db "PC eligio: Piedra", 0dh,0ah,24h
    mensajePapel  db "PC eligio: Papel", 0dh,0ah,24h
    mensajeTijera db "PC eligio: Tijera", 0dh,0ah,24h
    cartel db "Bienvenido a Piedra, Papel o Tijera!", 0dh,0ah,24h
    cartel2 db "Presione 0 para piedra, 1 para papel, 2 para tijera o 3 para instrucciones", 0dh,0ah,24h
    mensajeEmpate db "Usted ha empatado", 0dh,0ah,24h
    mensajePierdePc1 db "Usted ha ganado! Llego a 3 puntos",0dh,0ah,24h
    mensajeGanaPc1 db "Usted ha perdido! La Cpu llego a 3 puntos",0dh,0ah,24h
    mensajePierdePc db "Usted ha ganado! Suma 1 punto",0dh,0ah,24h
    mensajeGanaPc db "Usted ha perdido! Suma un 1 punto la Cpu",0dh,0ah,24h
    eleccion db 0
    contadorCpu db "0", 0dh,0ah,24h
    contadorUsu db "0", 0dh,0ah,24h
    PuntajeUsu db "Su puntaje es: ",24h
    PuntajeCpu db "Puntaje de Cpu: ",24h
.code

extrn random:proc      
extrn imprimir:proc
extrn comparoTijera:proc
extrn comparoPiedra:proc
extrn comparoPapel:proc

main proc
    mov ax, @data
    mov ds, ax
inicio:
    lea bx, cartel
    push bx
    call imprimir
vuelta:
    lea bx, cartel2
    push bx
    call imprimir

    mov ah,1
    int 21h

    cmp al,"0"
    je piedra	

 	cmp al,"1"
    je papel   

    cmp al,"2"
    je tijera

    ;cmp al,"3"
    ;je instrucciones

    jmp vuelta

piedra:
	mov eleccion,0
jmp pc

papel:
	mov eleccion,1
jmp pc

tijera:
	mov eleccion,2
pc:
    call random         ; Llama a la librería externa (deja 0, 1 o 2 en AL)

    cmp al, 0
    je es_piedra
    cmp al, 1
    je es_papel
    jmp es_tijera

es_piedra:

    lea bx, mensajePiedra
    push bx
    call imprimir

    lea bx, eleccion
    push bx

    call comparoPiedra

    cmp al,0
    je empate

    cmp al,1
    je pierdePc

    cmp al,2
    je ganaPc

jmp vuelta

es_papel:

    lea bx, mensajePapel
    push bx
    call imprimir

    lea bx, eleccion
    push bx

    call comparoPapel

    cmp al,0
    je empate

    cmp al,1
    je pierdePc

    cmp al,2
    je ganaPc

jmp vuelta

es_tijera:

    lea bx, mensajeTijera
    push bx
    call imprimir

    lea bx, eleccion
    push bx

    call comparoTijera

    cmp al,0
    je empate

    cmp al,1
    je pierdePc

    cmp al,2
    je ganaPc

empate:
	lea bx, mensajeEmpate
	push bx
	call imprimir
jmp	vuelta

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

jmp	vuelta

ganaPc:

    inc contadorCpu
	cmp contadorCpu,"3"
    je ganaCpu
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
    
jmp vuelta    

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

jmp fin

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

fin:

    mov ax, 4C00h
    int 21h
main endp

end main
