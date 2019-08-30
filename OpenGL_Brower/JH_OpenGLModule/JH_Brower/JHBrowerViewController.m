//
//  JHBrowerViewController.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/27.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JHBrowerViewController.h"
#import "JH_OpenGLBrowerView.h"

@interface JHBrowerViewController ()
//property
@property (nonatomic, strong)JH_OpenGLBrowerView *browerView;
@property (nonatomic, strong)UIProgressView *progressView;

@end

@implementation JHBrowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkFragment)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self setupView];
}

- (void)displayLinkFragment
{
    [self.browerView renderGLView:JH_ColorRGBAMake(0.5, 0.5, 0.5, 1.0)];
}


- (void)setupView
{
    [self.view addSubview:self.browerView];
    
    //增大触控区域
    UIView *touchAreaView = [[UIView alloc] initWithFrame:CGRectMake(20, 80.0, [UIScreen mainScreen].bounds.size.width-40.0, 15.0)];
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [touchAreaView addGestureRecognizer:tapAction];
    [touchAreaView addSubview:self.progressView];
    [self.view addSubview:touchAreaView];
    
    //    [self rorateProgressView];
}

//- (void)rorateProgressView
//{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.toValue = [NSNumber numberWithFloat:-M_PI_2];
//    animation.duration = 0.8;
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = NO;
//    [self.progressView.layer addAnimation:animation forKey:@"progressView_rotate"];
//}

- (void)tapEvent:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:tap.view];
    
    //获取点击相对位置
    [_progressView setProgress:point.x/([UIScreen mainScreen].bounds.size.width-40.0) animated:YES];
    
    self.browerView.currentViewDistant = point.x/([UIScreen mainScreen].bounds.size.width-40.0) * 10;
}


#pragma mark - property
- (JH_OpenGLBrowerView *)browerView
{
    if (!_browerView) {
        _browerView = [[JH_OpenGLBrowerView alloc] init];
    }
    return _browerView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40.0, 2.0)];
        [_progressView setProgress:0.0 animated:YES];
    }
    return _progressView;
}

@end
