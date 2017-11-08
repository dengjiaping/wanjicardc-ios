//
//  algorithm.c
//  SM3
//
//  Created by Angie on 15/11/5.
//  Copyright © 2015年 Angie. All rights reserved.
//

#include "algorithm.h"


#include <stdio.h>
#include <math.h>
#include <string.h>
#include <android/log.h>
#include <stdlib.h>
#include <netinet/in.h>
#include "sm33.h"

#define MaxBufferSize       256
#define TAG    "tianzhenhai" // 这个是自定义的LOG的标识
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__) // 定义LOGD类型
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,TAG ,__VA_ARGS__) // 定义LOGI类型
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN,TAG ,__VA_ARGS__) // 定义LOGW类型
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR,TAG ,__VA_ARGS__) // 定义LOGE类型
#define LOGF(...) __android_log_print(ANDROID_LOG_FATAL,TAG ,__VA_ARGS__) // 定义LOGF类型


void TokenThenNSStringConvertASCII(char *str, unsigned char *p){

    int length = strlen(str);
    int i = 0;
    for (i = 0; i < length; i = i + 2) {
        char s2[2] = {0};

        strncpy(s2, str+i, 2);

        p[i/2] = strtoul(s2, 0, 16);
    }

}

int getTokenWithSM3TOTP(unsigned int currentTime, unsigned int during, char * key, int tokenLength){

    unsigned int T0 = currentTime;
    unsigned int X = during;
    unsigned int T = T0 / X;

    int D = tokenLength;

    unsigned long keyLength = strlen(key)/2;

    unsigned char sm3_in[MaxBufferSize] = {0};

    unsigned char ausTokenID[keyLength];

    unsigned char S[keyLength+4];

    unsigned char P0[32];

    unsigned int I1,I2,I3,I4,I5,I6,I7,I8,I;
    unsigned int P;


    unsigned char* p = 0;

    if (CheckCPUIsLittleEndian() == 0){
        unsigned int V = NTOHL(T);
        T = V;
    }
    LOGD("T = %d\n", T);
    p = (unsigned char*)&T;
    LOGD("p = %s\n", p);

    sm3_in[0] = *(p + 3);
    sm3_in[1] = *(p + 2);
    sm3_in[2] = *(p + 1);
    sm3_in[3] = *(p + 0);
    LOGD("key = %s\n", key);
    TokenThenNSStringConvertASCII(key, ausTokenID);
    memcpy(sm3_in+4, ausTokenID, keyLength);
    memcpy(S, sm3_in, keyLength+4);
    LOGD("S = %s \n", S);
    unsigned char *q = P0;
    SM3Calc(S, (unsigned int)keyLength+4, q);

    LOGD("p0 = %s\n q = %s\n", P0, q);
    I1 = P0[0] << 24 | P0[1] << 16 | P0[2] << 8 | P0[3];
    I2 = P0[4] << 24 | P0[5] << 16 | P0[6] << 8 | P0[7];
    I3 = P0[8] << 24 | P0[9] << 16 | P0[10] << 8 | P0[11];
    I4 = P0[12] << 24 | P0[13] << 16 | P0[14] << 8 | P0[15];
    I5 = P0[16] << 24 | P0[17] << 16 | P0[18] << 8 | P0[19];
    I6 = P0[20] << 24 | P0[21] << 16 | P0[22] << 8 | P0[23];
    I7 = P0[24] << 24 | P0[25] << 16 | P0[26] << 8 | P0[27];
    I8 = P0[28] << 24 | P0[29] << 16 | P0[30] << 8 | P0[31];

    unsigned long base = pow(2, 32);
    I = (I1 + I2 + I3 +I4 +I5 +I6 + I7 +I8) % base;

    base = (unsigned long)pow(10, D);
    P = I % base;

    LOGD("SM3-TOTP generate token - %d\n", P);


    return P;
}


