//
//  ViewController.m
//  myapp0520
//
//  Created by 渡部 可鈴 on 2018/05/18.
//  Copyright © 2018年 watabe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reloadButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.reloadButton setImage:[UIImage imageNamed:@"reloadButton.png"] forState:UIControlStateNormal];
    NSLayoutConstraint * widthConstraint = [self.reloadButton.widthAnchor constraintEqualToConstant:40];
    NSLayoutConstraint * HeightConstraint =[self.reloadButton.heightAnchor constraintEqualToConstant:40];
    [widthConstraint setActive:YES];
    [HeightConstraint setActive:YES];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:[WKWebViewConfiguration new]];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}
- (IBAction)tapBackButton:(id)sender {
    [self.webView goBack];
}
- (IBAction)tapForwardButton:(id)sender {
    [self.webView goForward];
}
- (IBAction)tapStopButton:(id)sender {
    [self.webView stopLoading];
}
- (IBAction)tapReloadButton:(id)sender {
    [self.webView reload];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
