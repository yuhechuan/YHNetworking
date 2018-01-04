# YHNetworking

[![Travis](https://img.shields.io/travis/yuhechuan/YHNetworking.svg)](https://travis-ci.org/yuhechuan/YHNetworking)
[![CocoaPods](https://img.shields.io/cocoapods/v/YHNetworking.svg)](http://cocoadocs.org/docsets/YHNetworking)
[![CocoaPods](https://img.shields.io/cocoapods/l/YHNetworking.svg)](https://raw.githubusercontent.com/iTofu/YHNetworking/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/YHNetworking.svg)](http://cocoadocs.org/docsets/YHNetworking)
[![Laguage](https://img.shields.io/badge/language-ObjC%20%26%20Swift-orange.svg)](https://github.com/yuhechuan/YHNetworking)
[![CocoaPods](https://img.shields.io/cocoapods/dt/YHNetworking.svg)](https://cocoapods.org/pods/YHNetworking)
[![简书](https://img.shields.io/badge/blog-简书-brightgreen.svg)](http://www.jianshu.com/u/7c43d8cb3cff)
[![GitHub stars](https://img.shields.io/github/stars/yuhechuan/YHNetworking.svg?style=social&label=Star)](https://github.com/yuhechuan/YHNetworking)

☀️文件的断点下载及上传功能,并返回了数据的进度。

```
May you spend your life in the way you like,this sentence is so beautiful.

"愿你以自己喜欢的方式度过一生"，这句话太美了。
```

欢迎访问我的简书：http://www.jianshu.com/u/7c43d8cb3cff

## 目录 Contents

* [环境 Requirements](#环境-requirements)
* [介绍 Introduction](#介绍-introduction)
* [使用 Usage](#使用-usage)
* [版本 ChangeLog](#版本-changelog)
* [提示 Tips](#提示-tips)
* [鸣谢 Thanks](#鸣谢-thanks)
* [联系 Support](#联系-support)
* [许可 License](#许可-license)



## 环境 Requirements

* iOS 8.0+
* Xcode 9.0+
* Objective-C


## 介绍 Introduction

☀️ 文件的断点下载及上传功能,并返回了数据的进度。

* iOS 8.0 +，Demo 需要 xcode 9.0+环境运行。

* 开始文件下载在临时路径tmp下面,下载完成后会移动到 你所传入的路径 默认是Documents。

> 💬 **告示**
>
>  欢迎大家使用,有问题请及时联系我.
>
> 直接 [PR](https://github.com/yuhechuan/YHNetworking/pulls) 或者发我邮箱 `yuhechuan@ruaho.com` 都可！




## 使用 Usage

* 两种导入方法：

* 方法一：[CocoaPods](https://cocoapods.org/)：`pod 'YHCNetworking'`

* 方法二：直接把 sources 文件夹（在 Demo 中）拖拽到你的项目中

* 在相应位置导入头文件：`#import "YHNetworking.h"`

* 使用下列任意方法都可以：
1. 直接创建，调用下载方法.
```
/*
开始文件下载在临时路径tmp下面  下载完成后会移动到 你所传入的路径 默认是Documents
*/

YHFileDownloader *downloader = [[YHFileDownloader alloc]init];
NSString *imageUrl = @"http://www.8pmedu.com/files/system/2017/06-13/225247f9edb5180454.jpg";
[downloader downloadFile:imageUrl progress:^(NSUInteger total, NSUInteger completed) {
NSLog(@"total:%lu completed:%lu",(unsigned long)total,(unsigned long)completed);
} success:^(NSURLResponse * _Nullable response, NSURL * _Nullable filePath) {
NSLog(@"%@",[filePath absoluteString]);
} failure:^(NSURLResponse * _Nullable response, NSError * _Nullable error) {
NSLog(@"%@",error.userInfo);
}];

```

## 版本 ChangeLog

* 首次提交!


## 提示 Tips

* `isBrokenPointLoading`表示是否启用断点下载功能.
* `destinationPath` 文件下载完成的储存文件夹路径,会根据url进行Md5加密,作为文件的名字。

## 鸣谢 Thanks

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)

* 海纳百川，有容乃大。感谢开源社区和众攻城狮的支持！感谢众多 [Issues](https://github.com/yuhechuan/YHNetworking/issues) 和 [PR](https://github.com/yuhechuan/YHNetworking/pulls)！更期待你的 [PR](https://github.com/yuhechuan/YHNetworking/pulls)！



## 联系 Support

* 有疑问或建议请 [New Issue](https://github.com/yuhechuan/YHNetworking/issues/new)，谢谢 :)

* Mail: `yuhechuan@ruaho.com`

* 简书: http://www.jianshu.com/u/7c43d8cb3cff


## 许可 License

YHNetworking is released under the [MIT License](https://github.com/yuhechuan/YHNetworking/blob/master/LICENSE).






