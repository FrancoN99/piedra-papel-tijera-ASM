;-----------------------------------------------------------------------
; Plantilla TSR con interrupciones propias
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
DespInt81 dw 0          ; Vector original INT 81h
SegInt81  dw 0
Contador  dw 0          ; Variables propias de las ISR

;-----------------------------------------------------------------------
; ISR INT 81h
; Entrada: ...
; Salida : ...
;-----------------------------------------------------------------------
Isr81 PROC FAR
  sti
  push ds
  push cs
  pop  ds               ; DS = CS para acceder a datos residentes

  ; ---- tu codigo aqui ----
  inc Contador
  mov ax, Contador

  pop ds
  iret
Isr81 ENDP

; ---- Agregar mas ISR aca (Isr82, Isr83, ...) con la misma estructura ----

FinResidente LABEL BYTE

;=======================================================================
; INSTALADOR (se descarta al terminar)
;=======================================================================
Cartel DB "Programa instalado exitosamente!!!",0Dh,0Ah,'$'

main:
  mov ax, cs
  mov ds, ax
  mov es, ax

InstalarInt:
  mov ax, 3581h         ; Guardar vector original (ES:BX)
  int 21h
  mov DespInt81, bx
  mov SegInt81, es

  mov ax, 2581h         ; Instalar la nueva ISR (DS:DX)
  mov dx, offset Isr81
  int 21h

MostrarCartel:
  mov dx, offset Cartel
  mov ah, 9
  int 21h

DejarResidente:
  mov dx, offset FinResidente
  add dx, 15            ; Redondeo hacia arriba
  mov cl, 4
  shr dx, cl            ; Bytes -> parrafos
  mov ax, 3100h         ; TSR, codigo de salida 0
  int 21h
end start