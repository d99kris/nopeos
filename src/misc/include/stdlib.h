/*
 * stdlib.h
 *
 * Copyright (c) 2015, Kristofer Berggren
 * All rights reserved.
 *
 * See src/misc/LICENSE for license details.
 *
 */

#ifndef __STDLIB_H__
#define __STDLIB_H__


/* -- Includes ------------------------------------------------- */
#include <system.h>


/* -- Prototypes ----------------------------------------------- */
void *malloc(size_t size);
void free(void *ptr);


#endif

