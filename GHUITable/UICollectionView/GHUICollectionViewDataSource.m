//
//  GHUICollectionViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 11/1/13.
//  Copyright (c) 2013 Gabriel Handford. All rights reserved.
//

#import "GHUICollectionViewDataSource.h"
#import "GHUICollectionViewCell.h"
#import <GHKit/GHNSArray+Utils.h>

@implementation GHUICollectionViewDataSource

- (void)registerCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView {
  [collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView {
  [self setCellClass:cellClass collectionView:collectionView section:-1];
}

- (void)setCellClass:(Class)cellClass collectionView:(UICollectionView *)collectionView section:(NSInteger)section {
  //NSAssert(section > 0, @"Section must be > 0");
  if (!_cellClasses) _cellClasses = [[NSMutableDictionary alloc] init];
  [_cellClasses setObject:cellClass forKey:@(section)];
  [collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSInteger count = [self countForSection:section];
  //NSLog(@"numberOfItemsInSection:%d = %d", section, count);
  return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassForIndexPath:indexPath];
  id cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
  BOOL dequeued = YES;
  if (!cell) {
    dequeued = NO;
    cell = [[cellClass alloc] init];
  }
  self.cellSetBlock(cell, [self objectAtIndexPath:indexPath], indexPath, collectionView, dequeued);
  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  NSInteger sectionCount = [self sectionCount];
  if (sectionCount == 0) return 1; // Always need at least 1 section
  //NSLog(@"sectionCount = %d", sectionCount);
  return sectionCount;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if (!self.headerViewBlock) return nil;

  if (kind == UICollectionElementKindSectionHeader) {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    return self.headerViewBlock(collectionView, view, indexPath.section);
  }

  return nil;
}

#pragma mark UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self sizeForCellAtIndexPath:indexPath view:collectionView];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  if ([self countForSection:section] == 0) {
    return UIEdgeInsetsZero;
  }
  return self.sectionInset;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    self.selectBlock(collectionView, indexPath, object);
  }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.shouldSelectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    return self.shouldSelectBlock(collectionView, indexPath, object);
  }
  return (self.selectBlock != NULL);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  if ([self countForSection:section] == 0) return CGSizeZero;
  if (!self.headerViewBlock) return CGSizeZero;

  UICollectionReusableView *view = self.headerViewBlock(collectionView, nil, section);
  if (!view) return CGSizeZero;
  return [view sizeThatFits:collectionView.frame.size];
}

@end
