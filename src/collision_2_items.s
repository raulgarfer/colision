;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of CPCtelera: An Amstrad CPC Game Engine
;;
;;  Copyright (C) 2022 Néstor Gracia (https://github.com/nestornillo)
;;  Copyright (C) 2023 Joaquín Ferrero (https://github.com/joaquinferrero)
;;  Copyright (C) 2024 raulgarfer (https://github.com/raulgarfer)
;;  Copyright (C) 2024 cpcitor (https://github.com/cpcitor/)
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
.module cpct_maths

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Function: cpct_divideby10
;;
;; Returns the result of dividing an integer number by 10.
;;
;; C Definition:
;;    <u8> <cpct_divideby10> (u8 dividend) __z88dk_fastcall;
;;
;; Input Parameters (1 Byte):
;;    (1B A) dividend  - Number to be divided by 10
;;
;; Assembly call (Input parameter on register A):
;;    > call cpct_divideby10_asm
;;
;; Return Value (Assembly calls, return in A):
;;    <u8> - Result of the operation.
;;
;; Parameter Restrictions:
;;    * *dividend* must be among 0 and 255.
;;
;; Details:
;;    This function calculates the integer quotient of dividing a given number
;; by 10. The function does not return a remainder, nor does it use decimals in
;; its operations.
;;
;;    For achieving its result in a fast way, this function uses an approximation
;; that fails when the input value is greater than 127, so a correction is made
;; on those cases in order to get the correct result for all 256 possible input
;; values.
;;
;;    A number divided by 10 is equal to that number divided by 2 and multiplied
;; by 1/5 (0.20). For example, if we consider N = 20, then:
;; (start code)
;; 1) 20/2 * 1/5
;; 2) 10/1 * 1/5
;; 3) 10/5
;; 4) 2
;; So, 20/10 = 2.
;; (end code)
;;
;;    The fraction 1/5 is close to 13/64, so it is possible to approximate the
;; division N/10 as (N/2)*(13/64). That approximation works well up to 127, but
;; then it 'shifts' from the actual result of N/10. It is necessary to adjust for
;; higher values.
;; (start code)
;; N/10 = N/2 * 1/5, which is close to N/2 * 13/64.
;; The approximation 13/64 can be refactored to:
;; 1) (1   + 4   +  8) / 64, which is equal to
;; 2) (1/8 + 4/8 + 8/8 ) / 8
;; 3) (1/8 + 1/2 + 1/1 ) / 8
;; Previously we omitted N/2, let's insert it now:
;; 4) N/2 * 1 / 5 is similar to
;; 5) N/2 * (1/8  + 1/2 + 1/1) / 8, which refactors to
;; 6)       (N/16 + N/4 + N/2) / 8
;; (end code)
;; (start code)
;; Taking the example of number 125, and rounding down divisions:
;; 1) (125/16 + 125/4 + 125/2) / 8
;; 2) (   7   +   31  +   62 ) / 8
;; 3) (          100         ) / 8
;; 4)             12
;; (end code)
;;
;; This is a simplified explanation, the code actually groups partial results
;; together so as to minimize the number of shift-right operations,
;; and it happens that the result is more precise that way.
;;
;; Destroyed Register values:
;;    AF, BC
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
;;    Original code by Néstor Gracia 2022. Optimized by Joaquín Ferrero & Néstor
;; Gracia in 2023
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.module collisions
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

