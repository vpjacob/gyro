//
//  ViewController.m
//  QRCode OC
//
//  Created by 董建新 on 2016/12/8.
//  Copyright © 2016年 vpjacob. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SafariServices/SafariServices.h>
#import <CoreMotion/CoreMotion.h>

/*
 按钮modal出来二维码扫描
 二维码页加一个button，点击按钮后退出二维码，返回到按钮页
 */



@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>
//输入设备  捕获视频的摄像头
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出设备  通过二维码算法生成的元数据
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
//会话
@property (nonatomic, strong) AVCaptureSession *session;
//预览视图
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//位置管理者
@property (nonatomic, strong) CMMotionManager *mgr;

@property (nonatomic, assign) CGFloat xPoint;
@property (nonatomic, assign) CGFloat yPoint;
@property (nonatomic, assign) CGFloat zPoint;
@property (nonatomic, strong) UIImageView* arImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建运动管理者
    self.mgr = [[CMMotionManager alloc] init];
    

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    btn.center = CGPointMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height - 100);
    
    
    
    [self deviceInput];
    
    [self deviceOutput];
    
    [self setSession];
    
    [self setPreviewLayer];

    [self.session startRunning];
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)btnClick{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  设置预览视图
-(void)setPreviewLayer{
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    [self.view.layer addSublayer:self.previewLayer];
    
    self.previewLayer.frame = self.view.bounds;
    
    

    
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    //  将上次的视图移除，保证屏幕最多有一个点
    [self.arImageView removeFromSuperview];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    _arImageView = [[UIImageView alloc] init];
    
    _arImageView.backgroundColor = [UIColor redColor];
    
    _arImageView.frame = CGRectMake(point.x, point.y, 20, 20);
    
    //  添加小图形
    [self.view addSubview:_arImageView];
    
    //  手动调用一次方法
    [self test];

    
}



-(void)test{
    
    //  如果没创建出，小红点返回
    if (_arImageView == nil) {
        return;
    }
    
    
   
    
    
    if ([self.mgr isGyroAvailable]) {
        
        [self.mgr startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            
            CMRotationRate rotationRate = gyroData.rotationRate;
            
            self.yPoint = rotationRate.y * -2;
            self.xPoint = rotationRate.x * -2;
            self.zPoint = rotationRate.z * -2;
            
            
            CGRect arImageFrame = _arImageView.frame;
            arImageFrame.origin.x -= self.yPoint;
            arImageFrame.origin.y -= self.xPoint;
//            arImageFrame.origin.z += self.zPoint;
            
//            NSLog(@"arImageFrame.origin.x: %f", arImageFrame.origin.x);
            
            _arImageView.frame = CGRectMake(arImageFrame.origin.x, arImageFrame.origin.y, arImageFrame.size.width, arImageFrame.size.height);
            
            
//            _arImageView.layer.transform = CATransform3DRotate(_arImageView.layer.transform, 1, rotationRate.x, rotationRate.y, rotationRate.z);
            
            
        }];
    }
    
}



//  设置会话
-(void)setSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    //  添加会话
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //  设置输出设备的算法是二维码算法，要在将设备添加到会话后进行
    
    
}


//  输出设备
-(void)deviceOutput{
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
}




//  输入设备
-(void)deviceInput{
    
    AVCaptureDevice* deviceViedo = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:deviceViedo error:nil];
    

    
}


@end
