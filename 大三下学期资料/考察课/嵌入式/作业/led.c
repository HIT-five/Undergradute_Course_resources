 
 SystemInit()
{

}


main()
{
  int i;
	volatile unsigned int * pDir = (volatile unsigned int * )(0x50010000+0x8000);
	volatile unsigned int * pData = (volatile unsigned int * )(0x50010000+0x3ffc);

	*pDir = (0x000f); 
	*pData = (0x000f);
	
	while(1)
	{	 
		for(i=0;i<1000;i++); 
		*pData = (0x000e);
		for(i=0;i<1000;i++);
		*pData = (0x000d);
		for(i=0;i<1000;i++);
		*pData = (0x000b);
		for(i=0;i<1000;i++);
		*pData = (0x0007);
		for(i=0;i<1000;i++);
	}
}

