
//
// Created by 李延 on 2022/7/25.
//

#include "multiboot.h"


int _setup_init(multiboot_info_t *multiboot_info, uint32_t heap_addr) {

    unsigned int xcr0;

    __asm__ __volatile__(
            "mov $1, %%eax\n\t"   // 将功能号 1 加载到 EAX 寄存器
            "cpuid\n\t"           // 执行 CPUID 指令
            "mov %%ecx, %0\n\t"   // 将 ECX 寄存器的值传递给 xcr0 变量
            : "=r" (xcr0)         // 输出约束：将 ECX 寄存器的值存储在 xcr0 变量中
            :                    // 无输入
            : "%eax", "%ebx", "%edx" // 可能被修改的寄存器列表
            );

    // 提取 xcr0 中的第 26 位（CPUID.01H:ECX.XSAVE[bit 26]）
    int bit26 = (xcr0 >> 26) & 1;

    return bit26;


}