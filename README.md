GHUITable
=========

Making UITableView, UICollectionView, UITableViewCell easier to use.

Also includes a UITableView for use with [YapDatabase](https://github.com/yapstudios/YapDatabase).

# Podfile

```ruby
pod "GHUITable"

pod "GHUITable/Yap" # Optional, for YapDatabase support
```

# Example Project

The best way to follow and learn about `GHUITable` is by seeing it in action. Clone the repo and open the [Example](https://github.com/gabriel/GHUITable/tree/master/Example) project.

# Usage

## GHUITableView

```objc
GHUITableView *tableView = [[GHUITableView alloc] init];

// These are all the cells that will be used, usually it's just one.
[tableView registerClasses:@[GHUITextImageCell.class]];

// This block returns the cell class.
// It can be based on the data or section, or (in this case) can be constant.
tableView.dataSource.classBlock = ^Class(id object, NSIndexPath *indexPath) {
  return GHUITextImageCell.class;
};

// Set the data on the cell.
tableView.dataSource.cellSetBlock = ^(GHUITextImageCell *cell, GHData *data, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
  [cell.viewForContent setName:data.name description:data.description image:[UIImage imageNamed:data.imageName]];
};

// Set what happens when a user selects a cell.
tableView.dataSource.selectBlock = ^(UITableView *tableView, NSIndexPath *indexPath, GHData *data) {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSLog(@"Selected: %@", indexPath);
  // Do something
};

// Set section headers
[tableView.dataSource setHeaderText:@"Section 1" section:0];
[tableView.dataSource setHeaderText:@"Section 2" section:1];

```

## Adding data

There are many methods for adding, updating or removing data.

```objc
[tableView setObjects:@[...] animated:NO];
[tableView addObjects:@[...] animated:NO];
// And many more...
```

Or access methods on the datasource. (You can pass nil for indexPaths if you don't care what changed.)

```objc
[tableView.dataSource addObjects:@[..] section:0 indexPaths:nil];
[tableView.dataSource removeObjects:@[..] section:0 indexPaths:nil];
// And many more...

// If you edit the datasource directly be sure to call reloadData
[tableView reloadData];
```

## GUITableViewCell

This allows you to turn any view into a UITableViewCell in just a few lines of code.

For example, `GHUITextImageCell` is defined as:

```objc
@interface GHUITextImageCell : GHUITableViewCell
@end

@implementation GHUITextImageCell
+ (Class)contentViewClass { return GHUITextImageView.class; }
@end
```

[GHUITextImageView](https://github.com/gabriel/GHUITable/blob/master/Example/Example/GHUITextImageView.m) is also an example of a view using [YOLayout](https://github.com/YOLayout/YOLayout) which you should also check out!

## GHUITableView (More complex example)

He is an example with different cell classes for different sections.

```objc
GHUITableView *tableView = [[GHUITableView alloc] init];

// These are the cells that will be used.
[tableView registerClasses:@[GHUISwitchCell.class, GHUITextImageCell.class]];

// This block chooses the cell class based on the section, but you could also do it based on the data.
tableView.dataSource.classBlock = ^Class(NSDictionary *object, NSIndexPath *indexPath) {
  if (indexPath.section == 2) return GHUISwitchCell.class;
  return GHUITextImageCell.class;
};

// Set the data on the cell. (Cell depends on section.)
tableView.dataSource.cellSetBlock = ^(GHUITableViewCell *cell, NSDictionary *dict, NSIndexPath *indexPath, UITableView *tableView, BOOL dequeued) {
  if (indexPath.section == 0) {
    [cell.viewForContent setName:dict[@"name"] description:dict[@"description"] image:[UIImage imageNamed:dict[@"imageName"]]];
  } else if (indexPath.section == 1) {
    [cell.viewForContent setName:dict[@"name"] description:dict[@"description"] imageURLString:dict[@"imageURLString"]];
  } else if (indexPath.section == 2) { // or [cell isKindOfClass:GHUISwitchCell.class]
    [cell.viewForContent setTitle:dict[@"title"] description:dict[@"description"] on:[dict[@"on"] boolValue]];
  }
};
```

## GHUITableView (Static Content)

Sometimes it's useful to use table views even when you have static content. You can add a UIView to the data source instead of data. This bypasses the cell rendering pattern so it's not appropriate for when you have tons of content.

```objc
GHUITableView *tableView = [[GHUITableView alloc] init];

// You can add a view as a data object source.
// In this scenario you are not re-using views and is appropriate for when you have static content.
GHUITextImageView *view = [[GHUITextImageView alloc] init];
[view setName:@"Name2" description:@"This is a description #2" image:[UIImage imageNamed:@"Preview2-Filled"]];
[tableView addObjects:@[view] section:0 animated:NO];

// You can even add a cell as a data object source (although this is probably a little awkward, can be useful sometimes).
GHUITextImageCell *cell = [[GHUITextImageCell alloc] init];
[cell.viewForContent setName:@"Name1" description:@"This is a description #1" image:[UIImage imageNamed:@"Preview2"]];
[tableView addObjects:@[cell] section:1 animated:NO];
```

## GHUICollectionView

Example coming soon.

## GHUIYapTableView

Example comming soon.


