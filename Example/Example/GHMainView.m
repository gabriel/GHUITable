//
//  GHMainView.m
//  Example
//
//  Created by Gabriel on 2/10/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "GHMainView.h"

#import <GHUITable/GHUITable.h>

#import "GHUITextImageView.h"
#import "GHUISwitchView.h"

@interface GHMainView ()
@property GHUITableView *tableView;
@end

@interface GHUIExampleTableViewController : UIViewController
@property NSString *className;
@end

@implementation GHMainView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (void)viewInit {
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];

  GHUITextImageView *view1 = [[GHUITextImageView alloc] init];
  [view1 setName:@"GHUIExampleTableView" description:@"This is a example of a GHUITableView with a single cell type and dynamic data." image:nil];

  GHUITextImageView *view2 = [[GHUITextImageView alloc] init];
  [view2 setName:@"GHUIExampleStaticTableView" description:@"This is a example of a GHUITableView with a static content (adding views to data source)." image:nil];

  GHUITextImageView *view3 = [[GHUITextImageView alloc] init];
  [view3 setName:@"GHUIExampleMultiCellTableView" description:@"This is a example of a GHUITableView with a different cell types based on the data and section." image:nil];

  GHUITextImageView *view4 = [[GHUITextImageView alloc] init];
  [view4 setName:@"GHUIExampleCollectionView" description:@"This is a example of a GHUICollectionView ." image:nil];

  [_tableView.dataSource addObjects:@[view1, view2, view3, view4] section:0];

  _tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, GHUITextImageView *view) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GHUIExampleTableViewController *exampleViewController = [[GHUIExampleTableViewController alloc] init];
    exampleViewController.className = view.name;
    [self.navigationController pushViewController:exampleViewController animated:YES];
  };
}

- (void)layoutSubviews {
  _tableView.frame = self.bounds;
}

@end

@implementation GHUIExampleTableViewController

- (void)loadView {
  self.title = self.className;
  self.view = [[NSClassFromString(self.className) alloc] init];
}

@end
