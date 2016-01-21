//
//  GHUICollectionViewCell.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/25/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewCell.h"

@interface GHUICollectionViewCell ()
@property (nonatomic) UIView *viewForContent;
@end

@implementation GHUICollectionViewCell

- (void)viewInit {
  UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
  backgroundView.backgroundColor = [UIColor whiteColor];
  self.backgroundView = backgroundView;
  
  UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
  selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:(217.0f/255.0f) alpha:1.0f];
  self.selectedBackgroundView = selectedBackgroundView;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if ((self = [super initWithCoder:aDecoder])) {
    [self viewInit];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.viewForContent.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [self.viewForContent sizeThatFits:size];
}

+ (Class)contentViewClass {
  // Abstract method
  return nil;
}

- (UIView *)viewForContent {
  if (!_viewForContent) {
    Class contentViewClass = [[self class] contentViewClass];
    NSAssert(contentViewClass, @"Not contentViewClass. You forgot to implement contentViewClass class method?");
    _viewForContent = [[contentViewClass alloc] init];
    [self.contentView addSubview:_viewForContent];
  }
  return _viewForContent;
}

@end
