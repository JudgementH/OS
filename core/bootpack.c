/* 声明有一个函数在别的文件中，让编译器自己找 */
void io_hlt(void);
void write_mem8(int addr, int data);

void HariMain(void)
{
	int i;
	
	char *p; //BYTE[p]
	//写屏幕像素
	
	p = (char *)0xa0000;
	for(i = 0x0000; i <= 0xffff;i++)
	{
		//write_mem8(i, i & 0x0f);
		i[p] = i & 0x0f;
	}
	
	for(;;)
	{
		io_hlt();
	}
		
}