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
    mensajePierdePc db "Usted ha ganado!",0dh,0ah,24h
    mensajeGanaPc db "Usted ha perdido!",0dh,0ah,24h
    eleccion db 0
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

    jmp inicio

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

jmp fin

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

    cmp al, 2
    je ganaPc

jmp fin

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

    cmp al, 2
    je ganaPc

empate:
	lea bx, mensajeEmpate
	push bx
	call imprimir
jmp	fin

pierdePc:
	lea bx, mensajePierdePc
	push bx
	call imprimir
jmp	fin

ganaPc:
	lea bx, mensajeGanaPc
	push bx
	call imprimir

	
fin:




    mov ax, 4C00h
    int 21h
main endp

end main                ; El punto de entrada va únicamente acá