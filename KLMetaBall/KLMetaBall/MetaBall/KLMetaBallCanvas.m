//
//  KLMetaBallCanvas.m
//  KLMetaBall
//
//  Created by xiangkai yin on 16/4/13.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

#import "KLMetaBallCanvas.h"

@interface KLMetaBallCanvas () {
  UIBezierPath *_path;    //画线
  
  CGPoint _touchPoint;    //触摸点
  
  bool _isTouch;          //是否触摸
  
  float _distance;        //连心线长度
}

@end

@implementation KLMetaBallCanvas

/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
  if (_path == nil) {
    _path = [[UIBezierPath alloc] init];
  }
  //计算连心线
  [self caculateDistance: self.azMetaBallItem.centerCircle Circle2:self.azMetaBallItem.touchCircle];
  //这句话是控制距离
  if (!_isTouch || _distance > self.azMetaBallItem.maxDistance) {
    return;
  }
  //画贝塞尔曲线
  [self drawBezierCurveWithCircle1:self.azMetaBallItem.centerCircle Circle2:self.azMetaBallItem.touchCircle];
  //画原始圆
  [self drawCenterCircle];
  //画触摸圆
  [self drawTouchCircle];

}

- (void)reset {
  _isTouch = false;
  [self removeAzMetaBallItem];
  _distance = 0;
}

- (void)attach:(UIView *)item {
  UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
  item.userInteractionEnabled = YES;
  [item addGestureRecognizer:drag];
}

- (void)setDisableMetaBall:(BOOL)disableMetaBall {
  _disableMetaBall = disableMetaBall;
  if (disableMetaBall == YES) {
    [self attach:self];
  }
}

- (void)drag:(UIPanGestureRecognizer *)recognizer {
  _touchPoint = [recognizer locationInView:self];
  
  UIView *touchView = recognizer.view;

  switch (recognizer.state) {
    case UIGestureRecognizerStateBegan:{
      [self addAzMetaBallItem:touchView];
      _isTouch = true;
      //            recognizer.view.hidden = YES; //如果在这就隐藏的话，在手速很慢的情况下，会出现原来的view消失，副本view还未绘制出来的情况
      break;
    }
    case UIGestureRecognizerStateChanged:{
      recognizer.view.hidden = YES;
      [self resetTouchCenter:_touchPoint];
      break;
    }
    case UIGestureRecognizerStateEnded: {
      
      if (_distance > self.azMetaBallItem.maxDistance) {
        [self explosion];
      } else {
        recognizer.view.hidden = NO;
        [self springBack:recognizer.view from:_touchPoint to:recognizer.view.center];
      }
      
      [self reset];
      break;
    }
    default:
      break;
  }
  
  [self setNeedsDisplay]; //重绘
}

- (void)addAzMetaBallItem:(UIView *)view {
  self.azMetaBallItem = [[KLMetaBallItem alloc] initWithView:view];
  
  [self addSubview:self.azMetaBallItem.view];
}
- (void)removeAzMetaBallItem {
  [self.azMetaBallItem.view removeFromSuperview];
  self.azMetaBallItem = nil;
}

#pragma mark draw circle
- (void) drawCenterCircle {
  
  //让开始的时候 触摸圆以及原始圆要比 原来的圆小
  self.azMetaBallItem.centerCircle.radius = self.azMetaBallItem.centerCircle.originRadius - _distance / 30;
  
  [self drawCircle:_path circle:self.azMetaBallItem.centerCircle];
}

- (void) drawTouchCircle {
  
  self.azMetaBallItem.touchCircle.radius = self.azMetaBallItem.touchCircle.originRadius - _distance / 30;
  
  [self drawCircle:_path circle:self.azMetaBallItem.touchCircle];
}

- (void)drawCircle:(UIBezierPath *)path circle:(Circle *)circle {
  [_path addArcWithCenter:circle.centerPoint radius:circle.radius startAngle:0 endAngle:360 clockwise:true];
  
  [circle.color set];
  [_path fill];
  
  [_path removeAllPoints];
}

#pragma reset touch center point of touch circle and touch view

-(void)resetTouchCenter:(CGPoint)center {
  self.azMetaBallItem.touchCircle.centerPoint = center;
  self.azMetaBallItem.view.center = center;
}

#pragma caculate distance of two circle
- (void)caculateDistance:(Circle *)circle1 Circle2:(Circle *)circle2 {
  float circle1_x = circle1.centerPoint.x;
  float circle1_y = circle1.centerPoint.y;
  float circle2_x = circle2.centerPoint.x;
  float circle2_y = circle2.centerPoint.y;
  
  //连心线的长度
  _distance = sqrt(powf(circle1_x - circle2_x, 2) + powf(circle1_y - circle2_y, 2));
  //画连心线
//  NSLog(@"连心线长度为：%f", _distance);
}

#pragma mark draw curve
- (void)drawBezierCurveWithCircle1:(Circle *)circle1 Circle2:(Circle *)circle2 {
  float circle1_x = circle1.centerPoint.x;
  float circle1_y = circle1.centerPoint.y;
  float circle2_x = circle2.centerPoint.x;
  float circle2_y = circle2.centerPoint.y;
  
  //连心线x轴的夹角
  float angle1 = atan((circle2_y - circle1_y) / (circle1_x - circle2_x));
  //连心线和公切线的夹角
  float angle2 = asin((circle1.radius - circle2.radius) / _distance);
  //切点到圆心和x轴的夹角
  float angle3 = M_PI_2 - angle1 - angle2;
  float angle4 = M_PI_2 - angle1 + angle2;
  
  //    NSLog(@"angle1:%f, angle2:%f, angle3:%f ", angle1, angle2, angle3);
  
  float offset1_X = cos(angle3) * circle1.radius;
  float offset1_Y = sin(angle3) * circle1.radius;
  float offset2_X = cos(angle3) * circle2.radius;
  float offset2_Y = sin(angle3) * circle2.radius;
  float offset3_X = cos(angle4) * circle1.radius;
  float offset3_Y = sin(angle4) * circle1.radius;
  float offset4_X = cos(angle4) * circle2.radius;
  float offset4_Y = sin(angle4) * circle2.radius;
  
  float p1_x = circle1_x - offset1_X;
  float p1_y = circle1_y - offset1_Y;
  float p2_x = circle2_x - offset2_X;
  float p2_y = circle2_y - offset2_Y;
  float p3_x = circle1_x + offset3_X;
  float p3_y = circle1_y + offset3_Y;
  float p4_x = circle2_x + offset4_X;
  float p4_y = circle2_y + offset4_Y;
  
  CGPoint p1 = CGPointMake(p1_x, p1_y);
  CGPoint p2 = CGPointMake(p2_x, p2_y);
  CGPoint p3 = CGPointMake(p3_x, p3_y);
  CGPoint p4 = CGPointMake(p4_x, p4_y);

  CGPoint p1_center_p4 = CGPointMake((p1_x + p4_x) / 2, (p1_y + p4_y) / 2);
  CGPoint p2_center_p3 = CGPointMake((p2_x + p3_x) / 2, (p2_y + p3_y) / 2);
  
  [self drawBezierCurveStartAt:p1 EndAt:p2 controlPoint:p2_center_p3];
  [self drawLineStartAt:p2 EndAt:p4];
  [self drawBezierCurveStartAt:p4 EndAt:p3 controlPoint:p1_center_p4];
  [self drawLineStartAt:p3 EndAt:p1];
  
  [_path moveToPoint:p1];
  [_path closePath];
  
  [_path fill];
}

- (void)drawLineStartAt:(CGPoint)startPoint EndAt:(CGPoint)endPoint {
  [_path addLineToPoint:endPoint];
}

- (void)drawBezierCurveStartAt:(CGPoint)startPoint EndAt:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint {
  [_path moveToPoint:startPoint];
  [_path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
}

#pragma animation
//爆炸效果
- (void)explosion {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  for (int i = 1; i < 6; i++) {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Boom.bundle/id_%d", i] ofType:@"png"]];
    [array addObject:image];
  }
  
  UIImageView *iV = [[UIImageView alloc] init];
  iV.frame = CGRectMake(0, 0, 34, 34);
  iV.center = _touchPoint;
  
  iV.animationImages = array;
  [iV setAnimationDuration:0.5];
  [iV setAnimationRepeatCount:1];
  [iV startAnimating];
  [self addSubview:iV];
}

//回弹效果
- (void)springBack:(UIView *)view from:(CGPoint)fromPoint to:(CGPoint)toPoint{
  
  //计算fromPoint在view的superView为坐标系里的坐标
//  CGPoint viewPoint = [PointUtils getGlobalCenterPositionOf:view];
//  fromPoint.x = fromPoint.x - viewPoint.x + toPoint.x;
//  fromPoint.y = fromPoint.y - viewPoint.y + toPoint.y;
//  
//  view.center = fromPoint;
//  
//  POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
//  anim.fromValue = [NSValue valueWithCGPoint:fromPoint];
//  anim.toValue = [NSValue valueWithCGPoint:toPoint];
//  
//  anim.springBounciness = 10.f;    //[0-20] 弹力 越大则震动幅度越大
//  anim.springSpeed = 10.f;        //[0-20] 速度 越大则动画结束越快
//  anim.dynamicsMass = 3.f;        //质量
//  anim.dynamicsFriction = 40.f;   //摩擦，值越大摩擦力越大，越快结束弹簧效果
//  anim.dynamicsTension = 1676.f;   //拉力
//  
//  [view pop_addAnimation:anim forKey:kPOPLayerPosition];
//  
//  NSLog(@"源Point = %f , %f", fromPoint.x, fromPoint.y);
//  NSLog(@"目标point = %f, %f", toPoint.x, toPoint.y);
  
  
//  [view startAnimationFrom:from to:to];
  [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.05 initialSpringVelocity:230 options:0 animations:^{
    view.center = toPoint;
  } completion:^(BOOL finished) {
//    [view completeAnimation];
  }];
}

+ (CGPoint)getGlobalCenterPositionOf:(UIView *)view {
  
  CGPoint point  = [self getGlobalPositionOf:view];
  
  float w = view.frame.size.width;
  float h = view.frame.size.height;
  
  point.x += w/2;
  point.y += h/2;
  
  return point;
}

+ (CGPoint)getGlobalPositionOf:(UIView *)view {
  UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
  //坐标转换
  CGRect rect=[view convertRect: view.bounds toView:window];
  return rect.origin;
}

@end

@implementation  Circle

+ (instancetype)initWithcenterPoint:(CGPoint)center radius:(float)radius {

  Circle *circle = [[Circle alloc] init];
  
  circle.radius = radius;
  circle.originRadius = radius;
  circle.centerPoint = center;
  
  circle.color = [UIColor blackColor];
  
  return circle;
}
+ (instancetype)initWithcenterPoint:(CGPoint)center radius:(float)radius color:(UIColor *)color {
  
  Circle *circle = [Circle initWithcenterPoint:center radius:radius];
  
  circle.color = color;
  
  return circle;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"point:(%f, %f) radius:%f  color:%@", self.centerPoint.x, self.centerPoint.y, self.radius, self.color];
}


@end

@implementation KLMetaBallItem

- (instancetype)initWithView:(UIView *)view {
  self = [super init];
  if(self) {
    self.color = [UIColor colorWithRed:247/255.0 green:76/255.0 blue:49/255 alpha:1];
    self.view = [self duplicate:view];
    self.view.layer.cornerRadius = view.frame.size.height / 2;
    self.view.layer.masksToBounds = YES;
    self.view.clipsToBounds = YES;
    self.view.layer.backgroundColor = [UIColor colorWithRed:247/255.0 green:76/255.0 blue:49/255 alpha:1].CGColor;
    
    float w = view.frame.size.width;
    float h = view.frame.size.height;
    //中心点转换
    CGPoint point = [KLMetaBallCanvas getGlobalCenterPositionOf:view];
    
    self.centerCircle = [Circle initWithcenterPoint:point radius:MIN(w, h)/2 color:_color];
    self.touchCircle = [Circle initWithcenterPoint:point radius:MIN(w, h)/2 color:_color];
    
    self.maxDistance = kMax_Distance;
    
    if (MIN(w, h) > 50) {
      self.maxDistance = kMax_Distance * 2;
    }
  }
  return self;
}



// Duplicate UIView
- (UIView*)duplicate:(UIView*)view
{
  //这里等于view的copy
  NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
  return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

@end