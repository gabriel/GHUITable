//
//  GHUICollectionViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICellDataSource.h"

@interface GHUICollectionViewDataSource : GHUICellDataSource <UICollectionViewDataSource, UICollectionViewDelegate>

- (void)registerCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView;
- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView;
- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section;

#pragma mark Headers

- (void)setHeaderText:(NSString *)headerText collectionView:(UICollectionView *)collectionView section:(NSInteger)section;

@end
