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

- (void)setHeaderText:(NSString *)headerText collectionView:(UICollectionView *)collectionView section:(NSInteger)section {
  if (!_headerTexts) {
    _headerTexts = [NSMutableDictionary dictionary];
    // TODO: Fix header
    [collectionView registerClass:UILabel.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
  }
  [_headerTexts setObject:headerText forKey:@(section)];
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

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//  GHUICollectionViewLabel *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
//  NSString *text = [self headerTextForSection:indexPath.section];
//  view.label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
//  view.label.textColor = [UIColor colorWithRed:255.0f/255.0f green:125.0f/255.0f blue:0.0f/255.0f alpha:1.0];
//  view.label.font = [UIFont systemFontOfSize:18];
//  view.label.insets = UIEdgeInsetsMake(0, 10, 0, 10);
//  [view.label setBorderStyle:GHUIBorderStyleTopBottom color:[UIColor colorWithWhite:230.0f/255.0f alpha:1.0] width:1.0 cornerRadius:0];
//  view.label.text = text;
//  return view;
//}

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

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//  if ([self countForSection:section] == 0) return CGSizeZero;
//  NSString *text = [self headerTextForSection:section];
//  if (text) return CGSizeMake(320, 38); // TODO: Configurable size
//  return CGSizeZero;
//}

@end
