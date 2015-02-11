//
//  GHUIExampleDataTableView.m
//  Example
//
//  Created by Gabriel on 2/10/15.
//  Copyright (c) 2015 Gabriel Handford. All rights reserved.
//

#import "GHUIExampleTableView.h"

#import "GHUITextImageView.h"

@interface GHUIExampleTableView ()
@property GHUITableView *tableView;
@end

@implementation GHUIExampleTableView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (void)viewInit {
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];

  // These are all the cells that will be used
  [_tableView registerClasses:@[GHUITextImageCell.class]];

  // This block returns the cell class.
  // It can be base on the data or section, or (in this case) can be constant.
  _tableView.dataSource.classBlock = ^Class(id object, NSIndexPath *indexPath) {
    return GHUITextImageCell.class;
  };

  // Set the data on the cell
  _tableView.dataSource.cellSetBlock = ^(GHUITextImageCell *cell, NSDictionary *dict, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
    [cell.viewForContent setName:dict[@"name"] description:dict[@"description"] image:[UIImage imageNamed:dict[@"imageName"]]];
  };
  _tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSString *object) {
    NSLog(@"Selected: %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  };

  // Headers
  [_tableView.dataSource setHeaderText:@"Section 1" section:0];
  [_tableView.dataSource setHeaderText:@"Section 2" section:1];
  [_tableView.dataSource setHeaderText:@"Section 3 (Switch)" section:2];

  // Set header view
  _tableView.dataSource.headerViewBlock = ^(UITableView *tableView, NSInteger section, NSString *text) {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 21)];
    label.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    label.text = [text uppercaseString];
    return label;
  };

  // The data
  [_tableView setObjects:
   @[
     @{@"name": @"Name1", @"description": @"This is a description #1", @"imageName": @"Preview2"},
     @{@"name": @"Name2", @"description": @"This is a description #2", @"imageName": @"Preview2-Filled"}] animated:NO];

  [_tableView setObjects:
   @[
     @{@"name": @"Gastropub swag pork belly, butcher selvage mustache chambray scenester pour-over.",
       @"description": @"Cosby sweater stumptown Carles letterpress, roof party deep v gastropub next level. Tattooed bitters distillery, scenester PBR&B pork belly swag twee DIY. Mixtape plaid Carles photo booth sustainable you probably haven't heard of them. Vice normcore fap Thundercats Williamsburg Truffaut paleo small batch, plaid PBR&B Brooklyn jean shorts. Next level lomo direct trade farm-to-table, cred hoodie post-ironic fingerstache pop-up put a bird on it. Keytar PBR literally, DIY Bushwick Pinterest bicycle rights.",
       @"imageName": @"Preview2"},
     @{@"name": @"YOLO irony beard",
       @"description": @"Raw denim Tumblr roof party beard gentrify pickled, art party ethical",
       @"imageName": @"http://placehold.it/350x150"}
     ] section:1 animated:NO];
}

- (void)layoutSubviews {
  _tableView.frame = self.bounds;
}

@end