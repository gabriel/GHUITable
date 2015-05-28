//
//  GHUICellDataSource.h
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIBaseCellDataSource.h"

@interface GHUICellDataSource : GHUIBaseCellDataSource <UIScrollViewDelegate>

@property UIEdgeInsets sectionInset;
@property NSInteger minSectionCount;

@property (weak) id<UIScrollViewDelegate> scrollViewDelegate;


- (NSMutableArray *)objectsForSection:(NSInteger)section;
- (NSMutableArray *)objectsForSection:(NSInteger)section create:(BOOL)create;

- (NSInteger)countForSection:(NSInteger)section;

- (NSInteger)sectionCount;

// Invalidate cache
- (void)invalidateAll;

- (void)addObjects:(NSArray *)objects;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section;
- (void)addObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray *)indexPaths;

- (void)insertObjects:(NSArray *)objects section:(NSInteger)section position:(NSInteger)position indexPaths:(NSMutableArray *)indexPaths;

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;
- (NSIndexPath *)replaceObject:(id)object section:(NSInteger)section;

- (void)addOrUpdateObjects:(NSArray *)objects section:(NSInteger)section indexPathsToAdd:(NSMutableArray *)indexPathsToAdd indexPathsToUpdate:(NSMutableArray *)indexPathsToUpdate;

- (void)updateObjects:(NSArray *)objects section:(NSInteger)section indexPathsToAdd:(NSMutableArray *)indexPathsToAdd indexPathsToUpdate:(NSMutableArray *)indexPathsToUpdate indexPathsToRemove:(NSMutableArray *)indexPathsToRemove;

- (void)updateObjects:(NSArray *)objects section:(NSInteger)section position:(NSInteger)position indexPathsToAdd:(NSMutableArray *)indexPathsToAdd indexPathsToUpdate:(NSMutableArray *)indexPathsToUpdate indexPathsToRemove:(NSMutableArray *)indexPathsToRemove;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)lastObjectInSection:(NSInteger)section;

- (NSUInteger)indexOfObject:(id)object section:(NSInteger)section;
- (NSIndexPath *)indexPathOfObject:(id)object section:(NSInteger)section;
- (NSArray *)indexPathsOfObjects:(NSArray *)objects section:(NSInteger)section;

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeObjects:(NSArray *)objects;
- (void)removeObjects:(NSArray *)objects section:(NSInteger)section indexPaths:(NSMutableArray *)indexPaths;
- (void)removeAllObjects;
- (void)removeObjectsFromSection:(NSInteger)section indexPaths:(NSMutableArray *)indexPaths;

- (void)replaceObjects:(NSArray *)replaceObjects withObjects:(NSArray *)objects section:(NSInteger)section indexPathsToAdd:(NSMutableArray *)indexPathsToAdd indexPathsToUpdate:(NSMutableArray *)indexPathsToUpdate;
- (void)replaceObjects:(NSArray *)replaceObjects section:(NSInteger)section indexPaths:(NSMutableArray *)indexPaths;

- (void)setObjects:(NSArray *)objects;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section;
- (void)setObjects:(NSArray *)objects section:(NSInteger)section indexPathsToRemove:(NSMutableArray *)indexPathsToRemove indexPathsToAdd:(NSMutableArray *)indexPathsToAdd;

- (void)insertObject:(id)obj indexPath:(NSIndexPath *)indexPath;

- (id)findObject:(id)object section:(NSInteger)section;

@end
