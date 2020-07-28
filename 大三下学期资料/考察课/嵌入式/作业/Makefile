all: led.o 
	arm-linux-ld -Tled.lds -o led.elf led.o
	arm-linux-objcopy -O binary led.elf led.bin
	
led.o : led.S
	arm-linux-gcc -g -o led.o -c led.S
	
.PHONY: clean
clean:
	rm *.o led.elf led.bin


