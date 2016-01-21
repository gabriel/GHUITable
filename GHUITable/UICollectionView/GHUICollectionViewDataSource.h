//
//  GHUICollectionViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"

typedef void (^GHUICellCollectionHeaderViewBlock)(UICollectionView *collectionView, UICollectionReusableView *view, NSInteger section);

@interface GHUICollectionViewDataSource : GHUICellDataSource <UICollectionViewDataSource, UICollectionViewDelegate>

@property (copy) GHUICellCollectionHeaderViewBlock headerViewBlock;

- (void)registerCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView;
- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView;
- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section;

@end
