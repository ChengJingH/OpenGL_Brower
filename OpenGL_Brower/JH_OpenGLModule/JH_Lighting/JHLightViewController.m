//
//  JHLightViewController.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/30.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JHLightViewController.h"
#import "JH_OpenGLLightView.h"

@interface JHLightViewController ()
//property
@property (nonatomic, strong)JH_OpenGLLightView *lightView;

@end

@implementation JHLightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkFragment)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self setupView];
}

- (void)displayLinkFragment
{
    [self.lightView renderGLView:JH_ColorRGBAMake(0.0, 0.0, 0.0, 1.0)];
}


- (void)setupView
{
    [self.view addSubview:self.lightView];
}


#pragma mark - property
- (JH_OpenGLLightView *)lightView
{
    if (!_lightView) {
        _lightView = [[JH_OpenGLLightView alloc] init];
    }
    return _lightView;
}



@end
