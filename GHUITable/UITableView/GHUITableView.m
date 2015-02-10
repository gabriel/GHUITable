//
//  GHUITableView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableView.h"

#import "GHUITableViewDataSource.h"

@interface GHUITableView ()
@property GHUITableViewDataSource *defaultDataSource; // Default dataSource/delegate used in init
@end

@implementation GHUITableView

- (void)sharedInit {
  [self resetDataSource];
  
  self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  if ((self = [super initWithFrame:frame style:style])) {
    [self sharedInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self sharedInit];
  }
  return self;
}

+ (instancetype)tableView {
  return [[self.class alloc] init];
}

+ (instancetype)groupedTableView {
  return [[self.class alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
}

- (void)resetDataSource {
  _defaultDataSource = [[GHUITableViewDataSource alloc] init];
  self.dataSource = _defaultDataSource;
  self.delegate = _defaultDataSource;
  [self reloadData];
}

- (void)setObjects:(NSArray *)objects animated:(BOOL)animated {
  [self setObjects:objects section:0 animated:animated];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPathsToRemove = [NSMutableArray array];
  NSMutableArray *indexPathsToAdd = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource setObjects:objects section:section indexPathsToRemove:&indexPathsToRemove indexPathsToAdd:&indexPathsToAdd];
  if (animated) {
    [self deleteRowsAtIndexPaths:indexPathsToRemove withRowAnimation:UITableViewRowAnimationAutomatic];
    [self insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)insertObjects:(NSArray *)objects section:(NSInteger)section position:(NSInteger)position animated:(BOOL)animated {
  if (position < 0) position = 0;
  NSMutableArray *indexPaths = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource insertObjects:objects section:section position:position indexPaths:&indexPaths];
  if (animated) {
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)addObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPaths = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource addObjects:objects section:section indexPaths:&indexPaths];
  if (animated) {
    [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)addOrUpdateObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPathsToAdd = [NSMutableArray array];
  NSMutableArray *indexPathsToUpdate = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource addOrUpdateObjects:objects section:section indexPathsToAdd:&indexPathsToAdd indexPathsToUpdate:&indexPathsToUpdate];
  if (animated) {
    if ([indexPathsToUpdate count] > 0) [self reloadRowsAtIndexPaths:indexPathsToUpdate withRowAnimation:(animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone)];
    if ([indexPathsToAdd count] > 0) [self insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:(animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone)];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPathsToAdd = [NSMutableArray array];
  NSMutableArray *indexPathsToUpdate = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource replaceObjects:replaceObjects withObjects:objects section:section indexPathsToAdd:&indexPathsToAdd indexPathsToUpdate:&indexPathsToUpdate];
  if (animated) {
    if ([indexPathsToUpdate count] > 0) [self reloadRowsAtIndexPaths:indexPathsToUpdate withRowAnimation:(animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone)];
    if ([indexPathsToAdd count] > 0) [self insertRowsAtIndexPaths:indexPathsToAdd withRowAnimation:(animated ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone)];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)moveObject:(id)object indexPath:(NSIndexPath *)indexPath section:(NSInteger)section animated:(BOOL)animated {
  NSIndexPath *fromIndexPath = [self.dataSource indexPathOfObject:object section:section];
  
  if (animated) [self beginUpdates];
  
  [self.dataSource removeObjectAtIndexPath:fromIndexPath];
  [self.dataSource insertObject:object indexPath:indexPath];
  
  if (animated) {
    [self moveRowAtIndexPath:fromIndexPath toIndexPath:indexPath];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (NSIndexPath *)reloadObject:(id)object section:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)rowAnimation {
  NSIndexPath *indexPath = [self.dataSource indexPathOfObject:object section:section];
  
  //NSAssert(indexPath, @"Missing object");
  if (indexPath) {
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
  }
  return indexPath;
}

- (void)removeObjects:(NSArray *)objects section:(NSInteger)section animated:(BOOL)animated {
  NSMutableArray *indexPaths = [NSMutableArray array];
  if (animated) [self beginUpdates];
  [self.dataSource removeObjects:objects section:section indexPaths:&indexPaths];
  if (animated) {
    [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
  } else {
    [self reloadData];
  }
}

- (void)registerClasses:(NSArray */*of Class*/)classes {
  for (Class clazz in classes) {
    [self registerClass:clazz forCellReuseIdentifier:NSStringFromClass(clazz)];
  }
}

- (NSIndexPath *)lastIndexPath {
  return [self lastIndexPathForSection:self.dataSource.sectionCount - 1];
}

- (NSIndexPath *)lastIndexPathForSection:(NSInteger)section {
  for (NSInteger i = section; i >= 0; i--) {
    NSInteger count = [self.dataSource countForSection:i];
    if (count > 0) return [NSIndexPath indexPathForRow:count-1 inSection:i];
  }
  return nil;
}

- (void)scrollToLastIndexPathForSection:(NSInteger)section scrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
  NSIndexPath *indexPath = [self lastIndexPathForSection:section];
  if (indexPath) {
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
  }
}

- (void)scrollToLastIndexPathAtScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
  NSIndexPath *indexPath = [self lastIndexPath];
  if (indexPath) {
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
  }
}

@end
