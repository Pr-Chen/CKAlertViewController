//
//  CKAlertViewController.h
//  自定义警告框
//
//  Created by 陈凯 on 16/8/24.
//  Copyright © 2016年 陈凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKAlertAction : NSObject

@property (nonatomic, readonly) NSString *title;

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler;

@end


@interface CKAlertViewController : UIViewController

@property (nonatomic, readonly) NSArray<CKAlertAction *> *actions;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
- (void)addAction:(CKAlertAction *)action;

@end
