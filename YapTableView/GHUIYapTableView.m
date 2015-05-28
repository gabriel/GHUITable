//
//  GHUIYapTableView.m
//  GHUIKit
//
//  Created by Gabriel on 8/19/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIYapTableView.h"

@interface GHUIYapTableView ()
@property GHUIYapTableViewDataSource *yapDataSource;
@property YapDatabase *database;
@property YapDatabaseConnection *connection;
@property YapDatabaseViewMappings *mappings;
@property NSString *extension;
@end

@implementation GHUIYapTableView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDatabase:(YapDatabase *)database collection:(NSString *)collection completion:(void (^)(GHUIYapTableView *tableView, GHUIYapTableViewDataSource *dataSource))completion {
  NSString *group = [NSString stringWithFormat:@"%@-group", collection];
  YapDatabaseViewGroupingBlock groupingBlock = ^NSString *(NSString *collection, NSString *key, id object) {
    return group;
  };

  YapDatabaseViewSortingBlock sortingBlock = ^(NSString *group, NSString *collection1, NSString *key1, id obj1, NSString *collection2, NSString *key2, id obj2) {
    return NSOrderedSame;
  };

  YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:groupingBlock];
  YapDatabaseViewSorting *sorting = [YapDatabaseViewSorting withObjectBlock:sortingBlock];
  
  [self setDatabase:database collection:collection grouping:grouping groupFilterBlock:nil groupSortBlock:nil sorting:sorting completion:completion];
}

- (void)setDatabase:(YapDatabase *)database collection:(NSString *)collection grouping:(YapDatabaseViewGrouping *)grouping groupFilterBlock:(YapDatabaseViewMappingGroupFilter)groupFilterBlock groupSortBlock:(YapDatabaseViewMappingGroupSort)groupSortBlock sorting:(YapDatabaseViewSorting *)sorting completion:(void (^)(GHUIYapTableView *tableView, GHUIYapTableViewDataSource *dataSource))completion {
  _database = database;
  _extension = collection;
  
  YapDatabaseViewOptions *options = [[YapDatabaseViewOptions alloc] init];
  options.isPersistent = NO;
  YapWhitelistBlacklist *allowed = [[YapWhitelistBlacklist alloc] initWithWhitelist:[NSSet setWithArray:@[collection]]];
  options.allowedCollections = allowed;
  
  if (!groupFilterBlock) groupFilterBlock = ^BOOL(NSString *group, YapDatabaseReadTransaction *transaction) {
    return YES;
  };
  
  if (!groupSortBlock) groupSortBlock = ^NSComparisonResult(NSString *group1, NSString *group2, YapDatabaseReadTransaction *transaction) {
    return [group1 localizedCompare:group2];
  };

  YapDatabaseView *dbView = [[YapDatabaseView alloc] initWithGrouping:grouping sorting:sorting versionTag:nil options:options];
  
  __weak GHUIYapTableView *blockSelf = self;
  [database asyncRegisterExtension:dbView withName:_extension completionBlock:^(BOOL ready) {
    [blockSelf _setupMappings:database groups:nil groupFilterBlock:groupFilterBlock groupSortBlock:groupSortBlock];
    completion(self, blockSelf.yapDataSource);
    [blockSelf reloadData];
  }];
}

//- (void)clearDatabase {
//  [_database asyncUnregisterExtensionWithName:_extension completionBlock:nil];
//  GHUITableViewDataSource *dataSource = [[GHUITableViewDataSource alloc] init];
//  self.dataSource = dataSource;
//  self.delegate = dataSource;
//  [self reloadData];
//}

- (void)_setupMappings:(YapDatabase *)database groups:(NSArray *)groups groupFilterBlock:(YapDatabaseViewMappingGroupFilter)groupFilterBlock groupSortBlock:(YapDatabaseViewMappingGroupSort)groupSortBlock {
  _connection = [database newConnection];
  [_connection beginLongLivedReadTransaction];
  
  if (groupFilterBlock) {
    _mappings = [[YapDatabaseViewMappings alloc] initWithGroupFilterBlock:groupFilterBlock sortBlock:groupSortBlock view:_extension];
  } else {
    _mappings = [[YapDatabaseViewMappings alloc] initWithGroups:groups view:_extension];
  }
  __weak GHUIYapTableView *blockSelf = self;
  [_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
    [blockSelf.mappings updateWithTransaction:transaction];
  }];
  
  _yapDataSource = [[GHUIYapTableViewDataSource alloc] init];
  _yapDataSource.connection = _connection;
  _yapDataSource.mappings = _mappings;
  self.dataSource = _yapDataSource;
  self.delegate = _yapDataSource;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yapDatabaseModified:) name:YapDatabaseModifiedNotification object:database];
}

- (void)setDatabase:(YapDatabase *)database extension:(NSString *)extension groups:(NSArray *)groups {
  NSParameterAssert(database);
  _database = database;
  _extension = extension;
  [self _setupMappings:database groups:groups groupFilterBlock:nil groupSortBlock:nil];
}

- (void)yapDatabaseModified:(NSNotification *)notification {
  NSArray *notifications = [_connection beginLongLivedReadTransaction];
  
  NSArray *sectionChanges = nil;
  NSArray *rowChanges = nil;
  [[_connection ext:_extension] getSectionChanges:&sectionChanges rowChanges:&rowChanges forNotifications:notifications withMappings:_mappings];
  
  if ([sectionChanges count] == 0 & [rowChanges count] == 0) {
    return;
  }
  
  [self beginUpdates];
  
  for (YapDatabaseViewSectionChange *sectionChange in sectionChanges) {
    switch (sectionChange.type) {
      case YapDatabaseViewChangeDelete: {
        [self deleteSections:[NSIndexSet indexSetWithIndex:sectionChange.index] withRowAnimation:UITableViewRowAnimationAutomatic];
        break;
      }
      case YapDatabaseViewChangeInsert: {
        [self insertSections:[NSIndexSet indexSetWithIndex:sectionChange.index] withRowAnimation:UITableViewRowAnimationAutomatic];
        break;
      }
      default:
        break;
    }
  }
  
  for (YapDatabaseViewRowChange *rowChange in rowChanges) {
    switch (rowChange.type) {
      case YapDatabaseViewChangeDelete: {
        [self deleteRowsAtIndexPaths:@[rowChange.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        break;
      }
      case YapDatabaseViewChangeInsert: {
        [self insertRowsAtIndexPaths:@[rowChange.newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        break;
      }
      case YapDatabaseViewChangeMove: {
        [self deleteRowsAtIndexPaths:@[rowChange.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self insertRowsAtIndexPaths:@[rowChange.newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        break;
      }
      case YapDatabaseViewChangeUpdate: {
        [self reloadRowsAtIndexPaths:@[rowChange.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        break;
      }
    }
  }
  
  [self endUpdates];
  
  if ([self.yapDelegate respondsToSelector:@selector(tableViewDidChange:)]) {
    [self.yapDelegate tableViewDidChange:self];
  }
}

@end
