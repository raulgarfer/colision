#include "cpctelera.h"
extern u8 array;
extern   u8 cpct_collision_check (u8 *)__z88dk_fastcall;

void check(){
    int yes;
    yes= cpct_collision_check (&array);
}