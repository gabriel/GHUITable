//
//  GHUITableView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewDataSource.h"

@interface GHUITableView : UITableView

// nonatomic, assign because of UITableView dataSource
@property (nonatomic, assign) GHUITableViewDataSource *dataSource;

+ (instancetype)tableView;
+ (instancetype)groupedTableView;

- (void)registerClasses:(NSArray */*of Class*/)classes;

- (void)setObjects:(NSArray *)objects animated:(BOOL)animated;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;

- (void)addObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;
- (void)removeObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;

- (void)insertObjects:(NSArray *)objects section:(NSInteger)section position:(NSInteger)position animated:(BOOL)animated;

- (void)addOrUpdateObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;
- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated;

- (NSIndexPath *)reloadObject:(id)object section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation;

- (void)moveObject:(id)object indexPath:(NSIndexPath *)indexPath section:(NSInteger)section animated:(BOOL)animated;

- (void)resetDataSource;

- (NSIndexPath *)lastIndexPath;
- (NSIndexPath *)lastIndexPathForSection:(NSInteger)section;
- (void)scrollToLastIndexPathAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToLastIndexPathForSection:(NSInteger)section scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

@end
