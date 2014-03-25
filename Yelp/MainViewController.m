//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//
// TODO: Make Yelp Client singleton to avoid passing it around
#import "MainViewController.h"
#import "FilterViewController.h"
#import "YelpClient.h"
#import "ResultCell.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation MainViewController
static ResultCell *cellPrototype;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (IBAction)filterClick:(id)sender {
    FilterViewController *fc = [[FilterViewController alloc] init];
    fc.client = self.client;
    fc.delegate = self;
    [self.navigationController pushViewController:fc animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 150;
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];

    UINib *resultCellNib = [UINib nibWithNibName:@"ResultCell" bundle:nil];
    [self.tableView registerNib:resultCellNib forCellReuseIdentifier:@"ResultCell"];
    cellPrototype = [self.tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(onFilter)];
    filterButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = filterButton;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
}
- (void)onFilter {
    FilterViewController *fc = [[FilterViewController alloc] init];
    fc.client = self.client;
    fc.delegate = self;
    [self.navigationController pushViewController:fc animated:YES];
}
- (void)search:(NSString *)search {
      [self.client searchWithTerm:search success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.results = [[NSMutableArray alloc] init];
        int i = 0;
        for (NSDictionary *response in responseObject[@"businesses"]) {
            [self.results addObject: [[SearchResult alloc]initWithDictionary:response nth:i++]];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view methods
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    cell.result = self.results[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResult *result = self.results[indexPath.row];
    double cellHeight = 45.0;
    CGFloat nameLabelHeight = [self sizeOfLabel:cellPrototype.nameLabel font:[UIFont systemFontOfSize:15.0] withText:result.name].height;
    CGFloat reviewLabelHeight = cellPrototype.reviewCountLabel.frame.size.height;
    CGFloat addressLabelHeight = [self sizeOfLabel:cellPrototype.addressLabel font:[UIFont systemFontOfSize:13.0] withText:result.address].height;
    CGFloat categoriesLabelHeight = [self sizeOfLabel:cellPrototype.categoriesLabel font:[UIFont systemFontOfSize:13.0] withText:[result.categories[0] componentsJoinedByString:@", "]].height;
    cellHeight += nameLabelHeight + reviewLabelHeight + addressLabelHeight + categoriesLabelHeight;
    return MAX(122, cellHeight);;
}
- (CGSize)sizeOfLabel:(UILabel *)label font:(UIFont *)font withText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context: nil].size;
}

#pragma mark - Search bar methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self search:searchBar.text];
}

#pragma mark - Delegate
-(void)doSearchOnController {
    [self search:self.searchBar.text];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
