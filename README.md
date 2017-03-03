## 一款漂亮简洁的警告框
![](https://ww4.sinaimg.cn/large/006tNbRwly1fda10j9vhbg30850egwsj.gif)
![](https://ww1.sinaimg.cn/large/006tNbRwly1fda10qv95qg30850egqjl.gif)
![](https://ww4.sinaimg.cn/large/006tNbRwly1fda10uezsig30850eg4f2.gif)

## 用法与UIAlertController类似
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
