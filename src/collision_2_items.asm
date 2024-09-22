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
;;
;;    Para la primera comprobacion se calcula posicion X(A) mas el ancho de la entidad(B).
;; Despues se le resta la X(C) de la segunda entidad. Si el resultado es positivo 
;; (C<B,no hay acarreo),se sigue calculando el sigueinte paso. Si el resultado es 
;; negativo (C>B,hay acarreo), termina la funcion, retornando en A un 0. 
;;
;; C--ENT2--D  A--ENT1--B  
;;    Las siguientes comprobaciones son D contra A,en eje X. Tras esta comprobacion,
;; se procede a comprobar las coordenadas, pero en eje Y. 
;;    Si tras las cuatro comprobaciones hay colision , se retorna en A un 1.
;;
;; Destroyed Register values:
;;    AF, HL
;;
;; Required memory:
;;    C-bindings - 32 +b bytes
;;  ASM-bindings - 32 +b byte
;;
;; Time Measures:
;; (start code)
;;     Case   | microSecs (us) | CPU Cycles
;; -----------------------------------------
;;     Best   |      18        |     72
;; -----------------------------------------
;;     Worst  |      51        |     204
;; -----------------------------------------
;; Asm saving |      -2        |     -8
;; -----------------------------------------
;; (end code)
;;
;; Credits:
;;    Adapted code by Fran Gallego. 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; input Hl como array a comprobar. El orden debe ser el siguiente:
;; Hl+0 = X entidad 1
;; HL+1 = ancho entidad 1
;; HL+2 = X entidad 2
;; HL+3 = ancho entidad 2
;; Hl+4 = Y entidad 1
;; HL+5 = alto entidad 1
;; HL+6 = Y entidad 2
;; HL+7 = alto entidad 2
;;
;;_collision_check::
    ;;cargamos primero la X de entidad 1 y le sumamos el ancho
        ld a,(hl)       ;;A  = X entidad 1
        ld b,a          ;;B  = X entidad 1
        inc hl          ;; 
        add a,(hl)      ;;A += ancho entidad 1
        inc hl          ;;
        sub a,(hl)      ;;A -= X entidad 2
            jr c,no_collision 
    ;;comprobamos derecha de entidad 2 contra X de entidad 1  
        ld a,(hl)         ;; A  = X entidad 2 
        inc hl            ;;  
        add a,(hl)        ;; A += ancho entidad 2
        sub b             ;; A -= X entidad 1
           jr c,no_collision
    ;;Se ha comprobado que las dos entidades coinciden en el eje X.  
    ;;Ahora comprobamos abajo de entidad 1 contra Y de entidad 2
        inc hl            ;;
        ld a,(hl)         ;; A  = Y entidad 1
        ld b,a            ;; B  = Y de entidad 1
        inc hl            ;;  
        add a,(hl)        ;; A += alto entidad 1
        inc hl            ;;
        sub a,(hl)        ;; A -= Y entidad 2
            jr c,no_collision ;;
    ;;comprobamos abajo de entidad 2 contra Y de entidad 1  
        ld a,(hl)         ;; A  = Y entidad 2 
        inc hl            ;;  
        add a,(hl)        ;; A += alto entidad 2
        sub b             ;; recuperamos Y de entidad 1 y restamos
            jr c,no_collision ;;
    ;;  Ambas entidades coinciden en eje X e Y. Hay colision. Retornamos 
    ;; un valor diferente a 0 en el registro A para declarar que ha habido choque
        ld a,#1           ;; 
ret
        
no_collision:
    ;;  Tras comprobar que no hay colision entre las dos entidades, retornamos un
    ;; valor 0 para declarar que no hubo colision.
        ld a,#0          ;;


