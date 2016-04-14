//
//  UIView+MetaBall.m
//  KLMetaBall
//
//  Created by xiangkai yin on 16/4/13.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

#import "UIView+MetaBall.h"
#import <objc/runtime.h>

NSString * const kMetaBall_UIView_DisableMetaBall = @"__kMetaBall_UIView_DisableMetaBall";

@implementation UIView (MetaBall)

- (BOOL)disableMetaBall {
  return [objc_getAssociatedObject(self, &kMetaBall_UIView_DisableMetaBall) boolValue];
}

- (void)setDisableMetaBall:(BOOL)disableMetaBall {
  [self willChangeValueForKey:kMetaBall_UIView_DisableMetaBall];
  objc_setAssociatedObject(self, &kMetaBall_UIView_DisableMetaBall, @(disableMetaBall), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [self didChangeValueForKey:kMetaBall_UIView_DisableMetaBall];
  
  if (disableMetaBall == YES) {
//    __KLMetaBall_Swizzle([UIView class], @selector(drawRect:), @selector(__KLMetaBall_Hook_DrawRect:));
  }
}

void __KLMetaBall_Swizzle(Class c,SEL origSEL,SEL newSEL) {
  Method originMethod = class_getInstanceMethod(c, origSEL);
  Method newMethod = nil;
  
  if (!originMethod) {
    originMethod = class_getClassMethod(c, origSEL);
    newMethod = class_getClassMethod(c, newSEL);
  } else {
    newMethod = class_getClassMethod(c, newSEL);
  }
  if (!originMethod || newMethod) {
    return;
  }
  if (class_addMethod(c, origSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
    class_replaceMethod(c, newSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
  } else {
    method_exchangeImplementations(originMethod, newMethod);
  }
}

- (void) __KLMetaBall_Hook_DrawRect:(CGRect)rect {
  [self __KLMetaBall_Hook_DrawRect:rect];
  NSLog(@"__KLMetaBall_Hook_DrawRect");
  self.backgroundColor = [UIColor purpleColor];
}


@end
