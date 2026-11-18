
;-----------------------------------------------------------------------
; TSR INT 81h - servicio del juego Piedra, Papel o Tijera
; tasm mint.asm
; tlink /t mint.obj
;-----------------------------------------------------------------------
.8086
.model tiny
.code
   org 100h
start:
  jmp main
 
;=======================================================================
; PARTE RESIDENTE
;=======================================================================
DespInt81 dw 0
SegInt81  dw 0
Magia     dw 0A55Ah     ; firma para detectar si ya esta instalado
Semilla   dw 1234h
RondasUsu dw 0
RondasPc  dw 0
RondasEmp dw 0
 
; AH=0   -> AL = jugada de la PC (0 piedra, 1 papel, 2 tijera)
; AH=1   -> AL = usuario, BL = PC ; devuelve AL = 0 empate, 1 gana usuario, 2 gana PC
; AH=2   -> AL = resultado de la ronda (0/1/2): se suma al historial
; AH=3   -> devuelve AX = rondas del usuario, BX = de la PC, CX = empates
; AH=0FFh-> devuelve AX = firma
Isr81 PROC FAR
  sti
  push ds
  push cs
  pop  ds
 
  cmp ah, 0FFh
  jne N1
  jmp F_Firma
N1:
  cmp ah, 0
  jne N2
  jmp F_Random
N2:
  cmp ah, 1
  jne N3
  jmp F_Comparar
N3:
  cmp ah, 2
  jne N4
  jmp F_Registrar
N4:
  cmp ah, 3
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
  push es
  mov  ax, 40h
  mov  es, ax
  mov  ax, es:[6Ch]       ; ticks del reloj del BIOS
  add  ax, Semilla
  mov  cx, 25173
  mul  cx
  add  ax, 13849
  mov  Semilla, ax
  xor  dx, dx
  mov  cx, 3
  div  cx                 ; DX = resto (0..2)
  mov  al, dl
  pop  es
  pop  dx
  pop  cx
  jmp  Fin81
 
F_Comparar:
  sub  al, bl
  add  al, 3
  cmp  al, 3
  jb   Fin81
  sub  al, 3
  jmp  Fin81
 
F_Registrar:
  cmp  al, 0
  je   RegEmp
  cmp  al, 1
  je   RegUsu
  inc  RondasPc
  jmp  Fin81
RegEmp:
  inc  RondasEmp
  jmp  Fin81
RegUsu:
  inc  RondasUsu
  jmp  Fin81
 
F_Stats:
  mov  ax, RondasUsu
  mov  bx, RondasPc
  mov  cx, RondasEmp
 
Fin81:
  pop  ds
  iret
Isr81 ENDP
 
FinResidente LABEL BYTE
 
;=======================================================================
; INSTALADOR (se descarta al terminar)
;=======================================================================
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
  mov ax, 2581h           ; instalar la nueva ISR (DS:DX)
  mov dx, offset Isr81
  int 21h
 
  mov dx, offset Cartel
  mov ah, 9
  int 21h
 
  mov dx, offset FinResidente
  add dx, 15              ; redondeo hacia arriba
  mov cl, 4
  shr dx, cl              ; bytes -> parrafos
  mov ax, 3100h           ; TSR, codigo de salida 0
  int 21h
 
end start