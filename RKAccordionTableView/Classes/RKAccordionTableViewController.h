//
//  RKAccordionTableViewController.h
//  Pods
//
//  Created by Pai on 6/26/17.
//
//

#import <UIKit/UIKit.h>
#import "RKAccordionTableView.h"

@protocol RKAccordionTableViewDelegate;
@protocol RKAccordionTableViewDataSource;

@interface RKAccordionTableViewController : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<RKAccordionTableViewDelegate> accordionDelegate;
@property (nonatomic, strong) id<RKAccordionTableViewDataSource> accordionDataSource;
@property (nonatomic, weak) RKAccordionTableView *accordionTableView;

- (void)reloadValues;
- (BOOL)tapActionForSection:(NSInteger)section;
- (void)scrollToRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (void)scrollToFooterInSection:(NSInteger)sectionNumber;
- (void)scrollToHeaderInSection:(NSInteger)sectionNumber;
- (void)reloadAndRestoreExpandedState;
- (void)cancelMoveSection;
- (void)moveAccordionSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber;
- (RKAccordionCell *)cellForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)cellForSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)cellForFooterInSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)cellForHeaderInSection:(NSInteger)sectionNumber;

@end
