//
//  GHUIExampleCollectionView.m
//  Example
//
//  Created by Gabriel on 1/20/16.
//  Copyright © 2016 Gabriel Handford. All rights reserved.
//

#import "GHUIExampleCollectionView.h"

#import "GHUITextImageView.h"
#import "GHHeaderLabel.h"

@interface GHUIExampleCollectionView ()
@property GHUICollectionView *view;
@end

@implementation GHUIExampleCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (void)viewInit {
  _view = [[GHUICollectionView alloc] init];
  _view.backgroundColor = [UIColor grayColor];
  [self addSubview:_view];

  // These are all the cells that will be used, usually it's just one.
  [_view registerClasses:@[GHUITextImageCollectionCell.class]];

  // This block returns the cell class.
  // It can be based on the data or section, or (in this case) can be constant.
  _view.dataSource.classBlock = ^Class(id object, NSIndexPath *indexPath) {
    return GHUITextImageCollectionCell.class;
  };

  // Set the data on the cell.
  _view.dataSource.cellSetBlock = ^(id cell, NSDictionary *dict, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
    [((GHUITextImageCollectionCell *)cell).viewForContent setName:dict[@"name"] description:dict[@"description"] image:[UIImage imageNamed:dict[@"imageName"]]];
  };

  // Set what happens when a user selects a cell.
  _view.dataSource.selectBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath, NSString *object) {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"Selected: %@", indexPath);
    // Do something
  };

  // Set header view
  [_view registerHeaderClass:GHHeaderLabel.class];
  _view.dataSource.headerViewBlock = ^UICollectionReusableView *(UICollectionView *collectionView, GHHeaderLabel *view, NSInteger section) {
    if (section == 2) return nil;
    if (!view) view = [[GHHeaderLabel alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    view.text = [NSString stringWithFormat:@"Section %@", @(section)];
    [view sizeToFit];
    return view;
  };

  // The data
  [_view setObjects:
   @[
     @{@"name": @"Name1", @"description": @"This is a description #1", @"imageName": @"Preview2"},
     @{@"name": @"Name2", @"description": @"This is a description #2", @"imageName": @"Preview2-Filled"}] section:0];

  [_view setObjects:
   @[
     @{@"name": @"Gastropub swag pork belly, butcher selvage mustache chambray scenester pour-over.",
       @"description": @"Cosby sweater stumptown Carles letterpress, roof party deep v gastropub next level. Tattooed bitters distillery, scenester PBR&B pork belly swag twee DIY. Mixtape plaid Carles photo booth sustainable you probably haven't heard of them. Vice normcore fap Thundercats Williamsburg Truffaut paleo small batch, plaid PBR&B Brooklyn jean shorts. Next level lomo direct trade farm-to-table, cred hoodie post-ironic fingerstache pop-up put a bird on it. Keytar PBR literally, DIY Bushwick Pinterest bicycle rights.",
       @"imageName": @"Preview2"},
     @{@"name": @"YOLO irony beard",
       @"description": @"Raw denim Tumblr roof party beard gentrify pickled, art party ethical",
       @"imageName": @"Preview2"}
     ] section:1];

  [_view setObjects:
   @[
     @{@"name": @"Name1", @"description": @"This is a description #1", @"imageName": @"Preview2"}] section:2];
}

- (void)layoutSubviews {
  _view.frame = self.bounds;
}

@end
