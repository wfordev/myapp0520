//
//  ViewController.h
//  myapp0520
//
//  Created by 渡部 可鈴 on 2018/05/18.
//  Copyright © 2018年 watabe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>
@property NSString *urlString;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property WKWebView *webView;


@end

