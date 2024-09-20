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
                             29 .globl _collision_check
                             30 .area _DATA
                             31 
                             32 
                             33 .area _CODE
   4010                      34 _main::
                             35 
   4010 CD 00 40      [17]   36   call _collision_check
                             37 
                             38    ;; Loop forever
   4013                      39 loop:
   4013 18 FE         [12]   40    jr    loop
