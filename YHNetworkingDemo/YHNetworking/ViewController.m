//
//  ViewController.m
//  YHNetworking
//
//  Created by apple on 2018/1/2.
//  Copyright © 2018年 玉河川. All rights reserved.
//

#import "ViewController.h"
#import "YHFileDownloader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self brokenPiontTest];
}

- (void)brokenPiontTest {
    /*
     开始文件下载在临时路径tmp下面  下载完成后会移动到 你所传入的路径 默认是Documents
     */
    
    YHFileDownloader *downloader = [[YHFileDownloader alloc]init];
    NSString *imageUrl = @"http://cochat.cn/file/0YdgOOsdDBa9ppbVzuBiaGZ.jpg";
    //@"http://www.8pmedu.com/files/system/2017/06-13/225247f9edb5180454.jpg";
    [downloader downloadFile:imageUrl progress:^(NSUInteger total, NSUInteger completed) {
        NSLog(@"total:%lu completed:%lu",(unsigned long)total,(unsigned long)completed);
    } success:^(NSURLResponse * _Nullable response, NSURL * _Nullable filePath) {
        NSLog(@"%@",[filePath absoluteString]);
    } failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",error.userInfo);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
