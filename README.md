# Piedra, Papel o Tijera (ASM 8086)

Proyecto final de la materia SPD - UNSAM.

Juego de piedra, papel o tijera en ensamblador 8086 para DOS/DOSBox.

> Estado: finalizado

## Estructura

- `tpf.asm`: programa principal (`.model small`, genera `tpf.exe`)
- `tpflib.asm`: librería de rutinas, se enlaza con `tpf`
- `81.asm`: interrupción propia residente (`.model tiny`, genera `81.com`)
- `build.bat`: compila todo

## Compilar

```
build
```

o a mano:

```
tasm 81.asm
tlink /t 81.obj

tasm tpf.asm
tasm tpflib.asm
tlink tpf.obj tpflib.obj
```

## Ejecutar

```
81.com
tpf.exe
```

`81` se ejecuta una sola vez por sesión de DOSBox.

## Autores

- Baigorria Aaron Damian, Benitez Mariano Gabriel, Navarro Franco Alejo
