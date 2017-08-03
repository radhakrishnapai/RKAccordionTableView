//
//  RKAccordionTableViewController.m
//  Pods
//
//  Created by Pai on 6/26/17.
//
//

#import "RKAccordionTableViewController.h"
#import "RKAccordionObject.h"

@interface RKAccordionTableViewController () {
    NSMutableArray *_isExpandedArray;
    NSMutableArray *_previousExpandedArray;
}

@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, assign) NSInteger numberOfRowsinPreviousSection;
@property (nonatomic, strong) NSMutableArray *sectionCountArray;
@property (nonatomic, strong) NSMutableArray *rkAccordionObjectArray;

@end

@implementation RKAccordionTableViewController

- (instancetype)init {
    self = [super init];
    _numberOfRowsinPreviousSection = 0;
    return self;
}

#pragma mark Public Instance Methods


// Method to reload and recreate the accordion objects model array and their expanded state
- (void)reloadValues {
    _numberOfSections = 0;
    self.sectionCountArray = [[NSMutableArray alloc] init];
    // Save the previous expanded array
    _previousExpandedArray = [_isExpandedArray mutableCopy];
    
    if (self.accordionDataSource) {
        // Capture the number of sections from the data source
        _numberOfSections = [self.accordionDataSource numberOfSectionsInAccordion:self.accordionTableView];
        _rkAccordionObjectArray = [NSMutableArray new];
        
        if (_numberOfSections != 0) {
            _isExpandedArray = [NSMutableArray new];
            for (NSInteger i = 0 ; i < _numberOfSections ; i++) {
                // Create and initialise the accordion object with the values received from the data source
                
                NSInteger numberOfRowsInCurrentSection = [self.accordionDataSource numberOfRowsInSection:i accordion:self.accordionTableView];
                RKAccordionObject *object = [[RKAccordionObject alloc] init];
                object.sectionNumber = i;
                object.objectType = AccordionSection;
                object.numberOfRows = numberOfRowsInCurrentSection;
                
                if ([self.accordionDelegate respondsToSelector:@selector(accordion:isFooterRequiredInSection:)]) {
                    object.isFooterRequired = [self.accordionDelegate accordion:self.accordionTableView isFooterRequiredInSection:i];
                }
                
                if ([self.accordionDelegate respondsToSelector:@selector(accordion:isHeaderRequiredInSection:)]) {
                    object.isHeaderRequired = [self.accordionDelegate accordion:self.accordionTableView isHeaderRequiredInSection:i];
                }
                
                // Update expanded state array and accordion objects array
                [_isExpandedArray addObject:@0];
                [_rkAccordionObjectArray addObject:object];
                NSInteger sectionNumber = 0;
                
                if (i != 0) {
                    sectionNumber = [((NSNumber *)self.sectionCountArray[i-1]) integerValue];
                    sectionNumber += _numberOfRowsinPreviousSection + 1;
                }
                
                [self.sectionCountArray insertObject:@(sectionNumber) atIndex:i];
                _numberOfRowsinPreviousSection = numberOfRowsInCurrentSection;
            }
        }
    }
    [self.accordionTableView reloadData];
}

// Method to toggle expanded state of accordion section
- (BOOL)tapActionForSection:(NSInteger)section {
    
    RKAccordionObject *accordionSectionObject = [self objectForSection:section];
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSInteger numberOfRows = accordionSectionObject.numberOfRows;
    
    if (accordionSectionObject.isHeaderRequired) {
        numberOfRows += 1;
    }
    
    if (accordionSectionObject.isFooterRequired) {
        numberOfRows += 1;
    }
    
    if (accordionSectionObject.isExpanded == YES) {
        //logic to collapse the accordion section
        
        accordionSectionObject.isExpanded = NO;
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:[_rkAccordionObjectArray indexOfObject:accordionSectionObject] inSection:0];
        [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@0];
        
        if (numberOfRows != 0) {
            for (NSInteger i = sectionIndexPath.row + 1 ; i <= sectionIndexPath.row+numberOfRows ; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndexPath.row+1, numberOfRows)]];
            [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } else {
        //logic to expand the accordion section
        
        if (self.accordionTableView.allowMultipleSectionsOpen == NO) {
            [self removePreviousSections];
        }
        
        accordionSectionObject.isExpanded = YES;
        NSInteger sectionIndex = [_rkAccordionObjectArray indexOfObject:accordionSectionObject];
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:sectionIndex inSection:0];
        [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@1];
        
        if (numberOfRows != 0) {
            for (NSInteger i = sectionIndexPath.row + 1 ; i <= sectionIndexPath.row + numberOfRows ; i++) {
                RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                accordionObject.rowNumber = i - sectionIndexPath.row - 1;
                accordionObject.objectType = AccordionRow;
                
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                
                if (accordionSectionObject.isHeaderRequired && i == sectionIndexPath.row + 1) {
                    accordionObject.objectType = AccordionHeader;
                }
                
                if (accordionSectionObject.isFooterRequired && i == sectionIndexPath.row + numberOfRows) {
                    accordionObject.objectType = AccordionFooter;
                }
                
                [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
            }
            [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    return accordionSectionObject.isExpanded;
}

- (void)scrollToRow:(NSInteger)rowNumber inSection:(NSInteger)sectionNumber {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionNumber+rowNumber+1 inSection:0];
    [self.accordionTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollToFooterInSection:(NSInteger)sectionNumber {
    RKAccordionObject *object = [_rkAccordionObjectArray objectAtIndex:sectionNumber];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionNumber+object.numberOfRows+1 inSection:0];
    [self.accordionTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollToHeaderInSection:(NSInteger)sectionNumber {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionNumber+1 inSection:0];
    [self.accordionTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)reloadAndRestoreExpandedState {
    [self reloadValues];
    [self restoreExpandedState];
}

- (void)cancelMoveSection {
    _isExpandedArray = _previousExpandedArray;
}

- (void)moveAccordionSection:(NSInteger)fromSectionNumber toSection:(NSInteger)toSectionNumber {
    if([self.accordionDataSource respondsToSelector:@selector(accordion:moveSection:toSection:)]) {
        _previousExpandedArray = [_isExpandedArray mutableCopy];
        NSNumber *fromSectionExpandedState = _isExpandedArray[fromSectionNumber];
        [_isExpandedArray removeObjectAtIndex:fromSectionNumber];
        [_isExpandedArray insertObject:fromSectionExpandedState atIndex:toSectionNumber];
        
        [self.accordionDataSource accordion:self.accordionTableView moveSection:fromSectionNumber toSection:toSectionNumber];
    }
}

#pragma mark Private Instance Methods

- (void)reorderControlCustomisationForCell:(UITableViewCell *)cell {
    UIView* reorderControl = [self huntedSubviewWithClassName:@"UITableViewCellReorderControl" forView:cell];
    
    UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(reorderControl.frame), CGRectGetMaxY(reorderControl.frame))];
    [resizedGripView addSubview:reorderControl];
    [cell.contentView addSubview:resizedGripView];
    [cell.contentView sendSubviewToBack:resizedGripView];
    
    CGSize sizeDifference = CGSizeMake(resizedGripView.frame.size.width - reorderControl.frame.size.width, resizedGripView.frame.size.height - reorderControl.frame.size.height);
    CGSize transformRatio = CGSizeMake(resizedGripView.frame.size.width / reorderControl.frame.size.width, resizedGripView.frame.size.height / reorderControl.frame.size.height);
    
    //	Original transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    //	Scale custom view so grip will fill entire cell
    transform = CGAffineTransformScale(transform, transformRatio.width, transformRatio.height);
    
    //	Move custom view so the grip's top left aligns with the cell's top left
    transform = CGAffineTransformTranslate(transform, -sizeDifference.width / 2.0, -sizeDifference.height / 2.0);
    
    [resizedGripView setTransform:transform];
    
    for(UIImageView* cellGrip in reorderControl.subviews)
    {
        if([cellGrip isKindOfClass:[UIImageView class]])
            [cellGrip setImage:nil];
    }
}

- (UIView*)huntedSubviewWithClassName:(NSString*)className forView:(UIView *)view {
    if([[[view class] description] isEqualToString:className])
        return view;
    
    for(UIView* subView in view.subviews) {
        UIView* huntedSubview = [self huntedSubviewWithClassName:className forView:subView];
        
        if(huntedSubview != nil)
            return huntedSubview;
    }
    
    return nil;
}

- (RKAccordionObject *)objectForSection:(NSInteger)section {
    for (RKAccordionObject *accordionObject in _rkAccordionObjectArray) {
        if (accordionObject.objectType == AccordionSection) {
            if (accordionObject.sectionNumber == section) {
                return accordionObject;
            }
        }
    }
    return nil;
}

- (void)restoreExpandedState {
    // Capture previous state of expanded array and update the new state
    if (_previousExpandedArray.count == _isExpandedArray.count) {
        _isExpandedArray = _previousExpandedArray;
    } else if (_previousExpandedArray.count < _isExpandedArray.count) {
        [_isExpandedArray replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_isExpandedArray.count - _previousExpandedArray.count, _previousExpandedArray.count)] withObjects:_previousExpandedArray];
    }
    
    // Iterate among all accordion sections
    for (int i=0; i<_numberOfSections; i++) {
        RKAccordionObject *accordionSectionObject = [self objectForSection:i];
        // Check is section is expanded
        if ([_isExpandedArray[accordionSectionObject.sectionNumber] isEqual:@1]) {
            accordionSectionObject.isExpanded = YES;
            NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:[_rkAccordionObjectArray indexOfObject:accordionSectionObject] inSection:0];
            NSMutableArray *indexPaths = [NSMutableArray new];
            NSInteger numberOfRows = accordionSectionObject.numberOfRows;
            
            if (accordionSectionObject.isHeaderRequired) {
                numberOfRows += 1;
            }
            
            if (accordionSectionObject.isFooterRequired) {
                numberOfRows += 1;
            }
            if (numberOfRows != 0) {
                // Create and insert accordion rows, footer and header for the accordion section
                for (NSInteger i = sectionIndexPath.row + 1 ; i <= sectionIndexPath.row + numberOfRows ; i++) {
                    RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                    accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                    accordionObject.rowNumber = i - sectionIndexPath.row - 1;
                    accordionObject.objectType = AccordionRow;
                    
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                    if (accordionSectionObject.isHeaderRequired && i == sectionIndexPath.row + 1) {
                        accordionObject.objectType = AccordionHeader;
                    }
                    
                    if (accordionSectionObject.isFooterRequired && i == sectionIndexPath.row + numberOfRows) {
                        accordionObject.objectType = AccordionFooter;
                    }
                    
                    [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
                }
                [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            if (self.accordionTableView.allowMultipleSectionsOpen == NO) {
                break;
            }
        }
    }
    [self.accordionTableView reloadData];
}

- (void)moveToAccordionObject:(RKAccordionObject *)accordionObjectTo fromRow:(NSInteger)fromRowNumber inSection:(NSInteger)fromSectionNumber toRow:(NSInteger)toRowNumber inSection:(NSInteger)toSectionNumber {
    if (accordionObjectTo.objectType == AccordionFooter) {
        // Don't allow rows to be dropped beneath Footer
        [self.accordionTableView reloadData];
    } else if (accordionObjectTo.objectType == AccordionHeader) {
        // Don't allow rows to be dropped above Header
        [self.accordionTableView reloadData];
    } else {
        if([self.accordionDataSource respondsToSelector:@selector(accordion:moveRow:inSection:toRow:inSection:)]) {
            [self.accordionDataSource accordion:self.accordionTableView moveRow:fromRowNumber inSection:fromSectionNumber toRow:toRowNumber inSection:toSectionNumber];
        }
        [self reloadAndRestoreExpandedState];
    }
}

- (void)removePreviousSections {
    
    // Logic to find the previous expanded accordion section
    RKAccordionObject *accordionSectionObject = nil;
    for (RKAccordionObject *accordionObject in _rkAccordionObjectArray) {
        if (accordionObject.objectType == AccordionSection) {
            if (accordionObject.isExpanded == YES) {
                accordionSectionObject = accordionObject;
                break;
            }
        }
    }
    
    if (accordionSectionObject) {
        // Remove all rows, footer, header for the corresponding section
        
        accordionSectionObject.isExpanded = NO;
        [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@0];
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:[_rkAccordionObjectArray indexOfObject:accordionSectionObject] inSection:0];
        NSMutableArray *indexPaths = [NSMutableArray new];
        NSInteger numberOfRows = accordionSectionObject.numberOfRows;
        
        if (accordionSectionObject.isHeaderRequired) {
            numberOfRows += 1;
        }
        
        if (accordionSectionObject.isFooterRequired) {
            numberOfRows += 1;
        }
        
        if (numberOfRows != 0) {
            for (NSInteger i = sectionIndexPath.row + 1 ; i <= sectionIndexPath.row+numberOfRows ; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndexPath.row+1, numberOfRows)]];
            [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rkAccordionObjectArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RKAccordionObject *accordionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
    switch (accordionObject.objectType) {
        case AccordionSection:
            if ([self.accordionDelegate respondsToSelector:@selector(accordion:heightForSection:)]) {
                return [self.accordionDelegate accordion:self.accordionTableView heightForSection:accordionObject.sectionNumber];
            }
            break;
        case AccordionRow:
            if ([self.accordionDelegate respondsToSelector:@selector(accordion:heightForRow:inSection:)]) {
                return [self.accordionDelegate accordion:self.accordionTableView heightForRow:accordionObject.rowNumber inSection:accordionObject.sectionNumber];
            }
            break;
        case AccordionHeader:
            if ([self.accordionDelegate respondsToSelector:@selector(accordion:heightForHeaderInSection:)]) {
                return [self.accordionDelegate accordion:self.accordionTableView heightForHeaderInSection:accordionObject.sectionNumber];
            }
            break;
        case AccordionFooter:
            if ([self.accordionDelegate respondsToSelector:@selector(accordion:heightForFooterInSection:)]) {
                return [self.accordionDelegate accordion:self.accordionTableView heightForFooterInSection:accordionObject.sectionNumber];
            }
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RKAccordionObject *accordionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
    
    if (accordionObject.objectType == AccordionSection) {
        if (self.accordionDataSource) {
            RKAccordionCell *cell = [self.accordionDataSource accordion:self.accordionTableView cellForSection:accordionObject.sectionNumber];
            return cell;
        } else {
            return [[UITableViewCell alloc] init];
        }
        
    } else if (accordionObject.objectType == AccordionRow) {
        if (self.accordionDataSource) {
            RKAccordionCell *cell = [self.accordionDataSource accordion:self.accordionTableView cellForRow:accordionObject.rowNumber inSection:accordionObject.sectionNumber];
            return cell;
        } else {
            return [[UITableViewCell alloc] init];
        }
    } else if (accordionObject.objectType == AccordionFooter) {
        if (self.accordionDelegate) {
            RKAccordionCell *cell = [self.accordionDelegate accordion:self.accordionTableView cellForFooterInSection:accordionObject.sectionNumber];
            return cell;
        } else {
            return [[UITableViewCell alloc] init];
        }
    } else if (accordionObject.objectType == AccordionHeader) {
        if (self.accordionDelegate) {
            RKAccordionCell *cell = [self.accordionDelegate accordion:self.accordionTableView cellForHeaderInSection:accordionObject.sectionNumber];
            return cell;
        } else {
            return [[UITableViewCell alloc] init];
        }
    }
    
    return [[RKAccordionCell alloc] init];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    RKAccordionObject *accordionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
    
    if (accordionObject.objectType == AccordionSection) {
        return YES;
    } else {
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    RKAccordionObject *accordionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
    if (accordionObject.objectType == AccordionSection) {
        if ([self.accordionDataSource respondsToSelector:@selector(accordion:canMoveSection:)]) {
            return [self.accordionDataSource accordion:self.accordionTableView canMoveSection:accordionObject.sectionNumber];
        }
    } else if (accordionObject.objectType == AccordionRow) {
        if ([self.accordionDataSource respondsToSelector:@selector(accordion:canMoveRow:inSection:)]) {
            return [self.accordionDataSource accordion:self.accordionTableView canMoveRow:accordionObject.rowNumber inSection:accordionObject.sectionNumber];
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView willBeginReorderingRowAtIndexPath:(NSIndexPath *)indexPath {
    RKAccordionObject *accordionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
    if (accordionObject.objectType == AccordionSection) {
        if ([self.accordionDelegate respondsToSelector:@selector(accordion:willBeginReorderingSection:)]) {
            [self.accordionDelegate accordion:self.accordionTableView willBeginReorderingSection:accordionObject.sectionNumber];
        }
    } else if (accordionObject.objectType == AccordionRow) {
        if ([self.accordionDelegate respondsToSelector:@selector(accordion:willBeginReorderingRow:inSection:)]) {
            [self.accordionDelegate accordion:self.accordionTableView willBeginReorderingRow:accordionObject.rowNumber inSection:accordionObject.sectionNumber];
        }
    }
}

#pragma mark UITableViewDataSource

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    RKAccordionObject *accordionObjectFrom = [_rkAccordionObjectArray objectAtIndex:fromIndexPath.row];
    RKAccordionObject *accordionObjectTo = [_rkAccordionObjectArray objectAtIndex:toIndexPath.row];
    
    // Ignore if the item is dragged and dropped to initial position
    if (![accordionObjectFrom isEqual:accordionObjectTo]) {
        NSInteger fromSectionNumber = accordionObjectFrom.sectionNumber, toSectionNumber = accordionObjectTo.sectionNumber;
        
        if (accordionObjectFrom.objectType == AccordionSection) {
            // Logic for Drag & Drop accordion sections
            if ((accordionObjectTo.objectType == AccordionSection) && (fromSectionNumber != toSectionNumber)) {
                [self moveAccordionSection:accordionObjectFrom.sectionNumber toSection:accordionObjectTo.sectionNumber];
            } else {
                if (accordionObjectTo.sectionNumber > accordionObjectFrom.sectionNumber) {
                    [self moveAccordionSection:accordionObjectFrom.sectionNumber toSection:accordionObjectTo.sectionNumber];
                } else {
                    if (fromSectionNumber == toSectionNumber + 1) {
                        [self.accordionTableView reloadData];
                    } else {
                        [self moveAccordionSection:accordionObjectFrom.sectionNumber toSection:accordionObjectTo.sectionNumber + 1];
                    }
                }
            }
        } else {
            // Logic for Drag & Drop accordion rows
            
            NSInteger fromRowNumber = accordionObjectFrom.rowNumber, toRowNumber = accordionObjectTo.rowNumber;
            if (accordionObjectTo.objectType == AccordionSection) {
                // Drag & Drop Logic When placing a row beneath a section
                if (accordionObjectFrom.sectionNumber >= accordionObjectTo.sectionNumber && accordionObjectTo.sectionNumber != 0) {
                    toSectionNumber = accordionObjectTo.sectionNumber - 1;
                    RKAccordionObject *toSectionObject = [self objectForSection:toSectionNumber];
                    if (toSectionObject.isExpanded == YES) {
                        toRowNumber = toSectionObject.numberOfRows;
                    } else {
                        toRowNumber = 0;
                    }
                }
            }
            
            if ((fromSectionNumber == toSectionNumber) && (fromRowNumber != toRowNumber)) {
                [self moveToAccordionObject:accordionObjectTo fromRow:fromRowNumber inSection:fromSectionNumber toRow:toRowNumber inSection:toSectionNumber];
                
            } else {
                // Drag & Drop Logic for rows in different sections
                [self moveToAccordionObject:accordionObjectTo fromRow:fromRowNumber inSection:fromSectionNumber toRow:toRowNumber inSection:toSectionNumber];
            }
        }
        [self reloadAndRestoreExpandedState];
    }
}

@end
