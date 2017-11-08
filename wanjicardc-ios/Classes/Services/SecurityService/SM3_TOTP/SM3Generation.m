//
//  SM3_TOTP_Algorithm.m
//  WanJiCard
//
//  Created by Angie on 15/10/20.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "SM3Generation.h"
#import "SM3.h"

#define MaxBufferSize       256

@implementation SM3Generation

int CheckCPUIsBigEndian()
{
    union
    {
        int a;
        char b;
    }c;
    c.a = 1;
    return (c.b == 1);
}


+ (NSString *)getTokenWithSM3TOTP:(unsigned int)currentTime
                tokenChangeDuring:(unsigned int)during
                           priKey:(NSString *)key
                      tokenLength:(int)tokenLength{
    
    unsigned int T0 = currentTime;
    unsigned int X = during;
    unsigned int T = T0 / X;
    
    int D = tokenLength;
    
    int keyLength = (int)key.length/2;
    
    unsigned char sm3_in[MaxBufferSize] = {0};
    
    unsigned char ausTokenID[keyLength];
    
    
    unsigned char S[keyLength+4];
    
    unsigned char P0[32];
    
    unsigned int I1,I2,I3,I4,I5,I6,I7,I8,I;
    unsigned int P;
//    NSUInteger I1,I2,I3,I4,I5,I6,I7,I8,I;
//    NSUInteger P;
    
    unsigned char* p = 0;
    
    if (NSHostByteOrder() == NS_BigEndian){
        unsigned int V = NTOHL(T);
        T = V;
    }
    
    p = (unsigned char*)&T;
    sm3_in[0] = *(p + 3);
    sm3_in[1] = *(p + 2);
    sm3_in[2] = *(p + 1);
    sm3_in[3] = *(p + 0);
    
    TokenThenNSStringConvertASCII(key, ausTokenID);
    memcpy(sm3_in+4, ausTokenID, keyLength);
    memcpy(S, sm3_in, keyLength+4);
    
    SM3Calc(S, keyLength+4, P0);
    
    I1 = P0[0] << 24 | P0[1] << 16 | P0[2] << 8 | P0[3];
    I2 = P0[4] << 24 | P0[5] << 16 | P0[6] << 8 | P0[7];
    I3 = P0[8] << 24 | P0[9] << 16 | P0[10] << 8 | P0[11];
    I4 = P0[12] << 24 | P0[13] << 16 | P0[14] << 8 | P0[15];
    I5 = P0[16] << 24 | P0[17] << 16 | P0[18] << 8 | P0[19];
    I6 = P0[20] << 24 | P0[21] << 16 | P0[22] << 8 | P0[23];
    I7 = P0[24] << 24 | P0[25] << 16 | P0[26] << 8 | P0[27];
    I8 = P0[28] << 24 | P0[29] << 16 | P0[30] << 8 | P0[31];
    
    unsigned long long base = pow(2, 32);

    I = (unsigned int)((I1 + I2 + I3 + I4 + I5 + I6 + I7 +I8) % (unsigned long long)base);
    
    base = (unsigned long)pow(10, D);
    P = I % (unsigned int)base;

    NSString *token = [NSString stringWithFormat:@"%@", @(P)];

    while (token.length < 6) {
        token = [@"0" stringByAppendingString:token];
    }

    return token;
}

void TokenThenNSStringConvertASCII(NSString *str, unsigned char *p){
    
    NSInteger length = str.length;
    for (NSUInteger i = 0; i < length; i+=2) {
        NSString *numb = [str substringWithRange:NSMakeRange(i, 2)];
        p[i/2] = strtoul([numb UTF8String], 0, 16);
    }
    
}

@end
