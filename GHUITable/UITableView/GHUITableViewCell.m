//
//  GHUITableViewCell.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewCell.h"

@interface GHUITableViewCell ()
@property (nonatomic) UIView *viewForContent;
@end

@implementation GHUITableViewCell

// This is only to trigger viewForContent creation
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    [self viewForContent];
  }
  return self;
}

- (id)initWithContentView:(UIView *)contentView {
  if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([contentView class])])) {
    [self setupContentView:contentView];
  }
  return self;
}

+ (GHUITableViewCell *)tableViewCellForContentView:(UIView *)contentView {
  return [[GHUITableViewCell alloc] initWithContentView:contentView];
}

- (void)setupContentView:(UIView *)contentView {
  _viewForContent = contentView;
  [self.contentView addSubview:_viewForContent];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.viewForContent.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

+ (Class)contentViewClass {
  // Abstract method
  return nil;
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [self.viewForContent sizeThatFits:size];
}

- (UIView *)viewForContent {
  if (!_viewForContent) {
    Class contentViewClass = [[self class] contentViewClass];
    NSAssert(contentViewClass, @"Not contentViewClass. You forgot to implement contentViewClass class method?");
    _viewForContent = [[contentViewClass alloc] init];
    [self setupContentView:_viewForContent];
  }
  return _viewForContent;
}

@end
