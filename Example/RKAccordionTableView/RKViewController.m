//
//  RKViewController.m
//  RKAccordionTableView
//
//  Created by Radhakrishna Pai on 06/26/2017.
//  Copyright (c) 2017 Radhakrishna Pai. All rights reserved.
//

#import "RKViewController.h"
#import "RKAccordionTableView.h"
#import "CustomCell.h"
#import "CustomRowCell.h"

@interface RKViewController ()<RKAccordionTableViewDelegate, RKAccordionTableViewDataSource> {
    NSMutableArray *array;
}

@property (nonatomic, strong) IBOutlet RKAccordionTableView *tableView;

@end

@implementation RKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.accordionDelegate = self;
    self.tableView.accordionDataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomRowCell" bundle:nil] forCellReuseIdentifier:@"CustomRowCell"];
    [self.tableView setEditing:YES animated:NO];
    array = [NSMutableArray arrayWithArray:@[@3, @2, @1, @0]];
    [self.tableView reloadValues];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark RKAccordionTableViewDelegate

- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForSectionAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark RKAccordionTableViewDataSource

- (NSInteger)numberOfSectionsInAccordion:(RKAccordionTableView *)tableView {
    return array.count;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section accordion:(RKAccordionTableView *)tableView {
    switch (section) {
        case 0:
            return ((NSNumber *)array[0]).integerValue;
            break;
        case 1:
            return ((NSNumber *)array[1]).integerValue;
            break;
        case 2:
            return ((NSNumber *)array[2]).integerValue;
            break;
        case 3:
            return ((NSNumber *)array[3]).integerValue;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(RKAccordionTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath row:(NSInteger)row {
    CustomRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomRowCell"];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)row];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (UITableViewCell *)tableView:(RKAccordionTableView *)tableView cellForSectionAtIndexPath:(NSIndexPath *)indexPath section:(NSInteger)section {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)section];
    cell.actionBlock = ^() {
        [tableView tapActionForSection:section];
    };
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (BOOL)tableView:(RKAccordionTableView *)tableView canMoveRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    return YES;
}

- (BOOL)tableView:(RKAccordionTableView *)tableView canMoveSection:(NSInteger)sectionNumber {
    return YES;
}

- (void)tableView:(RKAccordionTableView *)tableView moveRow:(NSInteger)fromRowNumber inSection:(NSInteger)fromSectionNumber toRow:(NSInteger)toRowNumber inSection:(NSInteger)toSectionNumber {
    NSInteger numberOfRowsInfromSection = ((NSNumber *)array[fromSectionNumber]).integerValue;
    NSInteger numberOfRowsIntoSection = ((NSNumber *)array[toSectionNumber]).integerValue;
    if (fromSectionNumber == toSectionNumber) {
        
    } else {
    numberOfRowsInfromSection -= 1;
    numberOfRowsIntoSection += 1;
    array[fromSectionNumber] = @(numberOfRowsInfromSection);
    array[toSectionNumber] = @(numberOfRowsIntoSection);
    }
    
}

- (void)tableView:(RKAccordionTableView *)tableView moveSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber {
    NSInteger numberOfRowsInfromSection = ((NSNumber *)array[fromSectionNumber]).integerValue;
    NSInteger numberOfRowsIntoSection = ((NSNumber *)array[toSectionNumber]).integerValue;
    array[fromSectionNumber] = @(numberOfRowsIntoSection);
    array[toSectionNumber] = @(numberOfRowsInfromSection);
}

@end
