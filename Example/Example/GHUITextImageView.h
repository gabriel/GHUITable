//
//  GHUITextImageView.h
//  GHUITable
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GHUITable/GHUITable.h>

// Uses YOLayout because of dynamic cells, you should try it! :)
#import <YOLayout/YOLayout.h>

@interface GHUITextImageView : YOView

- (NSString *)name;

- (void)setName:(NSString *)name description:(NSString *)description image:(UIImage *)image;

- (void)setName:(NSString *)name description:(NSString *)description imageURLString:(NSString *)imageURLString;

@end

@interface GHUITextImageCell : GHUITableViewCell
@end

