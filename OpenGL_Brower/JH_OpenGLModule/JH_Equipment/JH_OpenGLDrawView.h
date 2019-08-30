//
//  JH_OpenGLDrawView.h
//  OpenGL_Brower
//
//  Created by walen on 2019/8/28.
//  Copyright © 2019 CJH. All rights reserved.
//

#import "JH_OpenGLView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JH_OpenGLDrawView : JH_OpenGLView

/**
 颜色标签: 0: red 1: green 2: blue
 */
@property (nonatomic, assign)int colorFlag;

@end

NS_ASSUME_NONNULL_END
