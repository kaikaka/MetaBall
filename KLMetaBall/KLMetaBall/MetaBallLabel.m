//
//  MetaBallLabel.m
//  KLMetaBall
//
//  Created by xiangkai yin on 16/4/13.
//  Copyright © 2016年 kuailao_2. All rights reserved.
//

#import "MetaBallLabel.h"

@implementation MetaBallLabel

- (void)awakeFromNib {
  [super awakeFromNib];
  [self initialization];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialization];
  }
  return self;
}

- (void)initialization {
//  self.backgroundColor = [UIColor colorWithRed:247/255.0 green:76/255.0 blue:49/255 alpha:1];
  self.layer.cornerRadius = self.frame.size.height / 2;
  self.layer.masksToBounds = YES;
  self.clipsToBounds = YES;
  self.layer.backgroundColor = [UIColor colorWithRed:247/255.0 green:76/255.0 blue:49/255 alpha:1].CGColor;
  
  UILabel *metaLabel = [[UILabel alloc] initWithFrame:self.bounds];
  [metaLabel setTextColor:[UIColor whiteColor]];
  [metaLabel setFont:[UIFont systemFontOfSize:13.]];
  [metaLabel setTextAlignment:NSTextAlignmentCenter];
  [metaLabel setText:@"99+"];
  [self addSubview:metaLabel];
  self.mtbaLabel = metaLabel;
}

@end
