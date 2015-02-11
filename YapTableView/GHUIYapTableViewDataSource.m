//
//  GHUIYapTableViewDataSource.m
//  GHUIKit
//
//  Created by Gabriel on 8/18/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import "GHUIYapTableViewDataSource.h"
#import "GHUITableViewCell.h"

@implementation GHUIYapTableViewDataSource

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  __weak GHUIYapTableViewDataSource *blockSelf = self;
  __block id obj = nil;
  [_connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {    
    obj = [[transaction ext:blockSelf.mappings.view] objectAtIndexPath:indexPath withMappings:blockSelf.mappings];
  }];
  return obj;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
  return [_mappings numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_mappings numberOfItemsInSection:section];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath && editingStyle == UITableViewCellEditingStyleDelete) {
    id object = [self objectAtIndexPath:indexPath];
    if (self.deleteBlock) self.deleteBlock(tableView, indexPath, object, ^(BOOL shouldDelete) {
      
    });
    // YapDatabaseModified listener handles the removal from the table view
  }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (_indexTitlesEnabled && [[_mappings allGroups] count] > 6 && [_mappings numberOfItemsInAllGroups] > 20) return [_mappings allGroups];
  return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  return [[_mappings allGroups] indexOfObjectIdenticalTo:title];
}

@end
