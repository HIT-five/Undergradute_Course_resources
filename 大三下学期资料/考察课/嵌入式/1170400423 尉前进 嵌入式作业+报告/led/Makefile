all: start.o led.o irq.o	
	arm-linux-ld -Tirq.lds -o irq.elf $^	
	arm-linux-objcopy -O binary irq.elf irq.bin 
%.o:%.S	
	arm-linux-gcc -g -o $@ -c $^
%.o:%.c	arm-linux-gcc -g -o $@ -c $^
.PHONY: clean
clean:	
	rm *.o *.elf *.bin	
