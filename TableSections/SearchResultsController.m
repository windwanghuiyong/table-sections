//
//  SearchResultsController.m
//  TableSections
//
//  Created by wanghuiyong on 24/01/2017.
//  Copyright © 2017 My Organization. All rights reserved.
//

#import "SearchResultsController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface SearchResultsController ()

@property (strong, nonatomic) NSDictionary *names;				// 搜索时会用到的名字字典, 对数据源的引用, 而不是副本
@property (strong, nonatomic) NSArray *keys;						// 搜索时会用到的关键字列表
@property (strong, nonatomic) NSMutableArray *filteredNames;		// 对搜索结果数组的引用

@end

@implementation SearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 为 结果控制器嵌入的表视图 注册表单元的标识符
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithNames:(NSDictionary *)names keys:(NSArray *)keys {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        // 初始化属性
        self.names = names;
        self.keys = keys;
        self.filteredNames = [[NSMutableArray alloc] init];	// 为搜索结果分配内存空间
    }
    return self;
}

#pragma mark - UISearchResultsUpdating Conformance

static const NSUInteger	longNameSize = 6;
static const NSInteger	shortNamesButtonIndex = 1;
static const NSInteger	longNamesButtonIndex = 2;

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;						// 从搜索栏中获取搜索字符串
    NSInteger buttonIndex = searchController.searchBar.selectedScopeButtonIndex;		// 获取所选的范围按钮的索引值
    [self.filteredNames removeAllObjects];								// 清除过滤后的名字列表
    if (searchString.length > 0) {				// 搜索条件不为空
        // 定义谓词对象, 用于判断名字与输入的值, 即搜索字符串是否匹配, 对子字典中的每个名字进行调用
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *name, NSDictionary *b){
            NSUInteger nameLength = name.length;
            if (   (buttonIndex == shortNamesButtonIndex && nameLength >= longNameSize)
                || (buttonIndex == longNamesButtonIndex && nameLength < longNameSize)) {
                return NO;
            }
            // 名字匹配成功
            NSRange range = [name rangeOfString:searchString options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }];
        // 获取匹配的筛选列表
        for (NSString *key in self.keys) {
            NSArray *matches = [self.names[key] filteredArrayUsingPredicate:predicate];
            [self.filteredNames addObjectsFromArray:matches];	// 将筛选列表添加到数组中
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.filteredNames[indexPath.row];    
    return cell;
}

@end
