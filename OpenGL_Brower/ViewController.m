//
//  ViewController.m
//  OpenGL_Brower
//
//  Created by walen on 2019/8/12.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "ViewController.h"
#import "JHBrowerViewController.h"
#import "JHDrawViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)transformBtn:(id)sender {
    JHBrowerViewController *vc = [[JHBrowerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)drawBtn:(id)sender {
    JHDrawViewController *vc = [[JHDrawViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
