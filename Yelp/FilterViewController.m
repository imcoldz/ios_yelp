//
//  FilterViewController.m
//  Yelp
//
//  Created by Xiangyu Zhang on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"
#import "SelectionCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *popularFeatureTableView;
@property (nonatomic, readonly) NSDictionary * filters;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property (nonatomic, strong) NSArray *features;
@property (nonatomic, strong) NSMutableSet *selectedFeatures;
@property (nonatomic, strong) NSArray *sortConditions;
@property (nonatomic, strong) NSMutableSet *selectedSortCondition;
@property (nonatomic, assign) BOOL showSortConditions;
@property (nonatomic, assign) NSInteger selectedSortIndex;
- (void)initCategories;
@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.selectedCategories = [NSMutableSet set];
        self.selectedSortCondition = [NSMutableSet set];
        [self initCategories];
        self.showSortConditions = false;
        [self initSortConditions];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target: self action:@selector(onCancelButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target: self action:@selector(onApplyButton)];
    
    self.popularFeatureTableView.dataSource = self;
    self.popularFeatureTableView.delegate = self;
    
    [self.popularFeatureTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    
    [self.popularFeatureTableView registerNib:[UINib nibWithNibName:@"SelectionCell" bundle:nil] forCellReuseIdentifier:@"SelectionCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath *indexPath = [self.popularFeatureTableView indexPathForCell:cell];
    if(value) {
        if([indexPath section]==0){
            [self.selectedCategories addObject:self.categories[indexPath.row]];
        }
        //move this part of logic to didSelectRowAtIndexPath:
        //if([indexPath section]==1){
          //  [self.selectedSortCondition addObject:self.sortConditions[indexPath.row]];
        //}
    }else{
        if([indexPath section]==0){
            [self.selectedCategories removeObject:self.categories[indexPath.row]];
        }
        //move this part of logic to didSelectRowAtIndexPath:
        //if([indexPath section]==1){
          //  [self.selectedSortCondition removeObject:self.sortConditions[indexPath.row]];
        //}
    }
}

#pragma mark - popularFeatureTableView methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // We are going to have only three sections in this example.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 4;
    if(section == 1) {
        if (self.showSortConditions == false) return 1;
        else return self.sortConditions.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath section] == 0){
        SwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        cell.on = NO;
        cell.delegate = self;
        CGRect cellRect = CGRectMake(0, 0, self.popularFeatureTableView.frame.size.width ,35);
        cell.frame = cellRect;
        cell.titleLabel.text = self.categories[indexPath.row][@"name"];
        return cell;
    }
    if([indexPath section]== 1){
        SelectionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        //adding dropdown feature of it
        if(self.showSortConditions == false){
            //NSLog(@"current row is %ld", [indexPath row]);
            //NSLog(@"now selectedSortIndex is %ld", self.selectedSortIndex);
            //NSLog(@"now titleLabel text should be %@", self.sortConditions[self.selectedSortIndex][@"name"]);
            cell.titleLabel.text = self.sortConditions[self.selectedSortIndex][@"name"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            //NSLog(@"expending all sort cells");
            cell.titleLabel.text = self.sortConditions[indexPath.row][@"name"];
            if ([indexPath row] == self.selectedSortIndex) cell.accessoryType = UITableViewCellAccessoryCheckmark;
            else cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // We don't care about taps on the cells of the section 0 or section 2.
    // We want to handle only the taps on our demo section.
    if ([indexPath section] == 1) {
        // The job we have to do here is pretty easy.
        // 1. If the isShowingList variable is set to YES, then we save the
        //     index of the row that the user tapped on (save it to the selectedValueIndex variable),
        // 2. Change the value of the isShowingList variable.
        // 3. Reload not the whole table but only the section we're working on.
        //
        // Note that only that last two steps are necessary when the isShowingList
        // variable is set to NO.
        
        // Step 1.
        if (self.showSortConditions !=false) {
            self.selectedSortIndex = [indexPath row];
            //NSLog(@"now selectedSortIndex should be %ld", self.selectedSortIndex);
        }
        // Step 2.
        self.showSortConditions = !self.showSortConditions;
        // Step 3. Here I chose to use the fade animation, but you can freely
        // try all of the provided animation styles and select the one it suits
        // you the best.
        [self.popularFeatureTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
        // Step 4.
        // update sort filter
        [self.selectedSortCondition removeAllObjects];
        [self.selectedSortCondition addObject:self.sortConditions[indexPath.row]];
    }
    else{
        return;
    }
    
}


// Add header titles in sections.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Food category";
    }
    else if (section == 1){
        return @"Sort by";
    }
    else{
        return @"Distance";
    }
}

// Set the row height.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Private methods

- (NSDictionary *)filters{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    if (self.selectedCategories.count>0){
        NSMutableArray *codes = [NSMutableArray array];
        for (NSDictionary *category in self.selectedCategories){
            [codes addObject:category[@"code"]];
        }
        NSString *categoryFilter = [codes componentsJoinedByString:@","];
        [filters setObject:categoryFilter forKey:@"category_filter"];
    }
    if (self.selectedSortCondition.count>0){
        NSMutableArray *codes = [NSMutableArray array];
        for (NSDictionary *condition in self.selectedSortCondition){
            [codes addObject:condition[@"code"]];
        }
        NSString *conditionFilter = codes[0];
        [filters setObject:conditionFilter forKey:@"sort"];
    }
    return filters;
}


- (void)onCancelButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onApplyButton{
    [self.delegate filterViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCategories{
    self.categories =  @[@{@"name" : @"Chinese", @"code": @"chinese" },
                         @{@"name" : @"Steakhouses", @"code": @"steak" },
                         @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                         @{@"name" : @"Korean", @"code": @"korean" }
                        ];
}

- (void)initSortConditions{
        self.sortConditions = @[@{@"name" : @"Best Match", @"code": @"0"},
                                @{@"name" : @"Distance", @"code": @"1"},
                                @{@"name" : @"Highest Rated", @"code": @"2"}
                                ];
    }
@end
