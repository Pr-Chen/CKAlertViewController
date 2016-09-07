//
//  ViewController.m
//  CKCustomAlertViewDemo
//
//  Created by 陈凯 on 16/9/7.
//  Copyright © 2016年 陈凯. All rights reserved.
//

#import "ViewController.h"
#import "CKAlertViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button1.layer.cornerRadius = 22.5;
    self.button1.layer.borderColor = [UIColor colorWithRed:1.00 green:0.03 blue:0.29 alpha:1.00].CGColor;
    self.button1.layer.borderWidth = 1;
    
    self.button2.layer.cornerRadius = 22.5;
    self.button2.layer.borderColor = [UIColor colorWithRed:0.235 green:0.709 blue:1 alpha:1.00].CGColor;
    self.button2.layer.borderWidth = 1;
    
    self.button3.layer.cornerRadius = 22.5;
    self.button3.layer.borderColor = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1.00].CGColor;
    self.button3.layer.borderWidth = 1;
}

- (IBAction)clickShowAlertButton1:(UIButton *)sender {
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"Access Microphone?" message:@"Are you sure that you want to allow this app to access your microphone?" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (IBAction)clickShowAlertButton2:(UIButton *)sender {
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"系统更新" message:@"iOS88.88现已准备好了, 解决了好几万个重大bug,是否更新?" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"不要更新" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *updateNow = [CKAlertAction actionWithTitle:@"立即更新" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *updateLater = [CKAlertAction actionWithTitle:@"稍后更新" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:updateNow];
    [alertVC addAction:updateLater];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

- (IBAction)clickShowAlertButton3:(UIButton *)sender {
    
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"发现新版本" message:@"1. 日夜赶工,修复了一堆bug.\n2. 跟着产品经理改来改去,增加了很多功能.\n3. 貌似性能提升了那么一点点." ];
    alertVC.messageAlignment = NSTextAlignmentLeft;
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我知道了" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *update = [CKAlertAction actionWithTitle:@"立即更新" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:update];
    
    [self presentViewController:alertVC animated:NO completion:nil];
}

@end
