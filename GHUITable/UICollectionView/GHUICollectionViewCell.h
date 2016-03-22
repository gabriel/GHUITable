//
//  GHUICollectionViewCell.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/25/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface GHUICollectionViewCell : UICollectionViewCell

+ (Class)contentViewClass;

- (id)viewForContent;

+ (GHUICollectionViewCell *)collectionViewCellForContentView:(UIView *)contentView;

- (void)setViewForContent:(UIView *)viewForContent;

@end
