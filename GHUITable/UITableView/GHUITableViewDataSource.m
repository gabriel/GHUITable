//
//  GHUITableViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel Handford on 1/22/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUITableViewDataSource.h"
#import "GHUITableViewCell.h"

@implementation GHUITableViewDataSource

- (void)setCellClass:(Class)cellClass tableView:(UITableView *)tableView section:(NSInteger)section {
  //NSAssert(section > 0, @"Section must be > 0");
  if (!_cellClasses) _cellClasses = [[NSMutableDictionary alloc] init];
  [_cellClasses setObject:cellClass forKey:@(section)];
  [tableView registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)setHeaderText:(NSString *)headerText section:(NSInteger)section {
  if (!_headerTexts) {
    _headerTexts = [NSMutableDictionary dictionary];
  }
  [_headerTexts setObject:headerText forKey:@(section)];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self countForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  id object = [self objectAtIndexPath:indexPath];
  if ([object isKindOfClass:[UITableViewCell class]]) {
    return object;
  }
  
  if ([object isKindOfClass:[UIView class]]) {
    return [GHUITableViewCell tableViewCellForContentView:object];
  }
  
  Class cellClass = [self cellClassForIndexPath:indexPath];
  id cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
  BOOL dequeued = YES;
  if (!cell) {
    dequeued = NO;
    cell = [[cellClass alloc] init];
  }
  self.cellSetBlock(cell, [self objectAtIndexPath:indexPath], indexPath, tableView, dequeued);
  return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self sectionCount];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return (!!self.deleteBlock);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath && editingStyle == UITableViewCellEditingStyleDelete) {
    id object = [self objectAtIndexPath:indexPath];
    if (self.deleteBlock) self.deleteBlock(tableView, indexPath, object, ^(BOOL shouldDelete) {
      [self removeObjectAtIndexPath:indexPath];
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    });
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if ([self headerTextForSection:section] && [self tableView:tableView numberOfRowsInSection:section] > 0) {
    return [[self tableView:tableView viewForHeaderInSection:section] sizeThatFits:tableView.frame.size].height;
  } else if (tableView.style == UITableViewStyleGrouped) {
    return 21;
  }
  
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  // Default for grouped section headers
  if (tableView.style == UITableViewStyleGrouped) return 1;
  
  return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.headerViewBlock) {
    return self.headerViewBlock(tableView, section, [self headerTextForSection:section]);
  } else {
    NSString *text = [self headerTextForSection:section];
    //if (!text) return nil;
    
    UILabel *label = [[UILabel alloc] init];
    // TODO: Fix insets
    //label.insets = UIEdgeInsetsMake(21, 15, 4, 0);
    label.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    label.text = [self headerTextForSection:section];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    label.text = [text uppercaseString];
    return label;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  return nil;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
  id obj = [self objectAtIndexPath:sourceIndexPath];
  [self removeObjectAtIndexPath:sourceIndexPath];
  [self insertObject:obj indexPath:destinationIndexPath];
}

#pragma mark UICollectionViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self sizeForCellAtIndexPath:indexPath view:tableView].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.selectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    self.selectBlock(tableView, indexPath, object);
  }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.shouldSelectBlock) {
    id object = [self objectAtIndexPath:indexPath];
    return self.shouldSelectBlock(tableView, indexPath, object);
  }
  return (self.selectBlock != NULL);
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (!self.canMoveBlock) return NO;
//  return self.canMoveBlock(tableView, indexPath);
//}

@end
