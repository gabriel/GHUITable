//
//  GHUISwitchView.h
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/31/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GHUITable/GHUITable.h>

@interface GHUISwitchView : UIView

@property UILabel *label;
@property UILabel *descriptionLabel;
@property UISwitch *switchView;

- (void)setTitle:(NSString *)title description:(NSString *)description on:(BOOL)on;

@end

@interface GHUISwitchCell : GHUITableViewCell
@end
