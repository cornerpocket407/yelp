//
//  FilterViewController.m
//  Yelp
//
//  Created by Tony Dao on 3/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"
#import "SelectModel.h"
#import "Filter.h"
#import "YelpClient.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) Filter *distance;
@property (nonatomic, strong) Filter *sortBy;
@property(nonatomic, assign) BOOL deals;
@end

@implementation FilterViewController
- (IBAction)search:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filters = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 70;
    self.sections = [[NSMutableArray alloc] init];
    self.distance = [[Filter alloc] initWithObjects:[@[@{
                                                         @"name":@"Auto",
                                                         @"param":@"nil"
                                                         },
                                                     @{
                                                         @"name":@"2 blocks",
                                                         @"param":@"322"
                                                         },
                                                     @{
                                                         @"name":@"6 blocks",
                                                         @"param":@"965"
                                                         },
                                                       @{
                                                           @"name":@"1 mile",
                                                           @"param":@"1609"
                                                           }
                                                       ,
                                                       @{
                                                           @"name":@"5 miles",
                                                           @"param":@"8047"
                                                           }] mutableCopy]];
    self.sortBy = [[Filter alloc] initWithObjects:[@[@{
                                                           @"name":@"Best Match",
                                                           @"param":@"0"
                                                           },
                                                       @{
                                                           @"name":@"Distance",
                                                           @"param":@"1"
                                                           },
                                                       @{
                                                           @"name":@"Rating",
                                                           @"param":@"2"
                                                           }] mutableCopy]];
    UINib *switchNib = [UINib nibWithNibName:@"SwitchCell" bundle:nil];
    [self.tableView registerNib:switchNib forCellReuseIdentifier:@"SwitchCell"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBack)];
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(onSearch)];
    searchButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)onBack {
    [self.navigationController popViewControllerAnimated:YES];
    self.client.sort = self.sortBy.selectedParam;
    self.client.radius = self.distance.selectedParam;
    self.client.deals = self.deals;
}

- (void)onSearch {
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate doSearchOnController];
    self.client.sort = self.sortBy.selectedParam;
    self.client.radius = self.distance.selectedParam;
    self.client.deals = self.deals;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.distance.expanded ? self.distance.size : 1;
    } else if (section == 2) {
        return self.sortBy.expanded ? self.sortBy.size : 1;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Most Popular";
    if(section == 1)
        return @"Distance";
    else
        return @"Sort By";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    Filter *filter;
    if (section == 0) {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
        cell.theSwitch.on = self.deals;
        [cell.theSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        return cell;
    } else {
        filter = section == 1 ? self.distance : self.sortBy;
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        if (filter.expanded) {
            cell.textLabel.text = [filter getLabel:indexPath.row];
        } else {
            cell.textLabel.text = filter.selectedLabel;
        }
        return cell;
    }
}

-(void)changeSwitch:(UISwitch *)sender {
    self.deals = sender.on;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section != 0) {
        Filter *filter = section == 1 ? self.distance : self.sortBy;
        [filter select:row];
        filter.expanded = !filter.expanded;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
@end
