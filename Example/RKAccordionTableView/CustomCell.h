//
//  CustomCell.h
//  RKAccordionTableView
//
//  Created by Pai on 7/4/17.
//  Copyright © 2017 Radhakrishna Pai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKAccordionCell.h"

typedef void (^ActionBlock)();

@interface CustomCell : RKAccordionCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (strong, nonatomic) ActionBlock actionBlock;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end
