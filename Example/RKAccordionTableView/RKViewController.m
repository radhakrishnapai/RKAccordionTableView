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
#import "CustomFooterCell.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomFooterCell" bundle:nil] forCellReuseIdentifier:@"CustomFooterCell"];
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

- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForSection:(NSInteger)sectionNumber {
    return 88;
}

- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    return 44;
}

- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForFooterInSection:(NSInteger)sectionNumber {
    return 44;
}

- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForHeaderInSection:(NSInteger)sectionNumber {
    return 44;
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

- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {    CustomRowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomRowCell"];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)rowNumber];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForSection:(NSInteger)sectionNumber {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)sectionNumber];
    cell.actionBlock = ^() {
        [tableView tapActionForSection:sectionNumber];
    };
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForFooterInSection:(NSInteger)sectionNumber {
    CustomFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomFooterCell"];
    cell.label.text = [NSString stringWithFormat:@"Footer: %ld", (long)sectionNumber];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}

- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForHeaderInSection:(NSInteger)sectionNumber {
    CustomFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomFooterCell"];
    cell.label.text = [NSString stringWithFormat:@"Header: %ld", (long)sectionNumber];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

- (BOOL)accordion:(RKAccordionTableView *)tableView canMoveRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    return YES;
}

- (BOOL)accordion:(RKAccordionTableView *)tableView canMoveSection:(NSInteger)sectionNumber {
    return YES;
}

- (BOOL)accordion:(RKAccordionTableView *)tableView isFooterRequiredInSection:(NSInteger)sectionNumber {
    return NO;
}

- (BOOL)accordion:(RKAccordionTableView *)tableView isHeaderRequiredInSection:(NSInteger)sectionNumber {
    return NO;
}

- (void)accordion:(RKAccordionTableView *)tableView moveRow:(NSInteger)fromRowNumber inSection:(NSInteger)fromSectionNumber toRow:(NSInteger)toRowNumber inSection:(NSInteger)toSectionNumber {
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

- (void)accordion:(RKAccordionTableView *)tableView moveSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber {
//    NSInteger numberOfRowsInfromSection = ((NSNumber *)array[fromSectionNumber]).integerValue;
//    NSInteger numberOfRowsIntoSection = ((NSNumber *)array[toSectionNumber]).integerValue;
    NSNumber *numberOfRowsInSection = array[fromSectionNumber];
//    array[fromSectionNumber] = @(numberOfRowsIntoSection);
//    array[toSectionNumber] = @(numberOfRowsInfromSection);
    [array removeObjectAtIndex:fromSectionNumber];
    [array insertObject:numberOfRowsInSection atIndex:toSectionNumber];
}

@end
