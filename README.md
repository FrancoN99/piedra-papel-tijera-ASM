# Piedra, Papel o Tijera (ASM 8086)

Proyecto final de la materia SPD - UNSAM.

Juego de piedra, papel o tijera en ensamblador 8086 para DOS/DOSBox.

> Estado: en desarrollo

## Estructura

- `ppt.asm`: programa principal (`.model small`, genera `ppt.exe`)
- `pptlib.asm`: librería de rutinas, se enlaza con `ppt`
- `mint.asm`: interrupción propia residente (`.model tiny`, genera `mint.com`)
- `build.bat`: compila todo

## Compilar

```
build
```

o a mano:

```
tasm mint.asm
tlink /t mint.obj

tasm ppt.asm
tasm pptlib.asm
tlink ppt.obj pptlib.obj
```

## Ejecutar

```
mint.com
ppt.exe
```

`mint.com` se ejecuta una sola vez por sesión de DOSBox.

## Autores

- Baigorria Aaron Damian, Benitez Mariano Gabriel, Navarro Franco Alejo