//
//  algorithm.h
//  SM3
//
//  Created by Angie on 15/11/5.
//  Copyright © 2015年 Angie. All rights reserved.
//

#ifndef algorithm_h
#define algorithm_h

#include "jni.h"

int getTokenWithSM3TOTP(unsigned int currentTime, unsigned int during, char *key, int tokenLength);


#endif /* algorithm_h */
