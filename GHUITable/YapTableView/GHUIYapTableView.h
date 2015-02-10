//
//  GHUIYapTableView.h
//  GHUIKit
//
//  Created by Gabriel on 8/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GHUITableView.h"
#import "GHUIYapTableViewDataSource.h"

#import <YapDatabase/YapDatabase.h>
#import <YapDatabase/YapDatabaseView.h>

@class GHUIYapTableView;

@protocol GHUIYapTableViewDelegate <NSObject>
@optional
- (void)tableViewDidChange:(GHUIYapTableView *)tableView;
@end

@interface GHUIYapTableView : GHUITableView

@property (readonly) YapDatabaseViewMappings *mappings;
@property (weak) id<GHUIYapTableViewDelegate> yapDelegate;

- (void)setDatabase:(YapDatabase *)database collection:(NSString *)collection groupingBlock:(YapDatabaseViewGroupingBlock)groupingBlock groupFilterBlock:(YapDatabaseViewMappingGroupFilter)groupFilterBlock groupSortBlock:(YapDatabaseViewMappingGroupSort)groupSortBlock sortingBlock:(YapDatabaseViewSortingBlock)sortingBlock completion:(void (^)(GHUIYapTableView *tableView, GHUIYapTableViewDataSource *dataSource))completion;

- (void)setDatabase:(YapDatabase *)database collection:(NSString *)collection completion:(void (^)(GHUIYapTableView *tableView, GHUIYapTableViewDataSource *dataSource))completion;

- (void)setDatabase:(YapDatabase *)database extension:(NSString *)extension groups:(NSArray *)groups;


@end
