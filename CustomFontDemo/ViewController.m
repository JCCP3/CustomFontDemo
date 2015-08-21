//
//  ViewController.m
//  CustomFontDemo
//
//  Created by JC_CP3 on 15/8/20.
//  Copyright (c) 2015年 JC_CP3. All rights reserved.
//

#import "ViewController.h"
#import "FontName.h"
#import <CoreText/CoreText.h>
#import "AppDelegate.h"

#define APPDELEGAET (AppDelegate *)[UIApplication sharedApplication].delegate

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *currentTableView;
    NSArray *aryFontNameData;
}

@property (strong, nonatomic) NSString *errorMessage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    currentTableView.delegate = self;
    currentTableView.dataSource = self;
    currentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:currentTableView];
    
    [self createFont];
    [self printAllFonts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self registerAllFont];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createFont
{
    FontName *fontName = [[FontName alloc] init];
    fontName.fontName = @"DFWaWaSC-W51";
    fontName.fontChineseName = @"娃娃体";
    fontName.isFontUse = NO;
    
    FontName *fontName1 = [[FontName alloc] init];
    fontName1.fontName = @"STYuanti-SC-Regular";
    fontName1.fontChineseName = @"圆体";
    fontName1.isFontUse = NO;
    
    FontName *fontName2 = [[FontName alloc] init];
    fontName2.fontName = @"STKaiti-SC-Regular";
    fontName2.fontChineseName = @"楷体";
    fontName2.isFontUse = NO;
    
    FontName *fontName3 = [[FontName alloc] init];
    fontName3.fontName = @"STSongti-SC-Regular";
    fontName3.fontChineseName = @"宋体";
    fontName3.isFontUse = NO;
    
    FontName *fontName4 = [[FontName alloc] init];
    fontName4.fontName = @"STXihei1111";
    fontName4.fontChineseName = @"黑体";
    fontName4.isFontUse = NO;
    
    FontName *fontName5 = [[FontName alloc] init];
    fontName5.fontName = @"STKaiti11111";
    fontName5.fontChineseName = @"华文楷体11111";
    fontName5.isFontUse = NO;
    
    FontName *fontName6 = [[FontName alloc] init];
    fontName6.fontName = @"STSong";
    fontName6.fontChineseName = @"华文宋体";
    fontName6.isFontUse = NO;
    
    FontName *fontName7 = [[FontName alloc] init];
    fontName7.fontName = @"STXihei";
    fontName7.fontChineseName = @"华文细黑";
    fontName7.isFontUse = NO;
    
    FontName *fontName8 = [[FontName alloc] init];
    fontName8.fontName = @"STFangsong";
    fontName8.fontChineseName = @"华文仿宋";
    fontName8.isFontUse = NO;
    
    FontName *fontName9 = [[FontName alloc] init];
    fontName9.fontName = @"HannotateSC-W5";
    fontName9.fontChineseName = @"手扎体";
    fontName9.isFontUse = NO;
   
    
    aryFontNameData = @[fontName,fontName1,fontName2,fontName3,fontName4,fontName5,fontName6,fontName7,fontName8,fontName9];
}

#pragma mark - 判断字体是否安装过
- (BOOL)isFontDownLoaded:(NSString *)fontName
{
    UIFont* aFont = [UIFont fontWithName:fontName size:12];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 异步下载字体
- (void)asynchronouslySetFontName:(FontName *)name
{
    if ([self isFontDownLoaded:name.fontName]) {
        return;
    }

    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:name.fontName, kCTFontNameAttribute, nil];

    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                
                UITableViewCell *cell = [currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[aryFontNameData indexOfObject:name] inSection:0]];
                for (UIView *subView in cell.subviews) {
                    
                    if ([subView isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)subView;
                        btn.hidden = YES;
                    }
                    
                    if ([subView isKindOfClass:[UIProgressView class]]) {
                        UIProgressView *progressView = (UIProgressView *)subView;
                        progressView.hidden = NO;
                    }
                }
                
                NSLog(@"Begin Matching");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                
                FontName *font = [aryFontNameData objectAtIndex:[aryFontNameData indexOfObject:name]];
                font.isFontUse = NO;
                [currentTableView reloadData];
                
                UITableViewCell *cell = [currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[aryFontNameData indexOfObject:name] inSection:0]];
                for (UIView *subView in cell.subviews) {
                    
                    if ([subView isKindOfClass:[UIButton class]]) {
                        UIButton *btn = (UIButton *)subView;
                        btn.hidden = NO;
                    }
                    
                    if ([subView isKindOfClass:[UIProgressView class]]) {
                        UIProgressView *progressView = (UIProgressView *)subView;
                        progressView.hidden = YES;
                    }
                }
                
                CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)name.fontName, 0., NULL);
                CFStringRef fontURL = CTFontCopyAttribute(fontRef, kCTFontURLAttribute);
                
                [self registerFont:(__bridge NSString *)(fontURL) withFontName:name.fontName];
               
                CFRelease(fontURL);
                CFRelease(fontRef);
                
                if (!errorDuringDownload) {
                    NSLog(@"%@ downloaded", name.fontName);
                }
            });
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Begin Downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                // Remove the progress bar
                NSLog(@"Finish downloading");
            });
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            dispatch_async( dispatch_get_main_queue(), ^ {
                UITableViewCell *cell = [currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[aryFontNameData indexOfObject:name] inSection:0]];
                cell.textLabel.font = [UIFont fontWithName:name.fontName size:24.];
                for (UIView *subView in cell.subviews) {
                    
                    if ([subView isKindOfClass:[UIProgressView class]]) {
                        UIProgressView *progressView = (UIProgressView *)subView;
                        progressView.hidden = NO;
                        [progressView setProgress:progressValue / 100.0 animated:YES];
                    }
                }
                
                NSLog(@"Downloading %.0f%% complete", progressValue);
            });
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
          
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
            if (error != nil) {
                _errorMessage = [error description];
            } else {
                _errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
            }
         
            errorDuringDownload = YES;
            
            dispatch_async( dispatch_get_main_queue(), ^ {
                NSLog(@"Download error: %@", _errorMessage);
            });
        }
        
        return (bool)YES;
    });
    
}


#pragma mark - 应用启动注册所有字体
- (void)registerAllFont
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    
    for (FontName *name in aryFontNameData) {
        NSString *currentDocumentsDirectory = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"assets%@",name.fontName]];
        NSFileManager* fm=[NSFileManager defaultManager];
        if ([fm fileExistsAtPath:currentDocumentsDirectory]) {
            NSData *data = [fm contentsAtPath:currentDocumentsDirectory];
            if (data) {
                [self registerFont:currentDocumentsDirectory withFontName:name.fontName];
            }
        }
    }
}

#pragma mark - 注册指定font
- (void)registerFont:(NSString *)fontPath withFontName:(NSString *)name
{
    NSData *dynamicFontData = [NSData dataWithContentsOfFile:fontPath];
    if (!dynamicFontData)
    {
        return;
    }
    CFErrorRef error;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)dynamicFontData);
    CGFontRef font = CGFontCreateWithDataProvider(providerRef);
    if (! CTFontManagerRegisterGraphicsFont(font, &error))
    {
        //注册失败
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(providerRef);
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString *localFontPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"assets%@",name]];
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    if (![fm fileExistsAtPath:localFontPath]) {
        if ([dynamicFontData writeToFile:localFontPath atomically:YES]) {
        }
    }
    
    
    [self printAllFonts];
    
}

- (void)printAllFonts
{
    NSArray *fontFamilies = [UIFont familyNames];
    
    for (NSString *fontFamily in fontFamilies)
    {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamily];
        NSLog (@"%@: %@", fontFamily, fontNames);
    }
}


#pragma mark - UITableViewDelegate & UITableVIewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryFontNameData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-15-55, 15, 55, 30)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 16;
        [cell addSubview:btn];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), 15, CGRectGetWidth(btn.bounds),30)];
        progressView.frame = CGRectMake(CGRectGetMinX(btn.frame), 30-CGRectGetHeight(progressView.bounds)/2, CGRectGetWidth(btn.bounds), 2);
        progressView.backgroundColor = [UIColor clearColor];
        progressView.trackTintColor=[UIColor lightGrayColor];
        [progressView setProgress:0.2];
        progressView.hidden = YES;
        [cell addSubview:progressView];
    }
    
    FontName *fontName = [aryFontNameData objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        //娃娃体
        fontName.fontName = @"DFWaWaSC-W5";
    } else if (indexPath.row == 1) {
        fontName.fontName = @"STYuanti-SC-Bold";
    } else if (indexPath.row == 2) {
        fontName.fontName = @"STKaiti-SC-Black";
    } else if (indexPath.row == 3){
        fontName.fontName = @"STSongti-SC-Black";
    } else if (indexPath.row == 4){
        fontName.fontName = @"STHeitiSC-Light";
    }
    
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            if ([self isFontDownLoaded:fontName.fontName]) {
                if (fontName.isFontUse) {
                    [APPDELEGAET setFontName:fontName.fontName];
                    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    btn.layer.borderWidth = 0;
                    [btn setTitle:@"使用中" forState:UIControlStateNormal];
                } else {
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    btn.layer.borderWidth = 1;
                    [btn setTitle:@"使用" forState:UIControlStateNormal];
                }
            } else {
                btn.titleLabel.textColor = [UIColor blackColor];
                btn.layer.borderWidth = 1;
                [btn setTitle:@"下载" forState:UIControlStateNormal];
            }
            btn.tag = indexPath.row + 1;
            [btn addTarget:self action:@selector(onClickDownLoad:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    cell.textLabel.text = fontName.fontChineseName;
    
    cell.textLabel.font = [UIFont fontWithName:fontName.fontName size:24.f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 点击下载字体
- (void)onClickDownLoad:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag - 1;
    FontName *fontName = [aryFontNameData objectAtIndex:index];
    if ([self isFontDownLoaded:fontName.fontName]) {
        if (!fontName.isFontUse) {
         //使用
            for (FontName *name in aryFontNameData) {
                if (name == fontName) {
                    name.isFontUse = YES;
                } else {
                    name.isFontUse = NO;
                }
            }
            [currentTableView reloadData];
        }
    } else {
        [self asynchronouslySetFontName:fontName];
    }
}



@end
