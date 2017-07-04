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
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForSectionAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)accordion:(RKAccordionTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol RKAccordionTableViewDataSource <NSObject>
@required
- (NSInteger)numberOfSectionsInAccordion:(RKAccordionTableView *)tableView;
- (NSInteger)numberOfRowsInSection:(NSInteger)section accordion:(RKAccordionTableView *)tableView;
- (RKAccordionCell *)tableView:(RKAccordionTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath row:(NSInteger)row;
- (RKAccordionCell *)tableView:(RKAccordionTableView *)tableView cellForSectionAtIndexPath:(NSIndexPath *)indexPath section:(NSInteger)section;
@optional
- (void)tableView:(RKAccordionTableView *)tableView moveSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber;
- (void)tableView:(RKAccordionTableView *)tableView moveRow:(NSInteger)fromRowNumber inSection:(NSInteger)fromSectionNumber toRow:(NSInteger)toRowNumber inSection:(NSInteger)toSectionNumber;
- (BOOL)tableView:(RKAccordionTableView *)tableView canMoveRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber;
- (BOOL)tableView:(RKAccordionTableView *)tableView canMoveSection:(NSInteger)sectionNumber;
@end
