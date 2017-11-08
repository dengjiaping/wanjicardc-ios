//
//  WJOrderCell.m
//  WanJiCard
//
//  Created by Harry Hu on 15/9/18.
//  Copyright © 2015年 zOne. All rights reserved.
//

#import "WJOrderCell.h"

#define  timeImageViewRightMargin                                (iPhone6OrThan?(ALD(123)):(ALD(135)))
#define  remainTimeLRightMargin                                  (iPhone6OrThan?(ALD(110)):(ALD(115)))

@interface WJOrderCell()

@property(nonatomic, strong)NSDictionary *colorDic;

@end

@implementation WJOrderCell{
    UILabel     *statusL;
    UILabel     *orderNOL;
    UIView      *line;
    UIImageView *iconIV;
    UIImageView *steamedIV;
    UILabel     *nameL;
    UILabel     *countL;
    UILabel     *faceL;
//    UILabel *amountL;
    UIButton    *payButton;
    UIView      *bottomLine;
    UIImageView *logoIV;
    UIView      *logoBehindLine;
    UILabel     *merNameLabel;
    UILabel     *merDesLabel;
    UILabel     *logoFaceL;
    
    NSInteger   second;
    NSTimer     *remainTimer;
    UILabel     *remainTimeL;
    UIImageView *timeImageView;
    UIButton    *buyAgainButton;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        orderNOL = [[UILabel alloc] initWithFrame:CGRectMake(10, ALD(10), kScreenWidth - ALD(70), ALD(30))];
        orderNOL.textColor = WJColorDardGray9;
        orderNOL.font = WJFont12;
        orderNOL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:orderNOL];
        
        statusL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - ALD(60), ALD(10), ALD(50), ALD(30))];
        statusL.textColor = WJColorDardGray9;
        statusL.font = WJFont12;
        statusL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:statusL];
        
        remainTimeL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - remainTimeLRightMargin,  ALD(10), ALD(45), ALD(30))];
        remainTimeL.textAlignment = NSTextAlignmentRight;
        remainTimeL.textColor = WJColorNavigationBar;
        remainTimeL.font = WJFont12;
        remainTimeL.hidden = YES;
        [self.contentView addSubview:remainTimeL];
        
        timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - timeImageViewRightMargin, ALD(17), ALD(15), ALD(15))];
        timeImageView.hidden = YES;
        timeImageView.image = [UIImage imageNamed:@"WaitingPayCount"];
        [self.contentView addSubview:timeImageView];
        
    
        line = [[UIView alloc] initWithFrame:CGRectMake(ALD(10), ALD(42), kScreenWidth - ALD(20), 0.5)];
        line.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:line];
        
        iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, line.bottom + ALD(15), ALD(109), ALD(65))];
//        iconIV.backgroundColor = WJColorViewBg;
        iconIV.layer.cornerRadius = 4;
        [self.contentView addSubview:iconIV];
        
        UIImage* steamedIVImage = [UIImage imageNamed:@"order_icon_ steamedRecharge"];

        steamedIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, line.bottom + ALD(15), steamedIVImage.size.width, steamedIVImage.size.height)];
        steamedIV.layer.cornerRadius = steamedIVImage.size.height/2;
        steamedIV.hidden = YES;
        [self.contentView addSubview:steamedIV];
        
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(iconIV.right+ ALD(15), line.bottom + ALD(14), kScreenWidth - ALD(139), 22)];
        nameL.textColor = WJColorDarkGray;
        nameL.font = WJFont15;
        [self.contentView addSubview:nameL];
        
        countL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.frame.origin.x, nameL.bottom, ALD(80), 22)];
        countL.textAlignment = NSTextAlignmentLeft;
        countL.textColor = WJColorDardGray9;
        countL.hidden = YES;
        countL.font = WJFont13;
        [self.contentView addSubview:countL];
        
        faceL = [[UILabel alloc] initWithFrame:CGRectMake(nameL.frame.origin.x, nameL.bottom, ALD(100), ALD(25))];
        faceL.textColor = WJColorDardGray9;
        faceL.font = WJFont12;
        [self.contentView addSubview:faceL];

        self.amountL = [[UILabel alloc] initWithFrame:CGRectMake(faceL.frame.origin.x, faceL.bottom, kScreenWidth - ALD(100), 22)];
        self.amountL.textColor = WJColorAmount;
        self.amountL.font = WJFont14;
        [self.contentView addSubview:self.amountL];
        
//        payButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        payButton.frame = CGRectMake(kScreenWidth - 10 - ALD(90), CGRectGetMaxY(nameL.frame) + ALD(25), ALD(90), ALD(30));
//        [payButton setTitle:@"立即支付" forState:UIControlStateNormal];
//        [payButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
//        payButton.layer.cornerRadius = 4;
//        payButton.layer.borderColor = WJColorNavigationBar.CGColor;
//        payButton.layer.borderWidth = 0.5;
//        payButton.titleLabel.font = WJFont14;
//        [payButton addTarget:self action:@selector(nowPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:payButton];
        
        
        buyAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyAgainButton.frame = CGRectMake(kScreenWidth - 10 - ALD(90), CGRectGetMaxY(nameL.frame) + ALD(15), ALD(90), ALD(30));
        [buyAgainButton setTitle:@"再次购买" forState:UIControlStateNormal];
        [buyAgainButton setTitleColor:WJColorNavigationBar forState:UIControlStateNormal];
        buyAgainButton.layer.cornerRadius = 4;
        buyAgainButton.layer.borderColor = WJColorNavigationBar.CGColor;
        buyAgainButton.layer.borderWidth = 0.5;
        buyAgainButton.titleLabel.font = WJFont14;
        buyAgainButton.hidden = YES;
        [buyAgainButton addTarget:self action:@selector(buyAgainButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:buyAgainButton];
        
        bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, ALD(140) -  ALD(0.5), kScreenWidth, ALD(0.5))];
        bottomLine.hidden = YES;
        bottomLine.backgroundColor = WJColorSeparatorLine;
        [self.contentView addSubview:bottomLine];
        
        
        logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(5), (iconIV.height - ALD(21))/2, ALD(21), ALD(21))];
//        logoIV.layer.cornerRadius = logoIV.frame.size.height / 2.0f;
//        logoIV.layer.masksToBounds = YES;
//        logoIV.alpha = 0.3f;
//        logoIV.backgroundColor = WJColorWhite;
        
        logoBehindLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoIV.frame) + ALD(6), (iconIV.height - ALD(20))/2, ALD(0.5), ALD(20))];
        logoBehindLine.alpha = 0.6;
        logoBehindLine.backgroundColor = WJColorSeparatorLine;
        
        merNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoBehindLine.frame) + ALD(6), CGRectGetMinY(logoIV.frame), ALD(70), ALD(8))];
        merNameLabel.textColor = [UIColor whiteColor];
        merNameLabel.font = [UIFont systemFontOfSize:6];
        
        logoFaceL = [[UILabel alloc] initWithFrame:CGRectMake(merNameLabel.frame.origin.x, merNameLabel.bottom, ALD(60), ALD(10))];
        logoFaceL.textColor = [UIColor whiteColor];
        logoFaceL.font = [UIFont systemFontOfSize:5];

//        merDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(ALD(5), ALD(50), ALD(99), ALD(10))];
//        merDesLabel.textColor = [UIColor whiteColor];
//        merDesLabel.font = [UIFont systemFontOfSize:5];
        
        [iconIV addSubview:logoIV];
        [iconIV addSubview:logoBehindLine];
        [iconIV addSubview:logoFaceL];
//        [iconIV addSubview:merDesLabel];
        [iconIV addSubview:merNameLabel];
        
    }
    return self;
}

- (void)configCellWithOrder:(WJOrderModel *)order  isDetail:(BOOL)state{
    
    //订单列表页面
    if (!state) {
        line.hidden = YES;
        timeImageView.hidden = YES;
        remainTimeL.hidden = YES;
        bottomLine.hidden = YES;
        countL.hidden = NO;
        faceL.hidden = YES;
        
    } else {
        //订单详情页面
        second = order.countDown - self.during;
        
        line.hidden = NO;
        bottomLine.hidden = NO;
        countL.hidden = YES;

        if (order.orderStatus == OrderStatusUnfinished) {
            
            remainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Countdown) userInfo:nil repeats:YES];
            
            if (second > 0) {
                
                NSString *time = [self TimeformatFromSeconds:second];
                remainTimeL.text = [NSString stringWithFormat:@"%@",time];
                
                timeImageView.hidden = NO;
                remainTimeL.hidden = NO;
                
            } else {
                timeImageView.hidden = YES;
                remainTimeL.hidden = YES;
                if ([self.delegate respondsToSelector:@selector(changeOrderStatus)]) {
                    [self.delegate changeOrderStatus];
                }
            }
        }
    
        
    }

//    NSArray *statusText = @[@"待支付", @"已完成", @"已关闭",@"已退款"];
    //    int index = order.orderStatus == OrderStatusUnfinished ? 0 :(order.orderStatus == OrderStatusSuccess ? 1 : (order.orderStatus == OrderStatusClose ? 2 : 3));

    NSArray *statusText = @[@"待支付", @"已完成", @"已关闭"];

    int index = order.orderStatus == OrderStatusUnfinished ? 0 :(order.orderStatus == OrderStatusSuccess ? 1 : 2);

    statusL.text = statusText[index];
    
    if (state) {
        statusL.textColor = WJColorNavigationBar;
    }else{
        statusL.textColor = (order.orderStatus == OrderStatusUnfinished) ? WJColorNavigationBar : WJColorDardGray9;
    }
    
    orderNOL.text = [NSString stringWithFormat:@"订单编号：%@", order.orderNo];
    [logoIV sd_setImageWithURL:[NSURL URLWithString:order.cardCover]
              placeholderImage:[UIImage imageNamed:@"home_card_default"]];

//     iconIV.backgroundColor = [WJGlobalVariable cardBackgroundColorByType:(NSInteger)order.ctype];
    steamedIV.image = [UIImage imageNamed:@"order_icon_ steamedRecharge"];
    
    nameL.text = order.name;
    countL.text = [NSString stringWithFormat:@"数量： %@", @(order.count)];
    faceL.text = [NSString stringWithFormat:@"面值%@元",order.faceValue];
    
    merNameLabel.text = order.name;
    
    logoFaceL.text = [NSString stringWithFormat:@"面值 ￥%@元",order.faceValue];

    [self showOrderAmountByOrderType:order];
    
//    self.amountL.text = [NSString stringWithFormat:@"￥ %@", order.PayAmount];
//    payButton.hidden = (order.orderStatus != OrderStatusUnfinished || state);
//    merDesLabel.text = order.merName;
    
}

- (void)showOrderAmountByOrderType:(WJOrderModel *)order
{
    if (order.orderType == OrderTypeBaoZiCharge) {
        
        iconIV.hidden = YES;
        steamedIV.hidden = NO;
        faceL.hidden = YES;
        buyAgainButton.hidden = YES;
        
        if (self.isOrder) {
            
            nameL.frame = CGRectMake(steamedIV.right+ ALD(15), line.bottom + ALD(14), kScreenWidth - ALD(139), 22);

            countL.frame = CGRectMake(nameL.frame.origin.x, nameL.bottom, ALD(80), 22);
            self.amountL.frame = CGRectMake(countL.frame.origin.x, countL.bottom, kScreenWidth - ALD(100), 22);
            self.amountL.text = [NSString stringWithFormat:@"￥ %@", [WJUtilityMethod floatNumberForMoneyFomatter:[order.PayAmount floatValue]]];
           
            
        } else {
            nameL.frame = CGRectMake(steamedIV.right+ ALD(15), line.bottom + ALD(25), kScreenWidth - ALD(139), 22);

            self.amountL.frame = CGRectMake(nameL.frame.origin.x, nameL.bottom + ALD(10), kScreenWidth - ALD(100), 22);
            self.amountL.attributedText = [self attributedText:[NSString stringWithFormat:@"充值金额: ￥%@", [WJUtilityMethod floatNumberForMoneyFomatter:[order.PayAmount floatValue]]] firstLength:6 lastColor:WJColorAmount];
            
        }
        
    } else if (order.orderType == OrderTypeElectronicCard) {
        
        faceL.hidden = YES;
        steamedIV.hidden = YES;
        merNameLabel.hidden = YES;
        logoIV.layer.masksToBounds = NO;
        logoBehindLine.hidden = YES;
        
        iconIV.backgroundColor = [WJUtilityMethod colorWithHexColorString:order.cardColor];

        
        if (self.isOrder) {
            
            if (order.orderStatus == OrderStatusSuccess) {
                
                if (order.isBuyAgain == 0) {
                    buyAgainButton.hidden = YES;

                } else {
                    
                    buyAgainButton.hidden = NO;
                }
            } else {
                buyAgainButton.hidden = YES;
                
            }
            
            self.amountL.text = [NSString stringWithFormat:@"%@个包子", [WJUtilityMethod baoziNumberFormatter:order.PayAmount]];

            
        } else {
            nameL.frame = CGRectMake(iconIV.right+ ALD(15), line.bottom + ALD(25), kScreenWidth - ALD(139), 22);

            self.amountL.frame = CGRectMake(nameL.frame.origin.x, nameL.bottom + ALD(10), kScreenWidth - ALD(100), 22);
            buyAgainButton.hidden = YES;
            self.amountL.text = [NSString stringWithFormat:@"%@个包子", [WJUtilityMethod baoziNumberFormatter:order.salePrice]];

        }
        
        logoIV.frame = CGRectMake((iconIV.width - ALD(60))/2, CGRectGetMinY(logoIV.frame), ALD(60), ALD(21));

        countL.frame = CGRectMake(nameL.frame.origin.x, nameL.bottom, ALD(80), 22);
        logoFaceL.frame = CGRectMake(ALD(55), ALD(45), ALD(60), ALD(10));

        logoFaceL.font = WJFont10;
        logoFaceL.text = [NSString stringWithFormat:@"%@元",order.faceValue];
        self.amountL.textColor = WJYellowColorAmount;
        
        
    } else {

        iconIV.frame = CGRectMake(10, line.bottom + ALD(15), ALD(109), ALD(65));
        
        countL.frame = CGRectMake(nameL.frame.origin.x, nameL.bottom, ALD(80), 22);
        
        logoIV.frame = CGRectMake(ALD(5), (iconIV.height - ALD(21))/2, ALD(21), ALD(21));
        logoBehindLine.frame = CGRectMake(CGRectGetMaxX(logoIV.frame) + ALD(6), (iconIV.height - ALD(20))/2, ALD(0.5), ALD(20));
        
        merNameLabel.frame = CGRectMake(CGRectGetMaxX(logoBehindLine.frame) + ALD(6), CGRectGetMinY(logoIV.frame), ALD(70), ALD(8));

        logoFaceL.frame = CGRectMake(merNameLabel.frame.origin.x, merNameLabel.bottom, ALD(60), ALD(10));

        steamedIV.hidden = YES;
        self.amountL.text = [NSString stringWithFormat:@"￥ %@", order.PayAmount];
        buyAgainButton.hidden = YES;
        logoBehindLine.hidden = NO;
        
        logoIV.layer.cornerRadius = logoIV.frame.size.height / 2.0f;
        logoIV.layer.masksToBounds = YES;
        logoIV.alpha = 0.3f;
        logoIV.backgroundColor = WJColorWhite;
        iconIV.backgroundColor = [WJGlobalVariable cardBackgroundColorByType:(NSInteger)order.ctype];


    }
}


#pragma mark - Action

//- (void)nowPayButtonAction{
//    NSLog(@"立即支付按钮");
//    self.paymentRightNow();
//}

- (void)buyAgainButtonAction
{
    NSLog(@"再次购买");
    self.buyAgain();
}

- (void)Countdown
{
    second --;
    NSString *time = [self TimeformatFromSeconds:second];
    remainTimeL.text = [NSString stringWithFormat:@"%@",time];
    
    if (second <= 0) {
        timeImageView.hidden = YES;
        remainTimeL.hidden = YES;
        [remainTimer invalidate];
        remainTimer = nil;
        
        if ([self.delegate respondsToSelector:@selector(changeOrderStatus)]) {
            [self.delegate changeOrderStatus];
        }
    }
}

-(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}

- (NSDictionary *)colorDic
{
    if (nil == _colorDic) {
        _colorDic = @{@"10":@"blue",@"20":@"green",@"30":@"orange",@"40":@"red"};
    }
    return _colorDic;
}

- (NSAttributedString *)attributedText:(NSString *)text firstLength:(NSInteger)len lastColor:(UIColor*)lastColor{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:text];
    NSDictionary *attributesForFirstWord = @{
                                             NSFontAttributeName : WJFont14,
                                             NSForegroundColorAttributeName : WJColorDarkGray,
                                             };
    
    NSDictionary *attributesForSecondWord = @{
                                              NSFontAttributeName : WJFont14,
                                              NSForegroundColorAttributeName : lastColor,
                                              };
    [result setAttributes:attributesForFirstWord
                    range:NSMakeRange(0, len)];
    [result setAttributes:attributesForSecondWord
                    range:NSMakeRange(len, text.length - len)];
    return [[NSAttributedString alloc] initWithAttributedString:result];
}


@end
