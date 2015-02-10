//
//  GHUITableViewCell.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHUITableViewCell : UITableViewCell

+ (Class)contentViewClass;

- (id)viewForContent;

+ (GHUITableViewCell *)tableViewCellForContentView:(UIView *)contentView;

@end
