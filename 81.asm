

; interrupcion propia 81h

.8086
.model tiny
.code
   org 100h
start:
  jmp main
 
; PARTE RESIDENTE

DespInt81 dw 0
SegInt81  dw 0
Magia     dw 0A55Ah     ; firma para detectar si ya esta instalado
RondasUsu dw 0
RondasPc  dw 0
RondasEmp dw 0
 

Isr81 PROC FAR
  sti
  push ds
  push cs
  pop  ds
 
  cmp ah, 0FFh ;firma para saber si está instalado
  jne N1
  jmp F_Firma
N1:
  cmp ah, 0 ; AH=0 devuelve en AL = jugada de la PC (0 piedra, 1 papel, 2 tijera)
  jne N2
  jmp F_Random
N2:
  cmp ah, 1 ; AH=1 tiene en AL = usuario, BL = PC ; devuelve AL = 0 empate, 1 gana usuario, 2 gana PC
  jne N3
  jmp F_Comparar
N3:
  cmp ah, 2 ; AH=2 verifica que tiene en AL = resultado de la ronda (0/1/2) y se suma al historial
  jne N4
  jmp F_Registrar
N4:
  cmp ah, 3 ; AH=3 llena 3 registros con las rondas anotadas, devuelve en AX = rondas del usuario, BX = de la PC, CX = empates
  jne N5
  jmp F_Stats
N5: 
  jmp Fin81
 
F_Firma:
  mov ax, Magia
  jmp Fin81
 
F_Random:
    push cx
    push dx
    

    mov ah, 2Ch
    int 21h             ; trae en distintos registros el reloj de la BIOS, usamos DL

    xor ax, ax

    mov al, dl          ;en DL están los milisegundos que trajimos
    mov cl, 3
    div cl              ; AL = cociente, AH = resto (0, 1 o 2)

    mov al, ah          ; Pasamos el resto a AL porque lo devolvemos ahi

    
    pop dx
    pop cx
  jmp  Fin81

F_Comparar: ;REALIZA UNA OPERACIÓN COMPARANDO AMBAS ELECCIONES PARA DEVOLVER 0, 1 O 2
  sub  al, bl ;eleccion - eleccionpc
  add  al, 3 ;eleccion + 3
  cmp  al, 3 ;si el numero que quedo en eleccion es menor a 3, salta al fin de la int, en caso de quedar 1 gana el usuario, 2 gana la pc
  jb   Fin81
  sub  al, 3 ;si el numero que quedo en eleccion es igual a 3, le resta 3, y devuelve 0, osea empate
  jmp  Fin81
 
F_Registrar: ;registra en los contadores que estan guardados en la interrupcion quien gano
  cmp  al, 0
  je   RegEmp ;si es 0 suma empates
  cmp  al, 1
  je   RegUsu ;si es 1 suma una ganada al usuario
  inc  RondasPc ;si no es ninguna de las dos suma una ganada a la cpu
  jmp  Fin81
RegEmp:
  inc  RondasEmp
  jmp  Fin81
RegUsu:
  inc  RondasUsu
  jmp  Fin81
 
F_Stats: ;devuelve en estos tres registros los contadores de las estadisticas
  mov  ax, RondasUsu
  mov  bx, RondasPc
  mov  cx, RondasEmp
 
Fin81:
  pop  ds
  iret
Isr81 ENDP
 
FinResidente LABEL BYTE
 
;INSTALADOR
Cartel   DB "Programa instalado exitosamente!!!",0Dh,0Ah,'$'
CartelYa DB "El programa ya estaba instalado.",0Dh,0Ah,'$'
 
main:
  mov ax, cs
  mov ds, ax
  mov es, ax
 
  mov ax, 3581h           ; leer vector actual (ES:BX)
  int 21h
  mov DespInt81, bx
  mov SegInt81, es
 
  mov ax, es              ; si el vector es 0:0, no hay nada instalado
  or  ax, bx
  jz  Instalar
  mov ah, 0FFh            ; si no, preguntar la firma
  int 81h
  cmp ax, 0A55Ah
  jne Instalar
 
  mov ax, cs              ; ya estaba instalado: avisar y salir sin TSR
  mov ds, ax
  mov dx, offset CartelYa
  mov ah, 9
  int 21h
  mov ax, 4C00h
  int 21h
 
Instalar:
  mov ax, cs
  mov ds, ax
  mov ax, 2581h           ; instalar la nueva ISR 
  mov dx, offset Isr81
  int 21h
 
  mov dx, offset Cartel
  mov ah, 9
  int 21h
 
  mov dx, offset FinResidente
  add dx, 15              ; redondeo hacia arriba
  mov cl, 4
  shr dx, cl              ; bytes = parrafos
  mov ax, 3100h           ; TSR, codigo de salida 0
  int 21h

end start 