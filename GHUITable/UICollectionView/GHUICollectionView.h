//
//  GHUICollectionView.h
//  GHUIKit
//
//  Created by Gabriel Handford on 10/23/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewDataSource.h"

@class GHUICollectionView;

typedef void (^GHUICollectionViewRefreshBlock)(GHUICollectionView *collectionView);

@interface GHUICollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) GHUICollectionViewDataSource *dataSource;

@property (readonly) UIRefreshControl *refreshControl;
@property (copy) GHUICollectionViewRefreshBlock refreshBlock;
@property CGFloat minimumLineSpacing;

/*!
 Shared init.
 */
- (void)sharedInit;


- (void)addObjects:(NSArray *)objects section:(NSInteger)section completion:(void (^)(BOOL finished))completion;
- (void)removeObjects:(NSArray *)objects section:(NSInteger)section completion:(void (^)(BOOL finished))completion;

/*!
 Set refreshing indicator.
 
 @param refreshing YES if refreshing
 */
- (void)setHeaderRefreshing:(BOOL)refreshing;

/*!
 Enable or disable the header.
 
 @param enabled YES to enable
 */
- (void)setRefreshHeaderEnabled:(BOOL)enabled;

/*!
 Check if refresh header is enabled.
 */
- (BOOL)isRefreshHeaderEnabled;

/*!
 Check if header is refreshing.
 */
- (BOOL)isHeaderRefreshing;

- (void)scrollToBottom:(BOOL)animated topOffset:(CGFloat)topOffset;

- (void)scrollToBottomAfterReload:(BOOL)animated topOffset:(CGFloat)topOffset;

- (void)registerCellClass:(Class)cellClass;

@end