//
//  GHHeaderLabel.m
//  Example
//
//  Created by Gabriel on 1/22/16.
//  Copyright © 2016 Gabriel Handford. All rights reserved.
//

#import "GHHeaderLabel.h"

#import <YOLayout/YOLayout.h>

@interface GHHeaderLabel ()
@property UILabel *label;
@property YOLayout *viewLayout;
@end

@implementation GHHeaderLabel

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self viewInit];
  }
  return self;
}

- (void)viewInit {
  self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
  _label = [[UILabel alloc] init];
  _label.backgroundColor = [UIColor clearColor];
  _label.textColor = [UIColor colorWithRed:255.0f/255.0f green:125.0f/255.0f blue:0.0f/255.0f alpha:1.0];
  _label.font = [UIFont systemFontOfSize:18];

  [self addSubview:_label];

  self.viewLayout = [YOLayout layoutWithLayoutBlock:^CGSize(id<YOLayout> layout, CGSize size) {
    CGSize labelSize = [_label sizeThatFits:size];
    CGFloat y = 0;
    y += [layout setFrame:CGRectMake(5, 0, labelSize.width, labelSize.height) view:_label options:0].size.height;
    return CGSizeMake(size.width, y);
  }];
}

- (void)setText:(NSString *)text {
  _label.text = text;
  [self setNeedsLayout];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [_viewLayout layoutSubviews:self.frame.size];
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [_viewLayout sizeThatFits:size];
}

- (void)setNeedsLayout {
  [super setNeedsLayout];
  [self setNeedsDisplay];
  [_viewLayout setNeedsLayout];
}

@end