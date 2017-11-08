//
//  WJWebTableViewCell.m
//  WanJiCard
//
//  Created by 林有亮 on 16/8/22.
//  Copyright © 2016年 WJIKA. All rights reserved.
//

#import "WJWebTableViewCell.h"

@interface WJWebTableViewCell ()<UIWebViewDelegate>
{
    UIWebView   * cellWebView;
    CGFloat     htmlHeight;
    BOOL        isRequest;
    
}

@end

@implementation WJWebTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        cellWebView = [[UIWebView alloc] init];
        cellWebView.delegate = self;
        cellWebView.scrollView.bounces = NO;
        cellWebView.scrollView.showsHorizontalScrollIndicator = NO;
        cellWebView.scrollView.showsVerticalScrollIndicator = NO;

        cellWebView.scrollView.scrollEnabled = NO;
        [cellWebView sizeToFit];
        
        [self.contentView addSubview:cellWebView];
    }
    return self;
}

- (void)configWithURL:(NSString *)urlstr
{
    [cellWebView loadHTMLString:urlstr baseURL:nil];
    if (isRequest == YES) {
        return;
    }
    isRequest = YES;
    
//    urlstr = @"http://bbs.colg.cn/thread-4541391-1-1.html";
    
    NSURL *url = [NSURL URLWithString:urlstr];
    [cellWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    isRequest = NO;
    //获取页面高度（像素）
//    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//    float clientheight = [clientheight_str floatValue];
//    //设置到WebView上
    webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 5);
//    获取WebView最佳尺寸（点）
    CGSize frame = [webView sizeThatFits:webView.frame.size];
//    //获取内容实际高度（像素）
//    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
//    float height = [height_str floatValue];
////    //内容实际高度（像素）* 点和像素的比
//    height = height * frame.height / clientheight;
//    float height = clientheight;
    //再次设置WebView高度（点）
    [self reloadByHeight:frame.height];
    webView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, frame.height);
    webView.backgroundColor = [UIColor blueColor];
}
    
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)reloadByHeight:(CGFloat)height
{
    if ([self.delegate respondsToSelector:@selector(reloadByHeight:)])
    {
        [self.delegate reloadByHeight:height];
    }
}



- (CGFloat)currenCellHeight
{
    return htmlHeight;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
