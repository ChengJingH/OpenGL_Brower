//
//  CJ_OpenGLBrowerView.h
//  OpenGL_Brower
//
//  Created by walen on 2019/8/12.
//  Copyright © 2019 CJH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JH_OpenGLEffect.h"

NS_ASSUME_NONNULL_BEGIN

@interface JH_OpenGLView : UIView

@property (nonatomic, strong)CAEAGLLayer *gl_layer;
@property (nonatomic, strong)JH_OpenGLEffect *gl_effect;

@property (nonatomic, assign)GLuint vertexbuffers;

@property (nonatomic, assign)GLuint framebuffers;
@property (nonatomic, assign)GLuint renderbuffers;
@property (nonatomic, assign)GLuint depthBuffer;

@property (nonatomic, assign)GLuint texturebuffers;
@property (nonatomic, assign)GLuint indexbuffers;

/**
 加载顶点数据缓存
 */
- (void)loadVertexData;

/**
 渲染帧

 @param color 清除颜色缓存
 */
- (void)renderGLView:(JH_ColorRGBA)color;

@end

NS_ASSUME_NONNULL_END
