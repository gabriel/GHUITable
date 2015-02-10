//
//  GHUIExampleTableView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 4/8/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIExampleStaticTableView.h"

#import <GHUITable/GHUITable.h>

#import "GHUITextImageCell.h"
#import "GHUISwitchCell.h"

@interface GHUIExampleStaticTableView ()
@property GHUITableView *tableView;
@end

@implementation GHUIExampleStaticTableView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (void)viewInit {
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];

  // You can add a view as a data object source.
  // In this scenario you are not re-using views and is appropriate for when you have static content.
  GHUITextImageView *view = [[GHUITextImageView alloc] init];
  [view setName:@"Name2" description:@"This is a description #2" image:[UIImage imageNamed:@"Preview2-Filled"]];
  [_tableView.dataSource addObjects:@[view] section:0];

  // You can also add a cell as a data object source.
  // In this scenario you are not re-using cells and is appropriate for when you have static content.
  GHUITextImageCell *cell1 = [[GHUITextImageCell alloc] init];
  [cell1.viewForContent setName:@"Name1" description:@"This is a description #1" image:[UIImage imageNamed:@"Preview2"]];

  // A switch view
  GHUISwitchView *switchView = [[GHUISwitchView alloc] init];
  [switchView setTitle:@"This is a switch cell" description:@"Description" on:YES];
  [_tableView.dataSource addObjects:@[switchView] section:1];
  
  _tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSString *object) {
    NSLog(@"Selected: %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  };
}

- (void)layoutSubviews {
  _tableView.frame = self.bounds;
}

@end
