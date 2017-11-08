//
//  TabSwitchView.m
//  LESports
//
//  Created by HuHarry on 15/6/26.
//  Copyright (c) 2015年 LETV. All rights reserved.
//

#import "TabSwitchView.h"

@implementation TabSwitchView{
    NSLayoutConstraint *indicationViewCenterX;
    NSMutableArray *buttonList;
    UIView *indicationView;
    UIButton *selectedBtn;
}


- (id)initWithTitles:(NSArray *)titles andViewControllers:(NSArray *)vcs{
    if (self = [super init]) {
        
//        self.backgroundColor = WJColorViewBg2;
        self.backgroundColor = [UIColor whiteColor];

        
        buttonList = [NSMutableArray arrayWithCapacity:0];

        if (titles.count > 0) {
            int i = 0;
            for (NSString *title in titles) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.translatesAutoresizingMaskIntoConstraints = NO;
                [button setTitle:title forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
                button.titleLabel.font = WJFont14;
                button.tag = 200+i;
                [button addTarget:self action:@selector(chooseMatchStatusAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                [buttonList addObject:button];
                ++i;
            }
            
            selectedBtn = [buttonList firstObject];
            selectedBtn.selected = YES;
            
            indicationView = [[UIView alloc] initForAutoLayout];
            indicationView.backgroundColor = WJColorNavigationBar;
            indicationView.tag = TabSwitchTagIndication;
            [self addSubview:indicationView];
            
            [self subviewsLayout];
        }
        
    }
    return self;
}

- (void)subviewsLayout{
    
    //等宽约束
    for (int i = 0; i < buttonList.count-1; i++) {
        UIButton *firstItem = buttonList[i];
        UIButton *secondItem = buttonList[i+1];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:firstItem
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:secondItem
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0]];
    }
    
    //横向并列约束，竖向约束
    NSString *vVFL = @"|";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i < buttonList.count; ++i) {
        NSString *key = [@"button" stringByAppendingString:[@(i) stringValue]];
        NSString *hVFL = [NSString stringWithFormat:@"V:|[%@]|", key];
        NSDictionary *dictionary  =@{key : buttonList[i]};
        [dic setObject:buttonList[i] forKey:key];
        vVFL = [vVFL stringByAppendingFormat:@"[%@]", key];
        [self VFLToConstraints:hVFL views:dictionary];
    }
    vVFL = [vVFL stringByAppendingString:@"|"];

    [self VFLToConstraints:vVFL views:dic];
    

    [self VFLToConstraints:@"V:[indicationView(2)]|"
                     views:NSDictionaryOfVariableBindings(indicationView)];
    
    indicationViewCenterX = [indicationView constraintCenterXEqualToView:buttonList[0]];
    [self addConstraint:indicationViewCenterX];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:indicationView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:buttonList[0]
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1
                                                      constant:-ALD(80)]];
//    self addConstraint:[indicationView constraint]
    
}

- (void)chooseMatchStatusAction:(UIButton *)btn{
    
    if (!btn.selected) {
        
        CGFloat offX = btn.center.x - selectedBtn.center.x;
        selectedBtn.selected = NO;
        selectedBtn = btn;
        btn.selected = YES;

        
        [UIView animateWithDuration:0.3 animations:^{
            indicationViewCenterX.constant += offX;
            [indicationView layoutIfNeeded];
        }];
        
        
        if ([self.delegate respondsToSelector:@selector(tabSwitchAction:)]) {
            [self.delegate tabSwitchAction:@(btn.tag-200)];
        }
        
    }
}


- (void)selectedIndex:(NSInteger)index{
    
    UIButton *btn = (UIButton *)[self viewWithTag:index+200];
    
    CGFloat offX = btn.center.x - selectedBtn.center.x;
    selectedBtn.selected = NO;
    selectedBtn = btn;
    btn.selected = YES;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        indicationViewCenterX.constant += offX;
        [indicationView layoutIfNeeded];
    }];

}


- (void)setSelectedColor:(UIColor *)selectedColor{
    
    _selectedColor = selectedColor;
    
    for (UIButton *btn in buttonList) {
        [btn setTitleColor:WJColorNavigationBar forState:UIControlStateSelected];
    }
    
}
@end
