#define __ASM__ 1
#include <boot.h>

#define MB_FLAGS    MULTIBOOT_MEMORY_INFO | MULTIBOOT_PAGE_ALIGN
#define KPG_SIZE    10*4096

.section .multiboot
    .long MULTIBOOT_MAGIC
    .long MB_FLAGS
    .long CHECKSUM(MB_FLAGS)


.section .bss
    .align 16
    stack_bottom:
        .skip STACK_SIZE, 0
    stack_top:

.section .setup_heap
    heap_start:
        .skip HEAP_SIZE, 0


.section .text
    .global _start
    _start:
        cli

        movl $stack_top, %esp
        pushl $heap_start
        pushl %ebx
        call _setup_init #

    1:
        hlt
            jmp 1b

