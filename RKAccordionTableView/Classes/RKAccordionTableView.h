//
//  RKAccordionTableView.h
//  Pods
//
//  Created by Pai on 6/26/17.
//
//

#import <UIKit/UIKit.h>
#import "RKAccordionCell.h"

@protocol RKAccordionTableViewDelegate;
@protocol RKAccordionTableViewDataSource;

@interface RKAccordionTableView : UITableView

@property (nonatomic, strong) id<RKAccordionTableViewDelegate> accordionDelegate;
@property (nonatomic, strong) id<RKAccordionTableViewDataSource> accordionDataSource;
@property (nonatomic, assign) BOOL allowMultipleSectionsOpen;

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

@protocol RKAccordionTableViewDelegate <NSObject>

@required
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForSection:(NSInteger)sectionNumber;
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;

@optional
- (BOOL)accordion:(RKAccordionTableView *)tableView isFooterRequiredInSection:(NSInteger)sectionNumber;
- (BOOL)accordion:(RKAccordionTableView *)tableView isHeaderRequiredInSection:(NSInteger)sectionNumber;
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForFooterInSection:(NSInteger)sectionNumber;
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForHeaderInSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForFooterInSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForHeaderInSection:(NSInteger)sectionNumber;
- (void)accordion:(UITableView *)tableView willBeginReorderingRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (void)accordion:(UITableView *)tableView willBeginReorderingSection:(NSInteger)sectionNumber;

@end

@protocol RKAccordionTableViewDataSource <NSObject>

@required
- (NSInteger)numberOfSectionsInAccordion:(RKAccordionTableView *)tableView;
- (NSInteger)numberOfRowsInSection:(NSInteger)section accordion:(RKAccordionTableView *)tableView;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForSection:(NSInteger)sectionNumber expanded:(BOOL)isExpanded;

@optional
- (void)accordion:(RKAccordionTableView *)tableView moveSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber;
- (void)accordion:(RKAccordionTableView *)tableView moveRow:(NSInteger)fromRowNumber inSection:(NSInteger)fromSectionNumber toRow:(NSInteger)toRowNumber inSection:(NSInteger)toSectionNumber;
- (BOOL)accordion:(RKAccordionTableView *)tableView canMoveRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (BOOL)accordion:(RKAccordionTableView *)tableView canMoveSection:(NSInteger)sectionNumber;

@end
