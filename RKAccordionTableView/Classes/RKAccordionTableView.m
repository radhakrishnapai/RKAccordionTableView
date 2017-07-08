//
//  RKAccordionTableView.m
//  Pods
//
//  Created by Pai on 6/26/17.
//
//

#import "RKAccordionTableView.h"
#import "RKAccordionTableViewController.h"

@interface RKAccordionTableView ()

@property (nonatomic, strong) RKAccordionTableViewController *rkAccordionTableViewController;

@end

@implementation RKAccordionTableView

- (void)setAccordionDelegate:(id<RKAccordionTableViewDelegate>)accordionDelegate {
    if (self.rkAccordionTableViewController == nil) {
        self.rkAccordionTableViewController = [[RKAccordionTableViewController alloc] init];
    }
    [self setEditing:YES animated:NO];
    self.delegate = self.rkAccordionTableViewController;
    self.rkAccordionTableViewController.accordionDelegate = accordionDelegate;
    self.rkAccordionTableViewController.accordionTableView = self;
    _accordionDelegate = accordionDelegate;
}

- (void)setAccordionDataSource:(id<RKAccordionTableViewDataSource>)accordionDataSource {
    if (self.rkAccordionTableViewController == nil) {
        self.rkAccordionTableViewController = [[RKAccordionTableViewController alloc] init];
    }
    [self setEditing:YES animated:NO];
    self.dataSource = self.rkAccordionTableViewController;
    self.rkAccordionTableViewController.accordionDataSource = accordionDataSource;
    self.rkAccordionTableViewController.accordionTableView = self;
    _accordionDataSource = accordionDataSource;
}

- (void)reloadValues {
    if (self.rkAccordionTableViewController == nil) {
        self.rkAccordionTableViewController = [[RKAccordionTableViewController alloc] init];
    }
    [self.rkAccordionTableViewController reloadValues];
}

- (void)tapActionForSection:(NSInteger)section {
    [self.rkAccordionTableViewController tapActionForSection:section];
}

- (void)scrollToRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    [self.rkAccordionTableViewController scrollToRow:rowNumber inSection:sectionNumber];
}

- (void)scrollToFooterInSection:(NSInteger)sectionNumber {
    [self.rkAccordionTableViewController scrollToFooterInSection:sectionNumber];
}

@end
