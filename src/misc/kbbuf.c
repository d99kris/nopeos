/*
 * kbbuf.c
 *
 * Copyright (c) 2015, Kristofer Berggren
 * All rights reserved.
 *
 * See src/misc/LICENSE for license details.
 *
 * Todo: Should have mutex protection for the keyboard buffer.
 *
 */

/* -- Includes ------------------------------------------------- */
#include <kbbuf.h>
#include <system.h>
#include <unistd.h>


/* -- Globals -------------------------------------------------- */
extern int csr_x;
extern int csr_y;


/* -- Locals --------------------------------------------------- */
static keyboard_buffer_t keyboard_buffer;

static unsigned char scan_to_ascii_US[128] =
{
  0,  27, '1', '2', '3', '4', '5', '6', '7', '8',
  '9', '0', '-', '=', '\b',	/* Backspace */
  '\t',	/* Tab */
  'q', 'w', 'e', 'r',
  't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',	/* Enter key */
  0, /* Control */
  'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',
  '\'', '`',   0, /* Left shift */
  '\\', 'z', 'x', 'c', 'v', 'b', 'n', /* 49 */
  'm', ',', '.', '/',   0, /* Right shift */
  '*',
  0,	/* Alt */
  ' ',	/* Space */
  0,	/* Caps lock */
  0,	/* F1 key ... > */
  0,   0,   0,   0,   0,   0,   0,   0,
  0,	/* < ... F10 */
  0,	/* Num lock*/
  0,	/* Scroll Lock */
  0,	/* Home key */
  0,	/* Up Arrow */
  0,	/* Page Up */
  '-',
  0,	/* Left Arrow */
  0,
  0,	/* Right Arrow */
  '+',
  0,	/* End key*/
  0,	/* Down Arrow */
  0,	/* Page Down */
  0,	/* Insert Key */
  0,	/* Delete Key */
  0,   0,   0,
  0,	/* F11 Key */
  0,	/* F12 Key */
  0,	/* All others undefined */
};

static unsigned char scan_to_ascii_US_shift[128] =
{
  0,  27, '!', '@', '#', '$', '%', '^', '&', '*',
  '(', ')', '_', '+', '\b',	/* Backspace */
  '\t', /* Tab */
  'Q', 'W', 'E', 'R',
  'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n', /* Enter key */
  0, /* Control */
  'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',
  '"', '~',   0, /* Left shift */
  '|', 'Z', 'X', 'C', 'V', 'B', 'N',
  'M', '<', '>', '?',   0, /* Right shift */
  '*',
  0,	/* Alt */
  ' ',	/* Space */
  0,	/* Caps lock */
  0,	/* 59 - F1 key ... > */
  0,   0,   0,   0,   0,   0,   0,   0,
  0,	/* < ... F10 */
  0,	/* 69 - Num lock*/
  0,	/* Scroll Lock */
  0,	/* Home key */
  0,	/* Up Arrow */
  0,	/* Page Up */
  '-',
  0,	/* Left Arrow */
  0,
  0,	/* Right Arrow */
  '+',
  0,	/* 79 - End key*/
  0,	/* Down Arrow */
  0,	/* Page Down */
  0,	/* Insert Key */
  0,	/* Delete Key */
  0,   0,   0,
  0,	/* F11 Key */
  0,	/* F12 Key */
  0,	/* All others undefined */
};


/* -- Functions ------------------------------------------------ */
void kb_buf_init()
{
  keyboard_buffer.head = keyboard_buffer.buf;
  keyboard_buffer.tail = keyboard_buffer.buf;  
}


void kb_buf_scan(unsigned char scancode)
{
  static unsigned char shifted = 0;

  /* Scancode handling */
  switch(scancode)
  {
    case 0x01: /* ESC */
      shutdown();
      break;

    case 0x48: /* Up */
      move_csr_offset(0, -1);
      break;

    case 0x4B: /* Left */
      move_csr_offset(-1, 0);
      break;

    case 0x4D: /* Right */
      move_csr_offset(1, 0);
      break;

    case 0x50: /* Down */
      move_csr_offset(0, 1);
      break;
      
    case 0x2A: /* LShift pressed */
    case 0x36: /* Rshift pressed */
      shifted = 1;
      break;

    case 0xAA: /* LShift released */
    case 0xB6: /* Rshift released */
      shifted = 0;
      break;
      
    default:   /* All others */
      if(scancode & 0x80)
      {
        /* No action on released regular keys */
      }
      else
      {
        /* Enqueue pressed keys to buffer */
        if(shifted)
        {
          keyboard_enqueue(scan_to_ascii_US_shift[scancode]);
        }
        else
        {
          keyboard_enqueue(scan_to_ascii_US[scancode]);
        }
      }
      break;
  }
}


unsigned char keyboard_dequeue(void)
{
  unsigned char ascii;
  if(keyboard_buffer.tail == keyboard_buffer.head)
  {
    return 0;
  }
  else
  {
    ascii = *keyboard_buffer.tail;
    keyboard_buffer.tail = keyboard_buffer.buf +
      ((keyboard_buffer.tail + 1 - keyboard_buffer.buf) % KEYBUFSIZ);
    return ascii;
  }
}


void keyboard_enqueue(unsigned char ascii)
{
  if(((keyboard_buffer.head + 1 - keyboard_buffer.buf) % KEYBUFSIZ) ==
     ((keyboard_buffer.tail - keyboard_buffer.buf) % KEYBUFSIZ))
  {
    /* Keyboard buffer full, ignore key press */
  }
  else
  {
    *keyboard_buffer.head = ascii;
    keyboard_buffer.head = keyboard_buffer.buf +
      ((keyboard_buffer.head + 1 - keyboard_buffer.buf) % KEYBUFSIZ);
  }
}


void move_csr_offset(int x, int y)
{
  csr_x += x;
  csr_y += y;
  if(csr_x < 0)
  {
    if(csr_y > 0)
    {
      csr_y--;
      csr_x = 80 - 1;
    }
    else
    {
      csr_x = 0;
    }
  }
  if(csr_x >= 80)
  {
    if(csr_y < (25 - 1))
    {
      csr_x = 0;
      csr_y++;
    }
    else
    {
      csr_x = 80 - 1;
    }
  }
  if(csr_y < 0)
  {
    csr_y = 0;
  }
  if(csr_y >= 25)
  {
    csr_y = 25 - 1;
  }

  move_csr();
}

