//
//  GHUICollectionView.m
//  GHUIKit
//
//  Created by Gabriel Handford on 10/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionView.h"

@interface GHUICollectionView ()
@property GHUICollectionViewDataSource *defaultDataSource; // Default dataSource/delegate used in init
@end

@protocol GHUICollectionViewInvalidate
- (void)invalidateAll;
@end


@implementation GHUICollectionView

@dynamic dataSource;

- (void)viewInit {
  _defaultDataSource = [[GHUICollectionViewDataSource alloc] init];
  self.dataSource = _defaultDataSource;
  self.delegate = _defaultDataSource;

  self.alwaysBounceVertical = YES;
  [self setMinimumLineSpacing:1];
}

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    [self viewInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]])) {
    [self viewInit];
  }
  return self;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing {
  if (self.collectionViewLayout && [self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing = minimumLineSpacing;
  } else {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = minimumLineSpacing;
    self.collectionViewLayout = flowLayout;
  }
}

- (CGFloat)minimumLineSpacing {
  if (self.collectionViewLayout && [self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
    return ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing;
  }
  return 0;
}

- (void)addObjects:(NSArray *)objects section:(NSInteger)section completion:(void (^)(BOOL finished))completion {
  __typeof__(self) __weak blockSelf = self;
  [self performBatchUpdates:^(){
    NSMutableArray *indexPaths = [NSMutableArray array];
    [blockSelf.dataSource removeObjects:objects section:section indexPaths:indexPaths];
    [blockSelf deleteItemsAtIndexPaths:indexPaths];
  } completion:completion];
}

- (void)removeObjects:(NSArray *)objects section:(NSInteger)section completion:(void (^)(BOOL finished))completion {
  __typeof__(self) __weak blockSelf = self;
  [self performBatchUpdates:^(){
    NSMutableArray *indexPaths = [NSMutableArray array];
    [blockSelf.dataSource removeObjects:objects section:section indexPaths:indexPaths];
    [blockSelf deleteItemsAtIndexPaths:indexPaths];
  } completion:completion];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section {
  [self.dataSource setObjects:objects section:section];
  [self reloadData];
}

- (void)setObjects:(NSArray *)objects section:(NSInteger)section completion:(void (^)(BOOL finished))completion {
  [self performBatchUpdates:^(){
    NSMutableArray *indexPathsToRemove = [NSMutableArray array];
    NSMutableArray *indexPathsToAdd = [NSMutableArray array];
    [self.dataSource setObjects:objects section:section indexPathsToRemove:indexPathsToRemove indexPathsToAdd:indexPathsToAdd];
    [self deleteItemsAtIndexPaths:indexPathsToRemove];
    [self insertItemsAtIndexPaths:indexPathsToAdd];
  } completion:completion];
}

// Forces reloadData to invalidate a cache in the datasource if present
- (void)reloadData {
  if ([self.dataSource respondsToSelector:@selector(invalidateAll)]) {
    [self.dataSource performSelector:@selector(invalidateAll)];
  }
  [super reloadData];
}

- (void)setHeaderRefreshing:(BOOL)refreshing {
  if (refreshing && !_refreshControl.refreshing) {
    [_refreshControl beginRefreshing];
  } else if (!refreshing && _refreshControl.refreshing) {
    [_refreshControl endRefreshing];
  }
}

- (void)setRefreshHeaderEnabled:(BOOL)enabled {
  if (enabled && !_refreshControl) {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_refreshControl];
  } else if (!enabled) {
    [_refreshControl removeFromSuperview];
    _refreshControl = nil;
  }
  [self setNeedsLayout];
}

- (BOOL)isHeaderRefreshing {
  return _refreshControl.isRefreshing;
}

- (BOOL)isRefreshHeaderEnabled {
  return !!_refreshControl;
}

- (void)refresh {
  if (self.refreshBlock) self.refreshBlock(self);
}

- (void)scrollToBottom:(BOOL)animated topOffset:(CGFloat)topOffset {  
  CGFloat bottomOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height + self.contentInset.bottom).y;
  if (bottomOffset + topOffset > 0) {
    [self setContentOffset:CGPointMake(0, bottomOffset) animated:animated];
  }
}

- (void)registerCellClass:(Class)cellClass {
  [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerClasses:(NSArray */*of Class*/)classes {
  for (Class clazz in classes) {
    [self registerClass:clazz forCellWithReuseIdentifier:NSStringFromClass(clazz)];
  }
}

- (void)scrollToBottomAfterReload:(BOOL)animated topOffset:(CGFloat)topOffset {
  // If you call reloadData right before this method, contentSize isn't updated, so lets do this in a completion block
  [self performBatchUpdates:^() {} completion:^(BOOL finished) {
    [self scrollToBottom:animated topOffset:topOffset];
  }];
}

@end
