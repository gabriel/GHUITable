//
//  GHUIMultiCellTableView.m
//  GHUICatalog
//
//  Created by Gabriel Handford on 3/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <GHUITable/GHUITable.h>

#import "GHUIExampleMultiCellTableView.h"

#import "GHUITextImageCell.h"
#import "GHUISwitchCell.h"

@interface GHUIExampleMultiCellTableView ()
@property GHUITableView *tableView;
@end

@implementation GHUIExampleMultiCellTableView

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    [self viewInit];
  }
  return self;
}

- (void)viewInit {
  _tableView = [[GHUITableView alloc] init];
  [self addSubview:_tableView];

  // These are all the cells that will be used.
  [_tableView registerClasses:@[GHUISwitchCell.class, GHUITextImageCell.class]];

  // This block chooses the cell class based on the section, but you could also do it based on the data.
  _tableView.dataSource.classBlock = ^Class(NSDictionary *object, NSIndexPath *indexPath) {
    if (indexPath.section == 2) return GHUISwitchCell.class;
    return GHUITextImageCell.class;
  };
  
  _tableView.dataSource.cellSetBlock = ^(GHUITableViewCell *cell, NSDictionary *dict, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
    if (indexPath.section == 0) {
      [cell.viewForContent setName:dict[@"name"] description:dict[@"description"] image:[UIImage imageNamed:dict[@"imageName"]]];
    } else if (indexPath.section == 1) {
      [cell.viewForContent setName:dict[@"name"] description:dict[@"description"] imageURLString:dict[@"imageURLString"]];
    } else if (indexPath.section == 2) { // or [cell isKindOfClass:GHUISwitchCell.class]
      [cell.viewForContent setTitle:dict[@"title"] description:dict[@"description"] on:[dict[@"on"] boolValue]];
    }
  };
  _tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, NSString *object) {
    NSLog(@"Selected: %@", indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  };

  // Set headers
  [_tableView.dataSource setHeaderText:@"Section 1" section:0];
  [_tableView.dataSource setHeaderText:@"Section 2 (Image URL)" section:1];
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

  // Section 1
  [_tableView setObjects:
   @[
     @{@"name": @"Name1", @"description": @"This is a description #1", @"imageName": @"Preview2"},
     @{@"name": @"Name2", @"description": @"This is a description #2", @"imageName": @"Preview2-Filled"}] animated:NO];

  // Section 2
  [_tableView setObjects:
   @[
     @{@"name": @"Gastropub swag pork belly, butcher selvage mustache chambray scenester pour-over.",
       @"description": @"Cosby sweater stumptown Carles letterpress, roof party deep v gastropub next level. Tattooed bitters distillery, scenester PBR&B pork belly swag twee DIY. Mixtape plaid Carles photo booth sustainable you probably haven't heard of them. Vice normcore fap Thundercats Williamsburg Truffaut paleo small batch, plaid PBR&B Brooklyn jean shorts. Next level lomo direct trade farm-to-table, cred hoodie post-ironic fingerstache pop-up put a bird on it. Keytar PBR literally, DIY Bushwick Pinterest bicycle rights.",
       @"imageURLString": @"http://placehold.it/50x50"},
     @{@"name": @"YOLO irony beard",
       @"description": @"Raw denim Tumblr roof party beard gentrify pickled, art party ethical",
       @"imageURLString": @"http://placehold.it/350x150"}
     ] section:1 animated:NO];

  // Section 3
  [_tableView setObjects:
   @[
     @{@"title": @"Normcore pug ennui",
       @"description": @"Vice Brooklyn salvia bicycle",
       @"on": @(YES)},
     @{@"title": @"3 wolf moon flexitarian axe",
       @"description": @"put a bird on it",
       @"on": @(NO)}
     ] section:2 animated:NO];
}

- (void)layoutSubviews {
  _tableView.frame = self.bounds;
}

@end


// TODO: Example for swipe cells

//_tableView.dataSource.cellSetBlock = ^(id cell, NSDictionary *dict, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
//  // If we are a swipe cell set that up
//  if ([cell respondsToSelector:@selector(setAppearanceWithBlock:tableView:force:)]) {
//    __weak GHUICatalogCell *weakCell = cell;
//    [cell setAppearanceWithBlock:^{
//      NSMutableArray *rightButtons = [NSMutableArray array];
//      [rightButtons addObject:[weakCell rightButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More" index:1]];
//      [rightButtons addObject:[weakCell rightButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete" index:2]];
//      [weakCell setRightButtons:rightButtons];
//    } tableView:tableView force:NO];
//
//    weakCell.delegate = blockSelf;
//  }