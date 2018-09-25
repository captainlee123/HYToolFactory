//
//  ViewController.m
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/14.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import "ViewController.h"
#import "HYToolKit.h"
#import "TestViewController.h"

#import "HYLocationManager.h"
#import "HYPhotoKit.h"

@interface ViewController () <HYJumpTextLayerDelegate,HYPhotoKitDelegate>

@property (nonatomic, strong) HYJumpTextLayer   *distanceLayer;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    [self.headerBar centerBtnSetTitle:@"我的" forState:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *test = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 60, 40)];
    
    [test setTitle:@"测试 " forState:0];
    [test addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];
    
//    test.backgroundColor = [UIColor yellowColor];
    [test setBackgroundImage:[UIImage gradientImage:[UIColor yellowColor] endColor:[UIColor redColor] imageSize:test.frame.size direction:HYImageDirectionLeftToRight] forState:0];
    
    
    UIButton *photo = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 60, 40)];
    
    [photo setTitle:@"photo " forState:0];
    [photo addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photo];
    [photo setBackgroundImage:[UIImage gradientImage:[UIColor yellowColor] endColor:[UIColor redColor] imageSize:test.frame.size direction:HYImageDirectionTopToBottom] forState:0];
    
    
    self.distanceLayer = [[HYJumpTextLayer alloc] init];
    self.distanceLayer.frame = CGRectMake(0, 200, self.view.bounds.size.width, 50);
    self.distanceLayer.string = @"";
    self.distanceLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.distanceLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
    self.distanceLayer.alignmentMode = kCAAlignmentCenter;
    self.distanceLayer.contentsScale = [UIScreen mainScreen].scale;// 这句话使得字体不模糊,这是因为屏幕的分辨率问题
    UIFont *font = [UIFont systemFontOfSize:45];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.distanceLayer.font = fontRef;
    self.distanceLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    self.distanceLayer.jumpDelegate = self;
    [self.view.layer addSublayer:self.distanceLayer];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 300, self.view.bounds.size.width-20, 70)];
    self.textView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textView.textColor = [UIColor whiteColor];
    self.textView.backgroundColor = [UIColor clearColor];
    //self.textView.placeholderColor = DEFAULT_TEXT_COLOR;
    //    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.placeholder = @"占位符";
    [self.view addSubview:self.textView];
    
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    self.imgView.clipsToBounds = YES;
    [self.view addSubview:self.imgView];
}

- (void)photoAction {
    [[HYPhotoKit shareInstance] addPhotoFromViewController:self delegate:self];
    [[HYPhotoKit shareInstance] setPhotoType:PHOTO_PROCESS_TYPE_SINGLE_SELECT];
    [[HYPhotoKit shareInstance] setAllowMaxPhotoNum:9];
}

#pragma mark ============ HYPhotoKitDelegate ===========
- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishClipImage:(UIImage *)clipImage {
    self.imgView.image = clipImage;
}

- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishEditImage:(UIImage *)editImage {
    self.imgView.image = editImage;
}

- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishChoosePhotos:(NSMutableArray *)imgArr {
    
}

- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishPickingMediaWithInfo:(NSDictionary *)info picker:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)testAction {
//    [[HYLocationManager shareInstance] startLocationCompletion:^(HYLocationObj *locationObj) {
//        NSLog(@"city : %@", locationObj.placemark.locality);
//        NSLog(@"province : %@", locationObj.placemark.administrativeArea);
//    }];
    
    TestViewController *vc = [[TestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    //该方法实现跳跃
//    [self.distanceLayer jumpNumberWithDuration:1 fromNumber:1 toNumber:100 ];
}

- (NSString *)jumpTextLayer:(HYJumpTextLayer *)jumpLayer customJumpString:(CGFloat)currentNumber {
    NSInteger minutes = currentNumber / 60;
    NSInteger seconds = (NSInteger)currentNumber % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
