//
//  RKAccordionObject.m
//  Pods
//
//  Created by Pai on 6/28/17.
//
//

#import "RKAccordionObject.h"

@implementation RKAccordionObject

- (instancetype)init {
    self = [super init];
    self.isSection = YES;
    self.isExpanded = NO;
    self.rowNumber = 0;
    self.sectionNumber = 0;
    self.numberOfRows = 0;
    self.isDraggable = NO;
    self.isSwipingEnabled = NO;
    return self;
}

@end
