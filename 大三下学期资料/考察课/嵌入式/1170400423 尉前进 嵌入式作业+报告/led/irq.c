#define GPNCON        (*((volatile unsigned long *)0x7F008830))
#define GPKCON        (*((volatile unsigned long *)0x7F008800))
#define EINT0CON0     (*((volatile unsigned long *)0x7F008900))
#define EINT0MASK     (*((volatile unsigned long *)0x7F008920))
#define VIC0INTENABLE (*((volatile unsigned long *)0x71200010))
#define EINT0PEND     (*((volatile unsigned long *)0x7F008924))
#define GPNDAT        (*((volatile unsigned long *)0x7F008834))
#define GPKDAT	      (*((volatile unsigned long *)0x7F008808))
#define VIC0ADDRESS   (*((volatile unsigned long *)0x71200f00))

void do_irq()
{
	/* 分辨是哪个中断 */	
	for (int i = 0; i < 4; i ++)
	{
		if (EINT0PEND & (1<<i))
		{
			if (GPNDAT & (1<<i))
			{
				GPKDAT = ~(0x0);  //release->light off
			}
			else
			{
				GPKDAT = ~(0x10<<i);//press->light on		
			}
		}
	}
	/* 清中断 */	
	EINT0PEND = 0xf;	
	VIC0ADDRESS = 0;
}

void irq_init()
{
    /* 配置GPN0~3引脚为中断功能 */
    GPNCON &= ~(0xff);
    GPNCON |= 0xaa;
    GPKCON = 0x11110000;
    /* 中断触发方式为: 双边沿触发 */
    EINT0CON0 &= ~(0xff);
    EINT0CON0 |= 0x77;
    /* 取消屏蔽外部中断eint0~3 */
    EINT0MASK &= ~(0xf);
    /* 在中断控制器里使能这些中断 */
    VIC0INTENABLE |= (0x1);
}
















