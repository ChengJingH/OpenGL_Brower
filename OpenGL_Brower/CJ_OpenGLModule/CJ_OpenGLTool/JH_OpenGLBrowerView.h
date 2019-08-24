//
//  CJ_OpenGLBrowerView.h
//  OpenGL_Brower
//
//  Created by walen on 2019/8/12.
//  Copyright © 2019 CJH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JH_OpenGLBrowerView : UIView

@property (nonatomic,assign)GLfloat currentViewDistant;

//渲染
- (void)renderGLView;


@end

NS_ASSUME_NONNULL_END
