//
//  HMComposeVC.m
//  0307-新浪微博
//
//  Created by whj on 16/5/26.
//  Copyright © 2016年 wanghongjiang. All rights reserved.
//

#import "HMComposeVC.h"
#import "HMAccountTool.h"
#import "HMEmotionTextView.h"
#import "HMHttpRequestTool.h"
#import "MBProgressHUD+MJ.h"
#import "HMComposeToolBar.h"
#import "HMComposePhotosView.h"
#import "HMEmotionKeyboard.h"
#import "HMEmotion.h"


@interface HMComposeVC () <UITextViewDelegate,HMComposeToolBarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/** 输入控件*/
@property (nonatomic, weak) HMEmotionTextView *textView;
/** toolbar*/
@property (nonatomic, weak) HMComposeToolBar *toolBar;
/** 存放拍照或者在相册中选中图片的View*/
@property (nonatomic, weak) HMComposePhotosView *photosView;
/** 标记键盘是否在切换期间*/
@property (nonatomic, assign) BOOL switchingKeyboard;
/** 表情键盘*/
@property (nonatomic, strong) HMEmotionKeyboard *emotionKeyboard;
@end

@implementation HMComposeVC

/**
 *  懒加载：不用每次切换键盘的时候都要重新创建了
 */
- (HMEmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[HMEmotionKeyboard alloc] init];
        //如果键盘的宽度非零，那么系统就会强制他的宽度等于屏幕的宽度
        self.emotionKeyboard.width = ScreenWidth;
        self.emotionKeyboard.height = 216;//系统默认键盘的高度
    }
    return _emotionKeyboard;
}

#pragma mark -系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏
    [self setupNavi];
    
    //添加输入控件
    [self setupTextView];
    
    //添加toobar
    [self setupToolBar];
    
    //添加相册
    [self setupPhotosView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //让textview成为第一响应者，一旦成为第一响应者，就会叫出对应的键盘
    [self.textView becomeFirstResponder];

}

#pragma mark -初始化方法
/**
 * 添加相册
 */
- (void)setupPhotosView
{
    HMComposePhotosView *photosView = [[HMComposePhotosView alloc] init];
    photosView.x = 0;
    photosView.y = 100;
    photosView.width = self.view.width;
    photosView.height = self.view.height - 100;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}

/**
 * 添加输入控件
 */
- (void)setupTextView
{
     // 在这个控制器中，textView的contentInset.top默认会等于64
    HMEmotionTextView *textView = [[HMEmotionTextView alloc] initWithFrame:self.view.bounds];
    textView.font = [UIFont systemFontOfSize:15];
    // 垂直方向上永远可以拖拽（有弹簧效果）
    textView.alwaysBounceVertical = YES;
    textView.placeholder = @"分享新鲜事...";
    textView.delegate = self;
    [self.view addSubview:textView];
    self.textView = textView;

    //通知
    [HMNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    
    [HMNotificationCenter addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //监听表情按钮点击的通知
    [HMNotificationCenter addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    
    [HMNotificationCenter addObserver:self selector:@selector(emotionDidDelete) name:HMEmotionDidDeleteNotification object:nil];
//    DLog(@"%@",NSStringFromUIEdgeInsets(textView.contentInset));
    
}

/**
 *  删除textView中的文字
 */
- (void)emotionDidDelete
{
    [self.textView deleteBackward];
    [self textDidChange];
}

/**
 UITextField:
 1.文字永远是一行，不能显示多行文字
 2.有placehoder属性设置占位文字x
 3.继承自UIControl
 4.监听行为
 1> 设置代理
 2> addTarget:action:forControlEvents:
 3> 通知:UITextFieldTextDidChangeNotification
 
 UITextView:
 1.能显示任意行文字
 2.不能设置占位文字
 3.继承自UIScollView
 4.监听行为
 1> 设置代理
 2> 通知:UITextViewTextDidChangeNotification
 */
/**
 *  键盘的frame发生改变时调用（显示、隐藏等）
 */
#pragma mark -键盘的frame发生改变
- (void)keyboardDidChangeFrame:(NSNotification *)notify
{
    //判断键盘是否在切换期间
    if (self.switchingKeyboard) return;
        
    
//    notify.userInfo;
//    DLog(@"%@",notify.userInfo);

     /**
     notification.userInfo = @{
     // 键盘弹出\隐藏后的frame
     UIKeyboardFrameEndUserInfoKey = NSRect: {{0, 352}, {320, 216}},
     // 键盘弹出\隐藏所耗费的时间
     UIKeyboardAnimationDurationUserInfoKey = 0.25,
     // 键盘弹出\隐藏动画的执行节奏（先快后慢，匀速）
     UIKeyboardAnimationCurveUserInfoKey = 7
     }
     */
    NSDictionary *dict = notify.userInfo;
   
    //keyboard的frame
    CGRect keyboardFrame = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //keyboard的持续时间
    double duration = [dict[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
//        self.toolBar.y = frame.origin.y - self.toolBar.height;
        if (keyboardFrame.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            self.toolBar.y = self.view.height - self.toolBar.height;
        } else {
            self.toolBar.y = keyboardFrame.origin.y - self.toolBar.height;
        }
//        DLog(@"%@", NSStringFromCGRect(self.toolBar.frame));

    }];
    
}

#pragma mark - 点击表情按钮的监听方法
/**
 *  表情选中了
 */
- (void)emotionDidSelected:(NSNotification *)notification
{
    HMEmotion *emotion = notification.userInfo[HMEmotionBtnKey];
    //封装像textView中插入文字或图片
    [self.textView insertEmotion: emotion];
    
    [self textDidChange];
   /**
   HMEmotion *selectedEmotion = notification.userInfo[HMEmotionBtnKey];
    HMLog(@"--%@",selectedEmotion);
    
    if (selectedEmotion.code) { //当是emoji表情时
        //将emoji的表情文字插入到光标所在处
        [self.textView insertText:selectedEmotion.code.emoji];
    }
    else if (selectedEmotion.png){
        
        //加载图片
        UIImage *img = [UIImage imageNamed:selectedEmotion.png];
        NSTextAttachment *attach  =[[NSTextAttachment alloc] init];
        attach.image = img;
        CGFloat attachWH = self.textView.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachWH, attachWH);
        NSAttributedString *imgString = [NSAttributedString attributedStringWithAttachment:attach];
        
        NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
        [attributeText appendAttributedString:self.textView.attributedText];

        //拼接字符串
//        [attributeText appendAttributedString:imgString];
        NSInteger location = self.textView.selectedRange.location;
        [attributeText insertAttributedString:imgString atIndex:location];//插入图片
        
        [attributeText addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, attributeText.length)];
       
        self.textView.attributedText = attributeText;
        //设置完文字，将光标移动到插入图片的后面
        self.textView.selectedRange = NSMakeRange(location + 1, 0);
     
    
    }
    */
    
   
}

/**
 *  创建toobar
 */
- (void)setupToolBar
{
    HMComposeToolBar *toolbar = [HMComposeToolBar toolBar];
    toolbar.height = 44;
    toolbar.width = ScreenWidth;
    toolbar.x = 0;
    toolbar.y = ScreenHeight - toolbar.height;
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    
    self.toolBar = toolbar;

    
    
    // inputAccessoryView设置显示在键盘顶部的内容
//    self.textView.inputAccessoryView = toolbar;
    // inputView设置键盘
    //    self.textView.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];

   }

/**
 *  设置导航栏内容
 */
- (void)setupNavi
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    NSString *username = [HMAccountTool account].name;
    NSString *prefix = @"发微博";
    if (username) {//当有名字时
        UILabel *titleView = [[UILabel alloc] init];
        titleView.numberOfLines = 0;
        titleView.textAlignment = NSTextAlignmentCenter;
        
        NSString *text = [NSString stringWithFormat:@"%@\n%@",prefix,username];
        
        //创建一个带有属性的字符串（比如文字颜色、文字字体）
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:text];
        //添加属性
        [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[text rangeOfString:username]];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[text rangeOfString:username]];
        [attriStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[text rangeOfString:prefix]];
        
        titleView.attributedText = attriStr;
        [titleView sizeToFit];
        self.navigationItem.titleView = titleView;

    }
    else {//第一次加载而且网速比较慢的时候可能会没有名字
        self.title = prefix;
    }
    
}
/**
 *  发送没有图片的微博
 */
- (void)send
{
    
    if (self.photosView.photos.count) {//带图片的时候
        [self sendImageStatus];
    }
    else { //不带图片的时候
        [self sendWithoutImageStatus];
    }
    //不管发没发成功，先让这个控制器消失，不会影响到其他操作
    [self dismissViewControllerAnimated:YES completion:nil];

}
/**
 *   
 //access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 //status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 // pic	true	binary	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。

 */
- (void)sendImageStatus
{
    // 1.拼接请求参数
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    parametersDict[@"access_token"] = [HMAccountTool account].access_token;
    parametersDict[@"status"] = self.textView.fullText;

    
    [HMHttpRequestTool post:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:parametersDict requestSerializerValue:@"application/json" httpHeaderField:@"Content-Type" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        拼接文件数据
        UIImage *image = [self.photosView.photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);//1.0代表1:1上传，不会失真

        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];

    } success:^(id json) {
        HMLog(@"success---->%@",json);
        [MBProgressHUD showSuccess:@"发送成功"];

    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
        HMLog(@"failure----->%@",error);
       
    }];
    
//    //创建一个manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];//默认的就是json解析器
//    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
//    
//    
//    // 2.拼接请求参数
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    parametersDict[@"access_token"] = [HMAccountTool account].access_token;
//    parametersDict[@"status"] = self.textView.fullText;
//    
//    
//    //3.发送请求
//    [manager POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:parametersDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //拼接文件数据
//        UIImage *image = [self.photosView.photos firstObject];
//        NSData *data = UIImageJPEGRepresentation(image, 1.0);//1.0代表1:1上传，不会失真
//        
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        HMLog(@"success---->%@",responseObject);
//        [MBProgressHUD showSuccess:@"发送成功"];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        [MBProgressHUD showError:@"发送失败"];
//        HMLog(@"failure----->%@",error);
//    }];


}


/**
 *  发送不带图片的微博
 //access_token	false	string	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 //status	true	string	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。
 */
- (void)sendWithoutImageStatus
{
    // 1.拼接请求参数
    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
    parametersDict[@"access_token"] = [HMAccountTool account].access_token;
    parametersDict[@"status"] = self.textView.fullText;
//    DLog(@"------%@",self.textView.fullText);

    //2.发送请求
    [HMHttpRequestTool post:@"https://api.weibo.com/2/statuses/update.json" parameters:parametersDict success:^(id json) {
        [MBProgressHUD showSuccess:@"发送成功"];
//         DLog(@"success---->%@",json);
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
        DLog(@"failure----->%@",error);
    }];
    
//    //创建一个manager
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
////    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];//默认的就是json解析器
//    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
//    
//    // 2.拼接请求参数
//    NSMutableDictionary *parametersDict = [NSMutableDictionary dictionary];
//    parametersDict[@"access_token"] = [HMAccountTool account].access_token;
//    parametersDict[@"status"] = self.textView.fullText;
//    DLog(@"------%@",self.textView.fullText);
//    
//    //3.发送请求
//    [manager POST:@"https://api.weibo.com/2/statuses/update.json" parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//       
//        [MBProgressHUD showSuccess:@"发送成功"];
//         HMLog(@"success---->%@",responseObject);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        [MBProgressHUD showError:@"发送失败"];
//        HMLog(@"failure----->%@",error);
//    }];

    

}

#pragma makr -监听方法
/**
 *  监听textview的文字
 */
- (void)textDidChange
{
//    DLog(@"%@--",self.textView.fullText);
    //当里面只有表情图片的时候按钮也应该被选中
    self.navigationItem.rightBarButtonItem.enabled = self.textView.fullText;

   //    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
    
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - HMComposeToolBarDelegate
- (void)composeToolBar:(HMComposeToolBar *)toolBar ClickButtonType:(ComposeButtonType)buttonType
{
    switch (buttonType) {
        case ComposeButtonTypeCamera://相机
        {
//            DLog(@"相机");
            [self openCamera];
        }
            break;
            
        case ComposeButtonTypePicture://相册
        {
//            DLog(@"相册");
            [self openAlumb];
        }
            break;
            
        case ComposeButtonTypeMention://@
        {
//            DLog(@"@");
        }
            break;
            
            
        case ComposeButtonTypeTrend://#热门话题
        {
            DLog(@"#热门话题");
        }
            break;
            
        case ComposeButtonTypeEmotion://表情
        {
//            DLog(@"表情");
            [self switchKeyboard];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 其他方法
- (void)switchKeyboard
{
    //self.textView.inputView==nil 代表系统自带的键盘
    if (self.textView.inputView==nil) {//切换键盘到自定义键盘

        self.textView.inputView = self.emotionKeyboard;
        
        self.toolBar.showKeyboardButton = YES;
        }
    else {//将键盘切换到系统的键盘
        self.textView.inputView = nil;
        
        self.toolBar.showKeyboardButton = NO;
    }
    
    
    /**
     *  退出键盘再召唤键盘，这样做是因为：切换键盘时只有在重新弹出键盘的时候才能看到效果
     */
    
    self.switchingKeyboard = YES;//标记键盘是在切换期间，此时键盘上的工具条不应该改变y值
    
    //退出键盘
    [self.textView endEditing:YES];
//    [self.view endEditing:YES];
//    [self.view.window endEditing:YES];
    
    
    //标记键盘切换结束，如果没有改变标记那么以后工具条就不会跟着键盘改变y值了
    self.switchingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//延迟0.1s是为了看到键盘弹出和关闭的动画
        
        [self.textView becomeFirstResponder];
       
    });
}

/**
 *  打开照相机
 */
- (void)openCamera
{
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {//判断是否可用
//        return;
//    }
//    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
//    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    pickerController.delegate = self;
//    [self presentViewController:pickerController animated:YES completion:nil];
    
    
    [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
    
}

/**
 *  打开图片库
 */
- (void)openAlumb
{
    //如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework框架，利用这个框架可以获得手机上所有相册图片，很多应用都会自己第一图片选择控制器
    
    
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum的范围要比UIImagePickerControllerSourceTypePhotoLibrary的范围小
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)openImagePickerController:(UIImagePickerControllerSourceType)sourceType
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]){//判断是否可用
        return;
    }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = sourceType;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];


}

#pragma mark - UIImagePickerControllerDelegate
/**
 *  从UIImagePickerController选择完图片后调用（拍照完毕或者选择图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    DLog(@"%@",info);
    //info中包含了选中的图片
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    [self.photosView addPhoto:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
