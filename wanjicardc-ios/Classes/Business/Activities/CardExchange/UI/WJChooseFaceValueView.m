//
//  WJChooseFaceValueView.m
//  WanJiCard
//
//  Created by 林有亮 on 16/11/30.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJChooseFaceValueView.h"
#import "WJCardExchangeModel.h"
#import "WJFaceValueModel.h"
#import "WJChooseViewCell.h"

@interface WJChooseFaceValueView()
{
    UIView * bgWhiteView;
    UIView * cardLogoView;
    UIView * cardView;
    UIImageView * logoImageView;
    UIButton    * closeButton;
    
    UILabel * cardNameLabel;
    UILabel * valueLabel;
    UILabel * desLabel;
    
    UIView  * line;
    UILabel * chooseValueLabel;
    
    UIView  * imageListView;
    UIButton   * changeButton;
    
    
    NSArray * listArray;
}



@end

@implementation WJChooseFaceValueView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        selectNum = 0;
        
        listArray = [NSArray array];
//        UIView * bgView = [[UIView alloc] initWithFrame:frame];
        self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        bgWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        bgWhiteView.backgroundColor = WJColorWhite;
        
        cardLogoView = [[UIView alloc] initWithFrame:CGRectMake(ALD(12), - ALD(23), ALD(140), ALD(100))];
        cardLogoView.layer.cornerRadius = 5;
        cardLogoView.layer.borderColor = [[WJUtilityMethod colorWithHexColorString:@"e5e6e7"] CGColor];
        cardLogoView.layer.borderWidth = 1;
        cardLogoView.backgroundColor = WJColorWhite;
        
        cardView = [[UIView alloc] initWithFrame:CGRectMake(ALD(14), ALD(20), ALD(140) - ALD(28), ALD(60))];
        [cardView setFrame:CGRectMake(ALD(20), ALD(20), ALD(100), ALD(60))];
        cardView.layer.cornerRadius = 5;
        
        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ALD(28), ALD(30), ALD(140) - ALD(28) - ALD(28), ALD(40))];
//        logoImageView.backgroundColor = [WJUtilityMethod randomColor];
        
        [cardLogoView addSubview:cardView];
        [cardLogoView addSubview:logoImageView];
        
        cardNameLabel = [[UILabel alloc] init];
        cardNameLabel.font = WJFont15;
        cardNameLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        
        valueLabel = [[UILabel alloc] init];
        valueLabel.font = WJFont17;
        valueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"d9a109"];
        
        desLabel = [[UILabel alloc] init];
        desLabel.font = WJFont12;
        desLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"9099a6"];
        
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"closeButton_press"] forState:UIControlStateSelected];
        [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        line = [[UIView alloc] init];
        line.backgroundColor = WJColorCardGray;
        
        chooseValueLabel = [[UILabel alloc] init];
        chooseValueLabel.font = WJFont14;
        chooseValueLabel.text = @"选择面值";
        chooseValueLabel.textColor = [WJUtilityMethod colorWithHexColorString:@"2f333b"];
        
        imageListView = [[UIView alloc] init];
        
        changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        changeButton.backgroundColor = WJColorCardBlue;
        [changeButton addTarget:self action:@selector(changeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [bgWhiteView addSubview:cardLogoView];
        [bgWhiteView addSubview:cardNameLabel];
        [bgWhiteView addSubview:valueLabel];
        [bgWhiteView addSubview:desLabel];
        
        [bgWhiteView addSubview:changeButton];
        [bgWhiteView addSubview:line];
        [bgWhiteView addSubview:closeButton];
        [bgWhiteView addSubview:chooseValueLabel];
        [bgWhiteView addSubview:imageListView];
      
        [self addSubview:bgWhiteView];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}

- (void)refreshWithDictionary:(WJCardExchangeModel *)model listFaceValue:(NSArray *)cardArray
{
    CGFloat height = ALD(70) * ([cardArray count]/3 + ((([cardArray count]%3) == 0)? 0 : 1));
//    CGFloat bgHeight = ALD(101) + ALD(42) + height + ALD(60);
//    CGFloat top =  kScreenHeight - bgHeight;
    NSLog(@"%f",height);

    listArray = cardArray;
    
    cardView.backgroundColor = [WJUtilityMethod colorWithHexColorString:model.cardColorValue];

    [logoImageView sd_setImageWithURL:[NSURL URLWithString:model.cardLogolUrl] placeholderImage:[UIImage imageNamed:@""]];
    
    [line setFrame:CGRectMake(0, cardLogoView.bottom + ALD(20), kScreenWidth, 1)];
    
    [closeButton setFrame:CGRectMake(kScreenWidth - ALD(32), self.y + ALD(12), ALD(20), ALD(20))];
    
    [chooseValueLabel setFrame:CGRectMake(ALD(12), line.y, kScreenWidth - ALD(24), ALD(42))];    
    
    [imageListView setFrame:CGRectMake(0, chooseValueLabel.bottom, kScreenWidth, height)];
    
    for (UIView * view in [imageListView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < [cardArray count]; i++) {
        
        WJFaceValueModel * model = [cardArray objectAtIndex:i];

        WJChooseViewCell * cell = [[WJChooseViewCell alloc] initWithPoint:CGPointMake(ALD(12) + i%3 * (ALD(121)),  i/3 * ALD(70)) value:model.faceValue des:model.sellValue];
        [imageListView addSubview:cell];
        cell.tag = 10000 + i;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction:)];
        [cell addGestureRecognizer:tap];
    }

    [changeButton setFrame:CGRectMake(0, CGRectGetMaxY(imageListView.frame) + ALD(15) , kScreenWidth, ALD(48))];
    
    [cardNameLabel setFrame:CGRectMake(cardLogoView.right + ALD(20), ALD(20), kScreenWidth - ALD(40) - cardLogoView.right, ALD(20))];
    cardNameLabel.text = model.cardName;
    
    [bgWhiteView setFrame:CGRectMake(0, self.height - ALD(201) - height, kScreenWidth, ALD(101) + ALD(52) + height + ALD(48))];

    [self selectCellIndex];
    
}

- (void)closeAction
{
    self.hidden = YES;
}

- (void)changeButtonAction
{
    WJFaceValueModel * model = [listArray objectAtIndex:selectNum];
    if ([self.delegate respondsToSelector:@selector(selectModel:)]) {
        [self.delegate selectModel:model];
    }
}

- (void)selectCellIndex
{
    for (UIView * view in [imageListView subviews]) {
        
        if ([view isKindOfClass:[WJChooseViewCell class]]) {
           WJChooseViewCell * cell = (WJChooseViewCell *)view;
            if ((cell.tag - 10000) == selectNum)
            {
                cell.selected = YES;
                WJFaceValueModel * model = [listArray objectAtIndex:selectNum];
                
                valueLabel.text = [NSString stringWithFormat:@"￥%@",model.faceValue];
                desLabel.text = [NSString stringWithFormat:@"可兑换%@个包子",model.sellValue];
                
                [valueLabel sizeToFit];
                [valueLabel setFrame:CGRectMake(cardLogoView.right + ALD(20), cardNameLabel.bottom +ALD(5), valueLabel.width, ALD(20))];
                
                [desLabel setFrame:CGRectMake(valueLabel.right + ALD(5), valueLabel.y, kScreenWidth - valueLabel.right - ALD(22), ALD(20))];
                
            } else {
                cell.selected = NO;
            }
        }
    }
}


- (void)cellTapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"%@",tap.view);
    selectNum = tap.view.tag - 10000;
    [self selectCellIndex];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
