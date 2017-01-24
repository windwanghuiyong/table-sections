//
//  ViewController.m
//  TableSections
//
//  Created by wanghuiyong on 24/01/2017.
//  Copyright © 2017 My Organization. All rights reserved.
//

#import "ViewController.h"
#import "SearchResultsController.h"

static NSString *SectionsTableIdentifier = @"SectionsTableIdentifier";

@interface ViewController ()

@property (copy, nonatomic) NSDictionary *names;
@property (copy, nonatomic) NSArray *keys;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册默认表视图单元类
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SectionsTableIdentifier];
    // 读取字典到属性
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sortednames" ofType:@"plist"];
    self.names = [NSDictionary dictionaryWithContentsOfFile:path];
    self.keys = [[self.names allKeys] sortedArrayUsingSelector:@selector((compare:))];
    
    // 创建搜索控制器
    SearchResultsController *resultsController = [[SearchResultsController alloc] initWithNames:self.names keys:self.keys];	// 结果控制器的方法
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];	// 搜索控制器的引用传给结果控制器
    
    UISearchBar *searchBar = self.searchController.searchBar;	// 从控制器创建搜索栏
    searchBar.scopeButtonTitles = @[@"All", @"Short", @"Long"];	// 范围按钮
    searchBar.placeholder = @"Enter a search term";
    [searchBar sizeToFit];						// 搜索栏的尺寸适合内容, 旋转时可确保扩展到整个表的宽度
    self.tableView.tableHeaderView = searchBar;		// 表的顶部视图有表视图自动管理, 这里设置为搜索栏
    self.searchController.searchResultsUpdater = resultsController;	// 结果控制器处理更新搜索结果
    
    // 索引颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor blueColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.keys count];	// 分区的数量, 默认为1, 此处每个键即每个字母都作为一个分区
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.keys[section];
    NSArray *nameSection = self.names[key];
    return [nameSection count];	// 每个分区的行数
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.keys[section];	// 为每个分区指定一个可选的标题
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionsTableIdentifier forIndexPath:indexPath];
    NSString *key = self.keys[indexPath.section];
    NSArray *nameSection = self.names[key];				// 分区属性
    cell.textLabel.text = nameSection[indexPath.row];
    return  cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.keys;	//添加索引
}

@end
