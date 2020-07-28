.text
.globl _start
#define VIC0_INT	0x71200000
#define VIC1_INT	0x71300000

_start: bl reset
		ldr	pc, _undefined_instruction
		ldr	pc, _software_interrupt
		ldr	pc, _prefetch_abort
		ldr	pc, _data_abort
		ldr	pc, _not_used
		ldr	pc, _irq
		ldr	pc, _fiq
_undefined_instruction:b .
_software_interrupt:b .
_prefetch_abort:b .
_data_abort:b .
_not_used:b .
_irq:.word irq
_fiq:b .
reset:
#外设地址告诉cpu    
	ldr r0, =0x70000000    
	orr r0, r0, #0x13    
	mcr p15,0,r0,c15,c2,4 
#关看门狗	
	ldr r0, =0x7E004000	
	mov r1, #0	
	str r1, [r0]	

	ldr sp, =8*1024 @设置栈	

	bl irq_init @初始化irq

#开中断	
	mov r0, #0x53			
	msr CPSR_cxsf, r0

#LED走马灯
	ldr sp, =0x0c002000
	bl main

  halt:	
	bl halt

irq:
#保存现场	
	ldr sp, =4*1024	
	sub lr, lr, #4	

	stmdb sp!, {r0-r12, lr} 	
	bl do_irq @处理异常
#恢复现场	
	ldmia sp!, {r0-r12, pc}^




