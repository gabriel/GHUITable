//
//  GHUICollectionHeaderLabelView.m
//  Example
//
//  Created by Gabriel on 1/20/16.
//  Copyright © 2016 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionHeaderLabelView.h"

@interface GHUICollectionHeaderLabelView ()
@property UILabel *label;
@end

@implementation GHUICollectionHeaderLabelView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _label = [[UILabel alloc] init];
    [self addSubview:_label];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _label.frame = CGRectInset(self.bounds, 10, 0);
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [_label sizeThatFits:CGSizeMake(size.width - 20, size.height)];
}

@end
