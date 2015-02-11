//
//  GHUICatalogSwitchCell.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/31/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUISwitchCell.h"

@implementation GHUISwitchView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self sharedInit];
  }
  return self;
}

- (void)sharedInit {
  _label = [[UILabel alloc] init];
  _label.font = [UIFont systemFontOfSize:16];
  [self addSubview:_label];

  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.font = [UIFont systemFontOfSize:14];
  _descriptionLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
  [self addSubview:_descriptionLabel];
  
  _switchView = [[UISwitch alloc] init];
  [self addSubview:_switchView];
}

- (void)layoutSubviews {
  CGFloat y = 10;
  CGSize size = self.frame.size;
  
  CGSize switchSize = [_switchView sizeThatFits:size];
  _switchView.frame = CGRectMake(size.width - switchSize.width - 10, 15, switchSize.width, switchSize.height);

  _label.frame = CGRectMake(15, y, size.width - switchSize.width - 25, 18);
  y += 18;

  _descriptionLabel.frame = CGRectMake(15, y, size.width - 25 - switchSize.width, 18);
}

- (CGSize)sizeThatFits:(CGSize)size {
  return CGSizeMake(size.width, 56);
}

- (void)setTitle:(NSString *)title description:(NSString *)description on:(BOOL)on {
  _label.text = title;
  _descriptionLabel.text = description;
  _switchView.on = on;
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end


@implementation GHUISwitchCell

+ (Class)contentViewClass {
  return GHUISwitchView.class;
}

@end


