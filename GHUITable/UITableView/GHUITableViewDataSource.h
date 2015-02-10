//
//  GHUITableViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"

typedef void (^GHUICellDeleteConfirmBlock)(BOOL shouldDelete);
typedef void (^GHUICellDeleteBlock)(UITableView *tableView, NSIndexPath *indexPath, id object, GHUICellDeleteConfirmBlock completion);
typedef UIView *(^GHUICellHeaderViewBlock)(UITableView *tableView, NSInteger section, NSString *text);

//typedef NSArray *(^GHUICellSectionTitlesBlock)(UITableView *tableView);
//typedef BOOL (^GHUICellCanMoveBlock)(UITableView *tableView, NSIndexPath *indexPath);

@interface GHUITableViewDataSource : GHUICellDataSource <UITableViewDataSource, UITableViewDelegate>

@property (copy) GHUICellHeaderViewBlock headerViewBlock;
@property (copy) GHUICellDeleteBlock deleteBlock;
//@property (copy) GHUICellCanMoveBlock canMoveBlock;
//@property (copy) GHUICellSectionTitlesBlock sectionTitlesBlock;

- (void)setCellClass:(Class)cellClass tableView:(UITableView *)tableView section:(NSInteger)section;

- (void)setHeaderText:(NSString *)headerText section:(NSInteger)section;

@end
