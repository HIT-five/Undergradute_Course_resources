
#include "s3c2440_soc.h"
void delay(volatile int d)
{
	while (d--);
}

int main(void)
{
	int val1, val2;

	GPFCON &= ~((3<<0) | (3<<4));
	GPGCON &= ~(3<<6);
	GPFCON &= ~((3<<8) | (3<<10) | (3<<12));
	GPFCON |=  ((1<<8) | (1<<10) | (1<<12));
	while (1)
	{
		val1 = GPFDAT;
		val2 = GPGDAT;

		if ((val1 & (1<<0)) == 0 )	
		{
			GPFDAT &= ~(1<<4);
		}
		else
		{
			GPFDAT |= (1<<4);
		}
		if ((val1 & (1<<2)) == 0 )	
		{
			GPFDAT &= ~(1<<5);
		}
		else
		{
			GPFDAT |= (1<<5);
		}
		if ((val2 & (1<<3)) == 0 )	
		{
			GPFDAT &= ~(1<<6);
		}
		else
		{
			GPFDAT |= (1<<6);
		}
	}
	return 0;
}
