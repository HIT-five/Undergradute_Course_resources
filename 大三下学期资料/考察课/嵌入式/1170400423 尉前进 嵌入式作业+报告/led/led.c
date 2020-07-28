/*waterfall light*/
int main()
{
	int i = 0x10;	
	volatile unsigned long *gpkcon0 = (volatile unsigned long *)0x7F008800;	 	 
	volatile unsigned long *gpkdat  = (volatile unsigned long *)0x7F008808;
	*gpkcon0 = 0x11110000;
	while (1)
	{
		*gpkdat = ~i;		
		i = i<<1;		
		if (i == 0x100 )			
		i = 0x10;		
		delay();	
	}	
	return 0;
}
void delay()
{
    volatile int i = 0xa000;
    while (i--);//延时
}