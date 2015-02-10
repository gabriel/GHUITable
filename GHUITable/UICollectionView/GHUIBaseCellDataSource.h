//
//  GHUIBaseCellDataSource.h
//  GHUIKit
//
//  Created by Gabriel on 8/18/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef Class (^GHUICellClassBlock)(id object, NSIndexPath *indexPath);
typedef void (^GHUICellSetBlock)(id cell, id object, NSIndexPath *indexPath, id containingView/*UITableView or UICollectionView*/, BOOL dequeued);
typedef CGSize (^GHUICellSizeBlock)(id cell, id object, NSIndexPath *indexPath, id containingView/*UITableView or UICollectionView*/);
typedef void (^GHUICellSelectBlock)(id sender, NSIndexPath *indexPath, id object);
typedef BOOL (^GHUICellShouldSelectBlock)(id sender, NSIndexPath *indexPath, id object);


@interface GHUIBaseCellDataSource : NSObject {
  NSMutableDictionary *_cellClasses;
  NSMutableDictionary *_cellsForSizing;
  NSMutableDictionary *_headerTexts;
  
  NSMutableDictionary *_sizeCache;
}

@property (copy) GHUICellClassBlock classBlock;
@property (copy) GHUICellSetBlock cellSetBlock;
@property (copy) GHUICellSizeBlock sizeBlock;
@property (copy) GHUICellShouldSelectBlock shouldSelectBlock;
@property (copy) GHUICellSelectBlock selectBlock;

@property BOOL cacheEnabled;

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForCellAtIndexPath:(NSIndexPath *)indexPath view:(UIView */*UITableView or UICollectionView*/)view;

- (NSString *)headerTextForSection:(NSInteger)section;

// Subclasses should override
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
