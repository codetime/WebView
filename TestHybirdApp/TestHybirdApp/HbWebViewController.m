//
//  HbWebViewController.m
//  TestHybirdApp
//
//  Created by Rafferty on 15/7/21.
//  Copyright (c) 2015年 PowerVision. All rights reserved.
//

#import "HbWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface HbWebViewController()<UIWebViewDelegate>
{
    UIWebView       *_webView;
  }
@end
@implementation HbWebViewController

-(void)viewDidLoad
{
  

  
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onleft)];//设置navigationbar左边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onright)];//设置navigationbar右边按钮
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];//设置navigationbar上左右按钮字体颜色
    
    
    self.navigationController.navigationItem.leftBarButtonItem.title=@"Test";
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.backgroundColor=[UIColor clearColor];
    _webView.delegate=self;
    
    [self.view addSubview:_webView];
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"Index.html"]];
   
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Index" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
    
    JSContext *context=[_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"Jakilllog"]=^()
    {
        NSLog(@"+++++++Begin+++++++ Log++++++");
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"%@",jsVal);
        
        }
        JSValue *this=[JSContext currentThis];
        NSLog(@"%@",this);
        NSLog(@"-----end log-------");
    };
    context.exceptionHandler=^(JSContext *ctx,JSValue *exception)
    {
        NSLog(@"%@",exception);
    };
  JSValue *result=    [context evaluateScript:@"1+3+3"];
    NSLog(@"%lf",[result toDouble]);
    
    
    context[@"sum"]=^(int a,int b)
    {
        return a+b;
    };
    result=[context evaluateScript:@"sum(1,2)"];
    NSLog(@"%f",[result toDouble]);

    
    [context evaluateScript:@"var userid='1232323';"];
    }


-(void)onleft
{
    NSLog(@"%@",@"left");
//    
//    NSString *location = [[_webView Win] valueForKeyPath:@"location.href"];
//document.title
    //NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    

    
    
    [_webView goBack];
//     NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.vizsky.com"]];
//    [_webView loadRequest:request];
   
}
-(void)onright
{
     NSLog(@"%@",@"right");
//    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wwww.qq.com"]];
      //  [_webView goForward];
    NSString *str=[_webView stringByEvaluatingJavaScriptFromString:@"postStr();"];
    NSLog(@"JS 返回值%@",str);

  NSString *test=[_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"order('%@')",@"12344"]];
    NSLog(@"JS 返回值%@",test);
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
//    NSLog(@"%@",url);
//    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSLog(@"%@",title);
//
//    self.navigationItem.title=title;
    NSString *urlString=[[request URL] absoluteString];
    NSLog(@"%@",urlString);
    NSArray *urlComps=[urlString componentsSeparatedByString:@"://"];
    if([urlComps count]&&[[urlComps objectAtIndex:0]isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter=[(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr=[arrFucnameAndParameter objectAtIndex:0];
        if(1==[arrFucnameAndParameter count])
        {
            if([funcStr isEqualToString:@"doFunc1"])
            {
                NSLog(@"doFunc1");
            }
        }else
        {
            if([funcStr isEqualToString:@"printLog1:Log2:"])
            {
                
            }
        }
    }
      NSURL *url = [request URL];
    
    if([[url scheme] isEqualToString:@"devzeng"]) {
        //处理JavaScript和Objective-C交互
        if([[url host] isEqualToString:@"login"])
        {
            //获取URL上面的参数
//            NSDictionary *params = [self getParams:[url query]];
//            BOOL status = [self login:[params objectForKey:@"name"] password:[params objectForKey:@"password"]];
//            if(status)
//            {
//                //调用JS回调
//                [webView stringByEvaluatingJavaScriptFromString:@"alert('登录成功!')"];
//            }
//            else
//            {
//                [webView stringByEvaluatingJavaScriptFromString:@"alert('登录失败!')"];
//            }
        }
        return NO;
    }
    NSLog(@"%@",url);
    
    NSArray *strarray=[urlString componentsSeparatedByString:@"://"];
    NSLog(@"%@",[strarray objectAtIndex:0]);
    
    if ([[strarray objectAtIndex:0]isEqualToString:@"ios"]) {
        
        NSLog(@"%@",[strarray objectAtIndex:1]);
    }
    if([[url scheme] isEqualToString:@"ios"])
    {
        
        
        NSLog(@"%@",url);
    }
    return YES;
}


@end
