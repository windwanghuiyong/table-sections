//
//  SearchResultsController.h
//  TableSections
//
//  Created by wanghuiyong on 24/01/2017.
//  Copyright © 2017 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

// 结果视图控制器, 搜索结果更新器, UITableViewController 是嵌入了 UITableView 的控制器, 并预先设置为其表视图的数据源和委托
@interface SearchResultsController : UITableViewController <UISearchResultsUpdating>

- (instancetype)initWithNames:(NSDictionary *)names keys:(NSArray *)keys;

@end
