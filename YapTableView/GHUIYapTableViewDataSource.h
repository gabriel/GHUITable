//
//  GHUIYapTableViewDataSource.h
//  GHUIKit
//
//  Created by Gabriel on 8/18/14.
//  Copyright (c) 2014 Gabriel Handford. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GHUITableViewDataSource.h"

#import <YapDatabase/YapDatabase.h>
#import <YapDatabase/YapDatabaseView.h>

@interface GHUIYapTableViewDataSource : GHUITableViewDataSource

@property YapDatabaseConnection *connection;
@property YapDatabaseViewMappings *mappings;
@property BOOL indexTitlesEnabled;

@end
