;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine
;;
;;  Copyright (C) 2024 raulgarfer (https://github.com/raulgarfer)
;;  Copyright (C) 2024 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;-------------------------------------------------------------------------------
.module collisions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Function: cpct_detect_collision
;;
;; Returns if there was a collision betwwen two items.
;;
;; C Definition:
;;    <u8> <cpct_detect_collision> (u8* items) __z88dk_fastcall;
;;
;; Input Parameters (1 Byte):
;;    (2B HL) Array - Beginnig of data in use
;;
;; Assembly call (Input parameter on register HL):
;;    > call cpct_divideby10_asm
;;
;; Return Value (Assembly calls, return in A):
;;    <u8> - Result of the collision check.
;;
;; Parameter Restrictions:
;;    * No checking of valid data.
;;
;; Details:
;;   Esta funcion calcula si ha habido colision entre dos estidades conocidas.
;; Para ello calcula los limites de cada entidad y los compara con la otra entidad.
;; 
;; A--ENT1--B  C--ENT2--D
;;    Para la primera comprobacion se calcula posicion X(A) mas el ancho de la entidad(B).
;; Despues se le resta la X(C) de la segunda entidad. Si el resultado es positivo 
;; (C<B,no hay acarreo),se sigue calculando el sigueinte paso. Si el resultado es 
;; negativo (C>B,hay acarreo), termina la funcion, retornando en A un 0. 
;;    Si hay colision , se retorna en A un 1.
;;
;; Destroyed Register values:
;;    AF, HL
;;
;; Required memory:
;;    C-bindings - 21 bytes
;;  ASM-bindings - 19 byte
;;
;; Time Measures:
;; (start code)
;;     Case   | microSecs (us) | CPU Cycles
;; -----------------------------------------
;;     Any    |      23        |     92
;; -----------------------------------------
;; Asm saving |      -2        |     -8
;; -----------------------------------------
;; (end code)
;;
;; Credits:
;;    Adapted code by Fran Gallego. 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;input Hl como array a comprobar. El orden debe ser el siguiente:
;; Hl+0 = X entidad 1
;; HL+1 = ancho entidad 1
;; HL+2 = X entidad 2
;; HL+3 = ancho entidad 2
;; Hl+4 = 
;; HL+5 = 
;; HL+6 = 
;; HL+7 = 
;; se comprueba si dos objetos se colisionan en X e Y
;;
;; A--ITEM1--B  C--ITEM2--D
;; if (B < C) no_collision
;; C--ITEM2--D  A--ITEM1--B
;; if (D < A) no_collision
;;
_collision_check::
    ;;cargamos primero la X de entidad 1 y le sumamos el ancho
        ld a,(hl)       ;;A  = X entidad 1
        inc hl          ;;HL = ancho entidad 
        add a,(hl)      ;;A += ancho entidad 1
    ;;restamos la X de entidad 2
        inc hl          ;;HL = X entidad 2
        sub a,(hl)      ;;A -= X entidad 2
        jr c,no_collision  
    ;;comprobamos derecha de entidad 2 contra X de entidad 1  
        inc hl            ;;\
        ld a,(hl)         ;; | 
        inc hl            ;; | A=X + alto
        add a,(hl)        ;; |
        inc hl            ;;/
        sub a,(hl)        ;; A-=X ent1   
        jr c,no_collision ;;


        ld a,#1         ;;hay colision
ret
        
no_collision:
        ld a,#0         ;;no hay colision
ret

