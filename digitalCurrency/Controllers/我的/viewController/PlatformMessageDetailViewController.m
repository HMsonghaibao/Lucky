//
//  PlatformMessageDetailViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/3/21.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PlatformMessageDetailViewController.h"

@interface PlatformMessageDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation PlatformMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navtitle;
//    self.title = LocalizationKey(@"notice");
    [self.view addSubview:[self webView]];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self setNavigationControllerStyle];
    
}

-(void)setType:(NSString *)type{
    _type=type;
}


-(UIWebView *)webView{
    if (!_webView) {
        
        
        if (self.navigationController.navigationBar.isTranslucent) {
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, kWindowW, kWindowH-NEW_NavHeight)];
        }else{
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-NEW_NavHeight)];
        }
        
        
//        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, kWindowW, kWindowH-NEW_NavHeight)];
        _webView.delegate = self;
        [_webView scalesPageToFit];
        if ([self.type isEqualToString:@"1"]) {
            [_webView loadHTMLString:self.content baseURL:nil];
        }else{
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.content]]];
        }
        
        _webView.opaque = NO;
        _webView.backgroundColor = mainColor;
    }
    return _webView;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [EasyShowLodingView hidenLoding];
    
    if ([self.type isEqualToString:@"1"]) {
        NSString *js=@"var script = document.createElement('script');"
        "script.type = 'text/javascript';"
        "script.text = \"function ResizeImages() { "
        "var myimg,oldwidth;"
        "var maxwidth = %f;"
        "for(i=0;i <document.images.length;i++){"
        "myimg = document.images[i];"
        "if(myimg.width > maxwidth){"
        "oldwidth = myimg.width;"
        "myimg.width = %f;"
        "}"
        "}"
        "}\";"
        "document.getElementsByTagName('head')[0].appendChild(script);";
        js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-20];
        [webView stringByEvaluatingJavaScriptFromString:js];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#333333'"];
    }else{
        
    }
    
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [EasyShowLodingView hidenLoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
