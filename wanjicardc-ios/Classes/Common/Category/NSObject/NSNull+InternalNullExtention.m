//
//  NSNull+InternalNullExtention.m
//  WanJiCard
//
//  Created by Angie on 15/12/15.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "NSNull+InternalNullExtention.h"
#import <objc/runtime.h>


#define XYNullObjects @[@"",@0,@{},@[]]


@implementation NSNull (InternalNullExtention)

+ (void)load
{
    @autoreleasepool {
        [self swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(methodSignatureForSelector:) replacementSel:@selector(methodSignatureForSelector:)];
        [self swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(forwardInvocation:) replacementSel:@selector(forwardInvocation:)];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (signature != nil)
        return signature;
    
    for (NSObject *object in XYNullObjects)
    {
        signature = [object methodSignatureForSelector:selector];
        
        if (!signature)
            continue;
        
        if (strcmp(signature.methodReturnType, "@") == 0)
        {
            signature = [[NSNull null] methodSignatureForSelector:@selector(__is_nil)];
        }
        
        return signature;
    }
    
    
    return [self methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0)
    {
        anInvocation.selector = @selector(__is_nil);
        [anInvocation invokeWithTarget:self];
        return;
    }
    
    for (NSObject *object in XYNullObjects)
    {
        if ([object respondsToSelector:anInvocation.selector])
        {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self forwardInvocation:anInvocation];
}

- (id)__is_nil
{
    return nil;
}

+ (void)swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method a = class_getInstanceMethod(clazz, original);
    Method b = class_getInstanceMethod(clazz, replacement);
    if (class_addMethod(clazz, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(clazz, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}

@end
