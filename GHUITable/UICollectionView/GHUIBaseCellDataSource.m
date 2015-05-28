//
//  GHUIBaseCellDataSource.m
//  GHUIKit
//
//  Created by Gabriel on 8/18/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIBaseCellDataSource.h"

#import <GHKit/GHCGUtils.h>

@implementation GHUIBaseCellDataSource

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  [NSException raise:@"" format:@"Subclasses should implement this method"];
  return nil;
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
  if (self.classBlock) {
    id object = [self objectAtIndexPath:indexPath];
    return self.classBlock(object, indexPath);
  }
  
  Class cellClass = [_cellClasses objectForKey:@(indexPath.section)];
  if (!cellClass) cellClass = [_cellClasses objectForKey:@(-1)];
  return cellClass;
}

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath view:(UIView */*UITableView or UICollectionView*/)view {
  if (GHCGSizeIsEqual(view.bounds.size, CGSizeZero)) return CGSizeZero;
  
  id object = [self objectAtIndexPath:indexPath];
  
  // If object is UITableViewCell (no re-use)
  if ([object isKindOfClass:[UITableViewCell class]]) {
    return [object sizeThatFits:view.bounds.size];
  }
  
  // If object is UIView (no re-use)
  if ([object isKindOfClass:[UIView class]]) {
    return [object sizeThatFits:view.bounds.size];
  }
  
  if (_cacheEnabled) {
    NSValue *sizeCacheValue = [_sizeCache objectForKey:indexPath];
    if (sizeCacheValue) return [sizeCacheValue CGSizeValue];
  }
  
  //
  // We can't dequeue because that will call this method and infinite recurse.
  //
  
  Class cellClass = [self cellClassForIndexPath:indexPath];
  NSAssert(cellClass, @"No cell class for indexPath: %@", indexPath);
  if (!_cellsForSizing) _cellsForSizing = [NSMutableDictionary dictionary];
  id cellForSizing = _cellsForSizing[NSStringFromClass(cellClass)];
  BOOL cached = YES;
  if (!cellForSizing) {
    cached = NO;
    cellForSizing = [[cellClass alloc] init];
    _cellsForSizing[NSStringFromClass(cellClass)] = cellForSizing;
  }
  
  [cellForSizing setNeedsLayout];
  self.cellSetBlock(cellForSizing, object, indexPath, view, cached);
  
  if (self.sizeBlock) {
    return self.sizeBlock(cellForSizing, object, indexPath, view);
  }
  
  //NSAssert(!GHCGSizeIsEqual(view.bounds.size, CGSizeZero), @"View size is empty");
  
  CGSize size = [cellForSizing sizeThatFits:view.bounds.size];
  
  //NSLog(@"(%@) %d.%d size: %@ in %@", [cellForSizing class], indexPath.section, indexPath.row, NSStringFromCGSize(size), NSStringFromCGSize(view.bounds.size));
  
  if (!self.sizeBlock && _cacheEnabled) {
    if (!_sizeCache) _sizeCache = [NSMutableDictionary dictionary];
    [_sizeCache setObject:[NSValue valueWithCGSize:size] forKey:indexPath];
  }
  
  return size;
}

- (NSString *)headerTextForSection:(NSInteger)section {
  return [_headerTexts objectForKey:@(section)];
}

@end
