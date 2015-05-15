/*
 * string.c
 *
 * Copyright (c) 2015, Kristofer Berggren
 * All rights reserved.
 *
 * See src/misc/LICENSE for license details.
 *
 */

/* -- Includes ------------------------------------------------- */
#include <string.h>
#include <stdio.h>


/* -- Functions ------------------------------------------------ */
char *strcpy(char *dst, const char *src)
{
  unsigned int i = 0;
  for(i=0; src[i] != 0; i++)
  {
    dst[i] = src[i];
  }
  dst[i] = 0;
  return dst;
}


char *strcat(char *dst, const char *src)
{
  unsigned int i = 0;
  unsigned int j = 0;
  for (i = 0; dst[i] != 0; i++)
  {
  }
  for (j = 0; src[j] != 0; j++)
  {
    dst[i+j] = src[j];
  }
  dst[i+j] = 0;
  return dst;
}


int strcmp(const char *s1, const char *s2)
{
 while(*s1 && (*s1 == *s2))
 {
   s1++;
   s2++;
 }
 return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

