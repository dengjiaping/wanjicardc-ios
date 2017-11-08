//
//  SSErrorType.h
//  Pods
//
//  Created by Gang Li on 5/2/15.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SSErrorType) {
    /*! 正常网络. */
    SSNetworkSuccess = 1000,
    /*! 无网络. */
    SSNoNetworkError,
    /*! 网络错误. */
    SSNetworkError,
    /*! 数据解析错误. */
    SSDataParseError,
    /*! 无数据. */
    SSNODataError,
    /*! 其他错误. */
    SSOtherError,
    /*! LSNoError. */
    SSNoError,
    /*! 用户名或密码错误. */
    SSUserNameOrPassWordError
};
