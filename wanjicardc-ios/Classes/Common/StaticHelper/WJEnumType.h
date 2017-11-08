//
//  WJEnumType.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJEnumType_h
#define WanJiCard_WJEnumType_h

typedef NS_ENUM(NSInteger, PushType) {
    PushTypeChargeComplete = 1,
    PushTypeSystom,
    PushTypeLogout,     //token过期
    PushTypeActivity,
    PushTypeKickedOut,   //拉黑
    PushTypeFair        //市集
    
};


/**
 数据库排序
 */
typedef NS_ENUM(NSInteger, TS_ORDER_E) {
    ORDER_BY_NONE = 0,
    ORDER_BY_DESC,
    ORDER_BY_ASC
} ;


/**
 *  虚拟卡的背景图片类型
 */
typedef NS_ENUM(NSInteger, CardBgType){
    CardBgTypeRed = 1,
    CardBgTypeOrange = 2,
    CardBgTypeBlue = 3,
    CardBgTypeGreen = 4,
    CardBgTypeInvalid
};


/**
 *  订单类型
 */
typedef enum
{
    OrderTypeAll      = 0,            //全部
    OrderTypeBuyCard  = 1,            //商品卡购卡
    OrderTypeCharge   = 2,            //商品卡充值
    OrderTypeBaoZiCharge = 3,         //包子充值
    OrderTypeElectronicCard = 4,      //电子卡

}OrderType;

/**
 *  电子卡支付类型
 */
typedef NS_ENUM(NSInteger, ElectronicCardPayType){
    
    ElectronicCardPayTypeYiLian = 0,         // 易联
    ElectronicCardPayTypePingAdds = 1,       // ping++
    ElectronicCardPayTypeBaoZi   = 2         // 包子支付
};


/**
 *  品牌类型
 */
typedef NS_ENUM(NSInteger, BrandType){
    
    BrandTypeMerchantCard   = 1,        // 商家卡品牌
    BrandTypeElectronicCard = 2,        // 电子卡品牌
};


/**
 *  订单状态
 */
typedef NS_ENUM(NSInteger, OrderStatus){
   
    OrderStatusSuccess = 1,        // 完成
    OrderStatusClose = 2,          // 已关闭订单
    OrderStatusUnfinished = 3,     // 待支付订单（未完成订单）
    OrderStatusPartRefund = 5,     // 部分退款
    OrderStatusFullyRefund = 6,    // 全额退款
    OrderStatusAll = 25,             // 全部
//    OrderStatusProcess = 15,      // 处理中
//    OrderStatusPaid = 20,         // 已支付，未发货
//    OrderStatusRefunded = 45,     // 订单退回
    OrderStatusLocked = 60        // 锁定
};

/**
 *  订单状态
 */
typedef NS_ENUM(NSInteger, ticketSelectStatus){
    
    None = 1,            /**压根就不显示单选框*/

    Selected = 2,        /**单选框为选中状态*/

    Inactive = 3,        /**单选框为未选中*/
};


typedef enum
{
    DefautType = 40
}PayType;


/**
 支付类型
 */
typedef enum
{
    ChargeTypeConsume = -1,
    ChargeTypeYiBao_ = 5,        //易宝
    ChargeTypePingAdds = 40,     //ping++
    ChargeTypeYiLian = 55        //易联
   
}ChargeType;

/**
 活动提示
 */
typedef NS_ENUM(NSInteger, ActivityStatus){
    
    ActivityPause = 50008056,                     //活动暂停，显示为活动结束
    ActivityEnd = 50008057,                      //活动结束
    ActivityNoQualification = 50008058,          //不满足条件
    ActivityNoStock = 50008059,                  //库存已售尽
    
};

typedef enum
{
    FavorableTicketTypeBuy = 1,             //购卡
    FavorableTicketTypeCharge = 2,          //充值
    FavorableTicketTypeConsume = 3          //消费
    
}FavorableTicketType;

typedef enum
{
    TopicTypeNoAction = 0,
    TopicTypeSomeThingActionj = 5,//要改
    TopicTypeWebViewAction = 10,
}TopicType;

typedef enum
{
    ColorTypeRed = 1,
    ColorTypeOrigne = 2,
    ColorTypeBlueColor = 3,
    ColorTypeGreenColor = 4
}ColorType;

/**
 *  账单状态
 */
typedef NS_ENUM(NSInteger, BillStatus){
    
    BillStatusUnfinished = 0,     // 待支付订单
    BillStatusSuccess = 1,        // 完成
    BillStatusClose = 2,          // 已关闭订单
    BillStatusStatusAll = 10     // 全部
};

/**
 *  卡兑换类型
 */
typedef NS_ENUM(NSInteger, CardExchangeType){
    
    CardExchangeTypeAll = 0,              //全部
    CardExchangeTypeTelephoneCharge = 1,  //话费
    CardExchangeTypeGame = 2,             //游戏
    //    CardExchangeTypePrepaidCard = 3       //预付费卡
};

#endif
