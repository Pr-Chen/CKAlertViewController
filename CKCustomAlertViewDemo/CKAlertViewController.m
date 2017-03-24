//
//  CKAlertViewController.m
//  自定义警告框
//
//  Created by 陈凯 on 16/8/24.
//  Copyright © 2016年 陈凯. All rights reserved.
//

#import "CKAlertViewController.h"

@interface CKHighLightButton : UIButton

@property (strong, nonatomic) UIColor *highlightedColor;

@end

@implementation CKHighLightButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = self.highlightedColor;
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.backgroundColor = nil;
        });
    }
}

@end

#define kThemeColor [UIColor colorWithRed:94/255.0 green:96/255.0 blue:102/255.0 alpha:1]

@interface CKAlertAction ()

@property (copy, nonatomic) void(^actionHandler)(CKAlertAction *action);

@end

@implementation CKAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(CKAlertAction *action))handler {
    CKAlertAction *instance = [CKAlertAction new];
    instance -> _title = title;
    instance.actionHandler = handler;
    return instance;
}

@end


@interface CKAlertViewController ()
{
    UIView *_shadowView;
    UIView *_contentView;
    
    UIEdgeInsets _contentMargin;
    CGFloat _contentViewWidth;
    CGFloat _buttonHeight;
    
    BOOL _firstDisplay;
}

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) NSMutableArray *mutableActions;
@end

@implementation CKAlertViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    
    CKAlertViewController *instance = [CKAlertViewController new];
    instance.title = title;
    instance.message = message;
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        [self defaultSetting];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建对话框
    [self creatShadowView];
    [self creatContentView];
    
    [self creatAllButtons];
    [self creatAllSeparatorLine];
    
    self.titleLabel.text = self.title;
    self.messageLabel.text = self.message;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //更新标题的frame
    [self updateTitleLabelFrame];
    
    //更新message的frame
    [self updateMessageLabelFrame];
    
    //更新按钮的frame
    [self updateAllButtonsFrame];
    
    //更新分割线的frame
    [self updateAllSeparatorLineFrame];
    
    //更新弹出框的frame
    [self updateShadowAndContentViewFrame];
    
    //显示弹出动画
    [self showAppearAnimation];
}

- (void)defaultSetting {
    
    _contentMargin = UIEdgeInsetsMake(25, 20, 0, 20);
    _contentViewWidth = 285;
    _buttonHeight = 45;
    _firstDisplay = YES;
    _messageAlignment = NSTextAlignmentCenter;
}

#pragma mark - 创建内部视图

//阴影层
- (void)creatShadowView {
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentViewWidth, 175)];
    _shadowView.layer.masksToBounds = NO;
    _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
    _shadowView.layer.shadowRadius = 20;
    _shadowView.layer.shadowOpacity = 1;
    _shadowView.layer.shadowOffset = CGSizeMake(0, 10);
    [self.view addSubview:_shadowView];
}

//内容层
- (void)creatContentView {
    _contentView = [[UIView alloc] initWithFrame:_shadowView.bounds];
    _contentView.backgroundColor = [UIColor colorWithRed:250 green:251 blue:252 alpha:1];
    _contentView.layer.cornerRadius = 13;
    _contentView.clipsToBounds = YES;
    [_shadowView addSubview:_contentView];
}

//创建所有按钮
- (void)creatAllButtons {
    
    for (int i=0; i<self.actions.count; i++) {
        
        CKHighLightButton *btn = [CKHighLightButton new];
        btn.tag = 10+i;
        btn.highlightedColor = [UIColor colorWithWhite:0.97 alpha:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [btn setTitle:self.actions[i].title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
    }
}

//创建所有的分割线
- (void)creatAllSeparatorLine {
    
    if (!self.actions.count) {
        return;
    }
    
    //要创建的分割线条数
    NSInteger linesAmount = self.actions.count>2 ? self.actions.count : 1;
    linesAmount -= (self.title.length || self.message.length) ? 0 : 1;
    
    for (int i=0; i<linesAmount; i++) {
        
        UIView *separatorLine = [UIView new];
        separatorLine.tag = 1000+i;
        separatorLine.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        [_contentView addSubview:separatorLine];
    }
}

- (void)updateTitleLabelFrame {
    
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    CGFloat titleHeight = 0.0;
    if (self.title.length) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        titleHeight = size.height;
        self.titleLabel.frame = CGRectMake(_contentMargin.left, _contentMargin.top, labelWidth, size.height);
    }
}

- (void)updateMessageLabelFrame {
    
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    //更新message的frame
    CGFloat messageHeight = 0.0;
    CGFloat messageY = self.title.length ? CGRectGetMaxY(_titleLabel.frame) + 20 : _contentMargin.top;
    if (self.message.length) {
        CGSize size = [self.messageLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        messageHeight = size.height;
        self.messageLabel.frame = CGRectMake(_contentMargin.left, messageY, labelWidth, size.height);
    }
}

- (void)updateAllButtonsFrame {
    
    if (!self.actions.count) {
        return;
    }
    
    CGFloat firstButtonY = [self getFirstButtonY];
    
    CGFloat buttonWidth = self.actions.count>2 ? _contentViewWidth : _contentViewWidth/self.actions.count;
    
    for (int i=0; i<self.actions.count; i++) {
        UIButton *btn = [_contentView viewWithTag:10+i];
        CGFloat buttonX = self.actions.count>2 ? 0 : buttonWidth*i;
        CGFloat buttonY = self.actions.count>2 ? firstButtonY+_buttonHeight*i : firstButtonY;
        
        btn.frame = CGRectMake(buttonX, buttonY, buttonWidth, _buttonHeight);
    }
}

- (void)updateAllSeparatorLineFrame {
    
    //分割线的条数
    NSInteger linesAmount = self.actions.count>2 ? self.actions.count : 1;
    linesAmount -= (self.title.length || self.message.length) ? 0 : 1;
    NSInteger offsetAmount = (self.title.length || self.message.length) ? 0 : 1;
    for (int i=0; i<linesAmount; i++) {
        //获取到分割线
        UIView *separatorLine = [_contentView viewWithTag:1000+i];
        //获取到对应的按钮
        UIButton *btn = [_contentView viewWithTag:10+i+offsetAmount];
        
        CGFloat x = linesAmount==1 ? _contentMargin.left : btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = linesAmount==1 ? _contentViewWidth - _contentMargin.left - _contentMargin.right : _contentViewWidth;
        separatorLine.frame = CGRectMake(x, y, width, 0.5);
    }
}

- (void)updateShadowAndContentViewFrame {
    
    CGFloat firstButtonY = [self getFirstButtonY];
    
    CGFloat allButtonHeight;
    if (!self.actions.count) {
        allButtonHeight = 0;
    }
    else if (self.actions.count<3) {
        allButtonHeight = _buttonHeight;
    }
    else {
        allButtonHeight = _buttonHeight*self.actions.count;
    }
    
    //更新警告框的frame
    CGRect frame = _shadowView.frame;
    frame.size.height = firstButtonY+allButtonHeight;
    _shadowView.frame = frame;
    
    _shadowView.center = self.view.center;
    _contentView.frame = _shadowView.bounds;
}

- (CGFloat)getFirstButtonY {
    
    CGFloat firstButtonY = 0.0;
    if (self.title.length) {
        firstButtonY = CGRectGetMaxY(self.titleLabel.frame);
    }
    if (self.message.length) {
        firstButtonY = CGRectGetMaxY(self.messageLabel.frame);
    }
    firstButtonY += firstButtonY>0 ? 15 : 0;
    return firstButtonY;
}

#pragma mark - 事件响应
- (void)didClickButton:(UIButton *)sender {
    CKAlertAction *action = self.actions[sender.tag-10];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    
    [self showDisappearAnimation];
}

#pragma mark - 其他方法

- (void)addAction:(CKAlertAction *)action {
    [self.mutableActions addObject:action];
}

- (UILabel *)creatLabelWithFontSize:(CGFloat)fontSize {
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = kThemeColor;
    return label;
}

- (void)showAppearAnimation {
    
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _shadowView.transform = CGAffineTransformIdentity;
            _shadowView.alpha = 1;
        } completion:nil];
    }
}

- (void)showDisappearAnimation {
    
    [UIView animateWithDuration:0.1 animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - getter & setter

- (NSString *)title {
    return [super title];
}

- (NSArray<CKAlertAction *> *)actions {
    return [NSArray arrayWithArray:self.mutableActions];
}

- (NSMutableArray *)mutableActions {
    if (!_mutableActions) {
        _mutableActions = [NSMutableArray array];
    }
    return _mutableActions;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [self creatLabelWithFontSize:20];
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [self creatLabelWithFontSize:15];
        _messageLabel.text = self.message;
        _messageLabel.textAlignment = self.messageAlignment;
        [_contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageLabel.text = message;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    _messageLabel.textAlignment = messageAlignment;
}

@end
