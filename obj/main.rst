ASxxxx Assembler V02.00 + NoICE + SDCC mods  (Zilog Z80 / Hitachi HD64180), page 1.
Hexadecimal [16-Bits]



                              1 ;;-----------------------------LICENSE NOTICE------------------------------------
                              2 ;;  This file is part of CPCtelera: An Amstrad CPC Game Engine 
                              3 ;;  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
                              4 ;;
                              5 ;;  This program is free software: you can redistribute it and/or modify
                              6 ;;  it under the terms of the GNU Lesser General Public License as published by
                              7 ;;  the Free Software Foundation, either version 3 of the License, or
                              8 ;;  (at your option) any later version.
                              9 ;;
                             10 ;;  This program is distributed in the hope that it will be useful,
                             11 ;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
                             12 ;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
                             13 ;;  GNU Lesser General Public License for more details.
                             14 ;;
                             15 ;;  You should have received a copy of the GNU Lesser General Public License
                             16 ;;  along with this program.  If not, see <http://www.gnu.org/licenses/>.
                             17 ;;-------------------------------------------------------------------------------
                             18 
                             19 ;; Include all CPCtelera constant definitions, macros and variables
                             20 ;;.include "cpctelera.h.s"
                             21 
                             22 ;;
                             23 ;; Start of _DATA area 
                             24 ;;  SDCC requires at least _DATA and _CODE areas to be declared, but you may use
                             25 ;;  any one of them for any purpose. Usually, compiler puts _DATA area contents
                             26 ;;  right after _CODE area contents.
                             27 ;;
                             28 .module main.s
                             29 .globl cpct_collision_check_asm
                             30 .globl _cpct_collision_check
                             31 .area _DATA
                             32 
   4054 10 04 10 04 20 04    33 _array:: .db 0x10,4,0x10,4,0x20,4,0x20,4
        20 04
   405C DE AD BE EF          34 junk::  .db 0xde,0xad,0xbe,0xef
                             35 .area _CODE
   404C                      36 _main::
                             37  ;;  ld hl,#_array
                             38  ;; call cpct_collision_check_asm
   404C 21 54 40      [10]   39   ld hl,#_array
   404F CD 29 40      [17]   40   call _cpct_collision_check
                             41 
                             42    ;; Loop forever
   4052                      43 loop:
   4052 18 FE         [12]   44    jr    loop
