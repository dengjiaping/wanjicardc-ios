//
//  WJDBTableKeys.h
//  WanJiCard
//
//  Created by Harry Hu on 15/8/28.
//  Copyright (c) 2015年 zOne. All rights reserved.
//

#ifndef WanJiCard_WJDBTableKeys_h
#define WanJiCard_WJDBTableKeys_h

#define COL_ROWID   @"rowid"


/**
 *  地区
 */
#pragma mark - bookmark table_area

#define TABLE_AREA                  @"WJKAreaTable"
#define COL_AREA_ID                   @"AreaId"
#define COL_AREA_NAME                 @"Name"
#define COL_AREA_ONAME                @"Oname"
#define COL_AREA_ORDERNAME            @"OrderName"
#define COL_AREA_LEVEL                @"Level"
#define COL_AREA_PARENTID             @"Parentid"
#define COL_AREA_ISHOT                @"Ishot"
#define COL_AREA_LAT                  @"Lat"
#define COL_AREA_LNG                  @"Lng"
#define COL_AREA_ZOOM                 @"Zoom"
#define COL_AREA_REGION               @"Region"
#define COL_AREA_ISUSE                @"IsUse"
#define COL_AREA_RESVERED1            @"Resvered1"
#define COL_AREA_RESVERED2            @"Resvered2"
#define COL_AREA_RESVERED3            @"Resvered3"
#define COL_AREA_RESVERED4            @"Resvered4"
#define COL_AREA_RESVERED5            @"Resvered5"



/**
 *  卡片
 */
#pragma mark - bookmark table_card

#define TABLE_CARD                  @"WJKCardsTable"
#define COL_CARD_ID                     @"CardId"
#define COL_CARD_NAME                   @"Name"
#define COL_CARD_FaceValue              @"FaceValue"
#define COL_CARD_COVER                  @"Cover"
#define COL_CARD_SaleNumber             @"SaleNumber"
#define COL_CARD_SalePrice              @"SalePrice"
#define COL_CARD_CardStatus             @"CardStatus"
#define COL_CARD_ColorType              @"ColorType"
#define COL_CARD_MerName                @"MerName"
#define COL_CARD_OwnUserId              @"OwnUserId"


/**
 *  用户信息
 */
#pragma mark - bookmark table_person

#define TABLE_PERSON                  @"WJKPersonsTable"
#define COL_PERSON_ID                   @"WJK_COLUMN1"
#define COL_PERSON_Consumer             @"WJK_COLUMN2"
#define COL_PERSON_UserName             @"WJK_COLUMN3"
#define COL_PERSON_RealName             @"WJK_COLUMN4"
#define COL_PERSON_NichName             @"WJK_COLUMN5"
#define COL_PERSON_Phone                @"WJK_COLUMN6"
#define COL_PERSON_UserLevel            @"WJK_COLUMN7"
#define COL_PERSON_HeadImageUrl         @"WJK_COLUMN8"
#define COL_PERSON_IdCard               @"WJK_COLUMN9"
#define COL_PERSON_Gender               @"WJK_COLUMN10"
#define COL_PERSON_BirthdayYear         @"WJK_COLUMN11"
#define COL_PERSON_BirthdayMonth        @"WJK_COLUMN12"
#define COL_PERSON_BirthdayDay          @"WJK_COLUMN13"
#define COL_PERSON_Country              @"WJK_COLUMN14"
#define COL_PERSON_Province             @"WJK_COLUMN15"
#define COL_PERSON_City                 @"WJK_COLUMN16"
#define COL_PERSON_Token                @"WJK_COLUMN17"
#define COL_PERSON_PayPassword          @"WJK_COLUMN18"
#define COL_PERSON_IsActively           @"WJK_COLUMN19"
#define COL_PERSON_IsSetPayPassword     @"WJK_COLUMN20"
#define COL_PERSON_Authentication       @"WJK_COLUMN21"
#define COL_PERSON_IsNewUser            @"WJK_COLUMN22"
#define COL_PERSON_HasVerifyPayPsd      @"WJK_COLUMN23"
#define COL_PERSON_PayPsdSalt           @"WJK_COLUMN24"
#define COL_PERSON_IsSetPsdQuestion     @"WJK_COLUMN25"
#define COL_PERSON_AppealStatus         @"WJK_COLUMN26"



#endif
