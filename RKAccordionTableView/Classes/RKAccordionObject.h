//
//  RKAccordionObject.h
//  Pods
//
//  Created by Pai on 6/28/17.
//
//

#import <Foundation/Foundation.h>

@interface RKAccordionObject : NSObject

@property (nonatomic, assign) BOOL isSection;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign) NSInteger rowNumber;
@property (nonatomic, assign) NSInteger sectionNumber;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, assign) BOOL isDraggable;
@property (nonatomic, assign) BOOL isSwipingEnabled;

@end
