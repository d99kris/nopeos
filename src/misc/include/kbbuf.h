/*
 * kbbuf.h
 *
 * Copyright (c) 2015, Kristofer Berggren
 * All rights reserved.
 *
 * See src/misc/LICENSE for license details.
 *
 */

#ifndef __KBBUF_H__
#define __KBBUF_H__


/* -- Defines -------------------------------------------------- */
#define KEYBUFSIZ 64


/* -- Types ---------------------------------------------------- */
typedef struct 
{
  unsigned char buf[KEYBUFSIZ];
  unsigned char *head;
  unsigned char *tail;
} keyboard_buffer_t;
unsigned char keyboard_dequeue(void);


/* -- Prototypes ----------------------------------------------- */
void kb_buf_scan(unsigned char scancode);
void kb_buf_init();
void keyboard_enqueue(unsigned char ascii);
void move_csr_offset(int x, int y);


#endif

