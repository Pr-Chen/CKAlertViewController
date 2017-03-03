# 一款漂亮简洁的警告框
![](https://ww3.sinaimg.cn/large/006tNbRwly1fda0oksrt7g30640av1kx.gif)
# 与UIAlertController用法类似
```objective-c
    CKAlertViewController *alertVC = [CKAlertViewController alertControllerWithTitle:@"Access Microphone?" message:@"Are you       sure that you want to allow this app to access your microphone?" ];
    
    CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"取消" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    CKAlertAction *sure = [CKAlertAction actionWithTitle:@"确定" handler:^(CKAlertAction *action) {
        NSLog(@"点击了 %@ 按钮",action.title);
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:NO completion:nil];
```
