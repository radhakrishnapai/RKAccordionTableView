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
@end
