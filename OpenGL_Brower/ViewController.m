//
//  ViewController.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/12.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "ViewController.h"
#import "JH_OpenGLBrowerView.h"

@interface ViewController ()
@property (nonatomic, strong)JH_OpenGLBrowerView *browerView;
@property (nonatomic, strong)UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkFragment)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self setupView];
}

- (void)displayLinkFragment
{
    [self.browerView renderGLView];
}


- (void)setupView
{
    [self.view addSubview:self.browerView];
    [self.view addSubview:self.progressView];
    
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
    CGPoint point = [tap locationInView:_progressView];
    NSLog(@"x: %f ~ y: %f",point.x,point.y);
    
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
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 80.0, [UIScreen mainScreen].bounds.size.width-40.0, 2.0)];
        [_progressView setProgress:0.0 animated:YES];
        
        //点击手势
        UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [_progressView addGestureRecognizer:tapAction];
    }
    return _progressView;
}

@end
