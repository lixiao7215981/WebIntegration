//
//  QRCodeViewController.m
//  LXFrameWork_OC
//
//  Created by 李晓 on 15/8/6.
//  Copyright (c) 2015年 LXFrameWork. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController() <AVCaptureMetadataOutputObjectsDelegate>
/**
 *  输入输出中间那座大桥
 */
@property (nonatomic,strong) AVCaptureSession * capSession;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"二维码/条形码"];
    
    // 添加扫描框和关闭按钮
    [self addQRCodeImgAndClaenBtn];
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 设置反应区域
    output.rectOfInterest=CGRectMake(0.2,0,0.5, 1);
    //初始化链接对象
    _capSession = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_capSession setSessionPreset:AVCaptureSessionPresetHigh];
    [_capSession addInput:input];
    [_capSession addOutput:output];
    //设置扫码支持的编码格式(条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // 显示摄像头取到的图像
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_capSession];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //走起！！
    [_capSession startRunning];
}

- (void) addQRCodeImgAndClaenBtn
{
    UIImageView *img = [UIImageView newAutoLayoutView];
    [self.view addSubview:img];
    [img autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:-20];
    [img autoAlignAxisToSuperviewAxis:ALAxisVertical];
    img.image = [BundleTool getImage:@"QRcode" FromBundle:LXFrameWorkBundle];
    
    UIButton *button = [UIButton newAutoLayoutView];
    [self.view addSubview:button];
    [button autoSetDimensionsToSize:CGSizeMake(50, 50)];
    [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
    [button addTarget:self action:@selector(cleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[BundleTool getImage:@"QRCodeCleanBtn" FromBundle:LXFrameWorkBundle]forState:UIControlStateNormal];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        for(AVMetadataObject *current in metadataObjects) {
            if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]
                && [current.type isEqualToString:AVMetadataObjectTypeQRCode]) {
                NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) current stringValue];
                if (_delegate && [_delegate respondsToSelector:@selector(ReaderCode:didScanResult:)]) {
                    [_capSession stopRunning];
                    [_delegate ReaderCode:self didScanResult:scannedResult];
                }
                break;
            }
        }
    }
}

- (void)cleanBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(ReaderCoderDidCancel:)]) {
        [_capSession stopRunning];
        [_delegate ReaderCoderDidCancel:self];
    }
}

@end
