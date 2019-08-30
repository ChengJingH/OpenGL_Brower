//
//  JHDrawViewController.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/27.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JHDrawViewController.h"
#import "JH_OpenGLDrawView.h"

@interface JHDrawViewController ()

//property
@property (nonatomic, strong)JH_OpenGLDrawView *drawView;
@property (weak, nonatomic) IBOutlet UIButton *red_Btn;
@property (weak, nonatomic) IBOutlet UIButton *green_Btn;
@property (weak, nonatomic) IBOutlet UIButton *blue_Btn;

@end

@implementation JHDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkFragment)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [self setupView];
}

- (void)displayLinkFragment
{
    [self.drawView renderGLView:JH_ColorRGBAMake(1.0, 1.0, 1.0, 1.0)];
}


- (void)setupView
{
    self.red_Btn.layer.cornerRadius = 15.0;
    self.red_Btn.layer.masksToBounds = YES;
    self.green_Btn.layer.cornerRadius = 15.0;
    self.green_Btn.layer.masksToBounds = YES;
    self.blue_Btn.layer.cornerRadius = 15.0;
    self.blue_Btn.layer.masksToBounds = YES;

    [self.view addSubview:self.drawView];
    [self.view insertSubview:self.drawView atIndex:0];
}

#pragma mark - private

- (IBAction)redBtnAction:(id)sender {
    self.drawView.colorFlag = 0;
}
- (IBAction)greenBtnAction:(id)sender {
    self.drawView.colorFlag = 1;
}
- (IBAction)blueBtnAction:(id)sender {
    self.drawView.colorFlag = 2;
}


#pragma mark - property
- (JH_OpenGLDrawView *)drawView
{
    if (!_drawView) {
        _drawView = [[JH_OpenGLDrawView alloc] init];
    }
    return _drawView;
}

@end
