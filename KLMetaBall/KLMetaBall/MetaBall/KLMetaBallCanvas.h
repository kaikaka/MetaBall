//
//  KLMetaBallCanvas.h
//  KLMetaBall
//
//  Created by xiangkai yin on 16/4/13.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KLMetaBallItem;
@interface KLMetaBallCanvas : UIView

@property(nonatomic) KLMetaBallItem *azMetaBallItem;

@property (nonatomic) IBInspectable BOOL disableMetaBall;

- (void)attach:(UIView *)item;

+ (CGPoint)getGlobalCenterPositionOf:(UIView *)view;

@end

/**
 *  自定义实体类
 */
@interface Circle : NSObject

/**
 *  圆的半径
 */
@property (nonatomic) float radius;

/**
 *  中心点
 */
@property (nonatomic) CGPoint centerPoint;

/**
 *  圆的颜色
 */
@property(nonatomic) UIColor *color;

/**
 *  记录原始圆的半径
 */
@property (nonatomic) float originRadius;

//初始化方法
+ (instancetype)initWithcenterPoint:(CGPoint)center radius:(float)radius;
+ (instancetype)initWithcenterPoint:(CGPoint)center radius:(float)radius color:(UIColor *)color;

@end

#define kMax_Distance 105

@interface KLMetaBallItem : NSObject

@property (nonatomic) UIView *view;//副本

@property (nonatomic) Circle *centerCircle;//原始圆

@property (nonatomic) Circle *touchCircle;//触摸圆

@property (nonatomic) float maxDistance;//最大距离

@property (nonatomic) UIColor *color;//颜色

- (instancetype)initWithView:(UIView *)view;

@end