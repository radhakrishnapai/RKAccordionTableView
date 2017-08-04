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

- (BOOL)tapActionForSection:(NSInteger)section {
    return [self.rkAccordionTableViewController tapActionForSection:section];
}

- (void)scrollToRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    [self.rkAccordionTableViewController scrollToRow:rowNumber inSection:sectionNumber];
}

- (void)scrollToFooterInSection:(NSInteger)sectionNumber {
    [self.rkAccordionTableViewController scrollToFooterInSection:sectionNumber];
}

- (void)scrollToHeaderInSection:(NSInteger)sectionNumber {
    [self.rkAccordionTableViewController scrollToHeaderInSection:sectionNumber];
}

- (void)reloadAndRestoreExpandedState {
    [self.rkAccordionTableViewController reloadAndRestoreExpandedState];
}

- (void)cancelMoveSection {
    [self.rkAccordionTableViewController cancelMoveSection];
}

- (void)moveAccordionSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber {
    [self.rkAccordionTableViewController moveAccordionSection:fromSectionNumber toSection:toSectionNumber];
}

- (RKAccordionCell *)cellForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    if (self.rkAccordionTableViewController.accordionDataSource) {
        RKAccordionCell *cell = [self.accordionDataSource accordion:self cellForRow:rowNumber inSection:sectionNumber];
        return cell;
    } else {
        return [[RKAccordionCell alloc] init];
    }
}

- (RKAccordionCell *)cellForSection:(NSInteger)sectionNumber {
    if (self.rkAccordionTableViewController.accordionDataSource) {
        RKAccordionCell *cell = [self.rkAccordionTableViewController.accordionDataSource accordion:self cellForSection:sectionNumber];
        return cell;
    } else {
        return [[RKAccordionCell alloc] init];
    }
}

- (RKAccordionCell *)cellForFooterInSection:(NSInteger)sectionNumber {
    if (self.accordionDelegate) {
        RKAccordionCell *cell = [self.rkAccordionTableViewController.accordionDelegate accordion:self cellForFooterInSection:sectionNumber];
        return cell;
    } else {
        return [[RKAccordionCell alloc] init];
    }

}

- (RKAccordionCell *)cellForHeaderInSection:(NSInteger)sectionNumber {
    if (self.accordionDelegate) {
        RKAccordionCell *cell = [self.rkAccordionTableViewController.accordionDelegate accordion:self cellForHeaderInSection:sectionNumber];
        return cell;
    } else {
        return [[RKAccordionCell alloc] init];
    }
}

@end
