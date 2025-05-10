/*
 * unistd.c
 *
 * Copyright (c) 2015-2025 Kristofer Berggren
 * All rights reserved.
 *
 * See src/misc/LICENSE for license details.
 *
 */

/* -- Includes ------------------------------------------------- */
#include <system.h>
#include <tinybasic.h>


/* -- Functions ------------------------------------------------ */
void reboot(void)
{
  unsigned char good = 0x02;
  while (good & 0x02)
  {
    good = inportb(0x64);
  }
  outportb(0x64, 0xFE);
 loop:
  asm volatile ("hlt");
  goto loop;
}


void shutdown(void)
{
  /* Until we have proper shutdown, we just reboot */
  reboot();
}


void application_start(void)
{
  char* IL = (char *)0;

  puts("");
  puts("    **** NOPE OS V0.2 (C) 2025 ****    ");
  puts("X86 CPU, BKERNDEV 2005, TINY BASIC 2004");
  puts("READY.");

  StartTinyBasic(IL);

  for(;;);
}

