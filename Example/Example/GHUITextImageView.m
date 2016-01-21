//
//  GHUITextImageView.m
//  GHUITable
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITextImageView.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface GHUITextImageView ()
@property UILabel *nameLabel;
@property UILabel *descriptionLabel;
@property UIImageView *imageView;
@end

@implementation GHUITextImageView

- (void)viewInit {
  [super viewInit];
  self.backgroundColor = [UIColor clearColor];
  
  _imageView = [[UIImageView alloc] init];
  [self addSubview:_imageView];
  
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.font = [UIFont systemFontOfSize:16];
  _nameLabel.numberOfLines = 0;
  [self addSubview:_nameLabel];
  
  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.font = [UIFont systemFontOfSize:14];
  [self addSubview:_descriptionLabel];

  self.layout = [YOLayout layoutWithLayoutBlock:^CGSize(id<YOLayout> layout, CGSize size) {
    CGFloat x = 15;
    CGFloat y = 10;

    CGFloat minY = 0;
    if (_imageView.image || _imageView.sd_imageURL) {
      CGSize imageSize = [layout setFrame:CGRectMake(x, y, 50, 50) view:_imageView].size;
      x += imageSize.width;
      minY = y + 10;
    }

    y += [layout sizeToFitVerticalInFrame:CGRectMake(x, y, size.width - x - 5, 0) view:_nameLabel].size.height + 4;
    y += [layout sizeToFitVerticalInFrame:CGRectMake(x, y, size.width - x - 5, 0) view:_descriptionLabel].size.height + 10;

    if (y < minY) y = minY;

    return CGSizeMake(size.width, y);
  }];
}

- (NSString *)name {
  return _nameLabel.text;
}

- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image {
  _nameLabel.text = name;
  _descriptionLabel.text = description;
  _imageView.image = image;
  _imageView.hidden = !_imageView.image;
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

- (void)setName:(NSString *)name description:(NSString *)description imageURLString:(NSString *)imageURLString {
  _nameLabel.text = name;
  _descriptionLabel.text = description;
  _imageView.hidden = !imageURLString;
  if (imageURLString) [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
  [self setNeedsDisplay];
  [self setNeedsLayout];
}

@end


@implementation GHUITextImageCell

+ (Class)contentViewClass {
  return GHUITextImageView.class;
}

@end

@implementation GHUITextImageCollectionCell

+ (Class)contentViewClass {
  return GHUITextImageView.class;
}

@end
