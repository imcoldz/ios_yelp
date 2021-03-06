//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterViewController.h"


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *businessTableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString * searchTerm;

- (IBAction)tabOnScreen:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void) sendQueryToYelp:(NSString *)searchterm params:(NSDictionary *)params{
    [self.client searchWithTerm:searchterm params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray *businessesDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictionaries: businessesDictionaries];
        
        [self.businessTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.businessTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.businessTableView.dataSource = self;
    self.businessTableView.delegate = self;
    
    [self.businessTableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    self.businessTableView.rowHeight = UITableViewAutomaticDimension;
    
    NSInteger quaterLength = (NSInteger) self.navigationController.navigationBar.frame.size.width/4;
    self.searchBar =  [[UISearchBar alloc] initWithFrame:CGRectMake(quaterLength, 0, quaterLength*2.2, 50)];
    self.searchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:self.searchBar];
    //self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target: self action:@selector(onFilterButton)];
    
    self.searchTerm = @"Restaurants";
    [self  sendQueryToYelp:self.searchTerm params:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (IBAction)tabOnScreen:(id)sender {
    [self.searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    // Do the search...
    self.searchTerm = self.searchBar.text;
    [self  sendQueryToYelp:self.searchTerm params:nil];
}

#pragma mark - Filter delegate methods
- (void)filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters{
    NSLog(@"fire new network event: %@", filters);
    [self sendQueryToYelp:self.searchTerm params:filters];
}

#pragma mark - Private methods

- (void)onFilterButton {
    FilterViewController * fvc = [[FilterViewController alloc] init];
    fvc.delegate = self;
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
