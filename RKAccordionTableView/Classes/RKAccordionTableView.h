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
- (void)tapActionForSection:(NSInteger)section;
@end

@protocol RKAccordionTableViewDelegate <NSObject>
@required
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForSection:(NSInteger)sectionNumber;
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
@optional
- (BOOL)accordion:(RKAccordionTableView *)tableView isFooterRequiredInSection:(NSInteger)sectionNumber;
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForFooterInSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForFooterInSection:(NSInteger)sectionNumber;

@end

@protocol RKAccordionTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInAccordion:(RKAccordionTableView *)tableView;
- (NSInteger)numberOfRowsInSection:(NSInteger)section accordion:(RKAccordionTableView *)tableView;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (RKAccordionCell *)accordion:(RKAccordionTableView *)tableView cellForSection:(NSInteger)sectionNumber;
@optional
- (void)accordion:(RKAccordionTableView *)tableView moveSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber;
- (void)accordion:(RKAccordionTableView *)tableView moveRow:(NSInteger)fromRowNumber inSection:(NSInteger)fromSectionNumber toRow:(NSInteger)toRowNumber inSection:(NSInteger)toSectionNumber;
- (BOOL)accordion:(RKAccordionTableView *)tableView canMoveRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (BOOL)accordion:(RKAccordionTableView *)tableView canMoveSection:(NSInteger)sectionNumber;
@end
