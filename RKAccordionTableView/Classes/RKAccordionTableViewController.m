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

- (void)reloadValues {
    _numberOfSections = 0;
//    NSInteger numberOfRows = 0;
    self.sectionCountArray = [[NSMutableArray alloc] init];
    if (self.accordionDataSource) {
        _numberOfSections = [self.accordionDataSource numberOfSectionsInAccordion:self.accordionTableView];
//        numberOfRows = _numberOfSections;
        _rkAccordionObjectArray = [NSMutableArray new];
        if (_numberOfSections != 0) {
            for (NSInteger i=0; i < _numberOfSections; i++) {
                NSInteger numberOfRowsInCurrentSection = [self.accordionDataSource numberOfRowsInSection:i accordion:self.accordionTableView];
                RKAccordionObject *object = [[RKAccordionObject alloc] init];
                object.sectionNumber = i;
                object.objectType = AccordionSection;
                object.numberOfRows = numberOfRowsInCurrentSection;
                if ([self.accordionDelegate respondsToSelector:@selector(accordion:isFooterRequiredInSection:)]) {
                    object.isFooterRequired = [self.accordionDelegate accordion:self.accordionTableView isFooterRequiredInSection:i];
                }
                [_rkAccordionObjectArray addObject:object];
                
//                numberOfRows += numberOfRowsInCurrentSection;
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

- (UIView*)huntedSubviewWithClassName:(NSString*)className forView:(UIView *)view
{
    if([[[view class] description] isEqualToString:className])
        return view;
    
    for(UIView* subView in view.subviews)
    {
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
    for (int i=0; i<_numberOfSections; i++) {
        RKAccordionObject *accordionSectionObject = [self objectForSection:i];
        if ([_isExpandedArray[accordionSectionObject.sectionNumber] isEqual:@1]) {
            NSInteger numberOfRows = accordionSectionObject.numberOfRows;
            accordionSectionObject.isExpanded = YES;
            NSInteger row = [_rkAccordionObjectArray indexOfObject:accordionSectionObject];
            NSMutableArray *indexPaths = [NSMutableArray new];
            if (numberOfRows != 0) {
                NSInteger i = 0;
                for (i=row+1; i<=row+numberOfRows; i++) {
                    RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                    accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                    accordionObject.rowNumber = i - row - 1;
                    accordionObject.objectType = AccordionRow;
                    [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
//                [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            if (accordionSectionObject.isFooterRequired) {
                [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@1];
                accordionSectionObject.isExpanded = YES;
                RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                accordionObject.objectType = AccordionFooter;
                [_rkAccordionObjectArray insertObject:accordionObject atIndex:row+numberOfRows+1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
    }
    [self.accordionTableView reloadData];
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
//            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recogniozerDidTap:)];
//            [cell addGestureRecognizer:tapGestureRecognizer];
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
    }
    
    return [[RKAccordionCell alloc] init];
    
//    NSInteger remainder = (indexPath.row) % _numberOfSections;
//    NSInteger quotient = (indexPath.row) / _numberOfSections;
//    
//    if ([self.sectionCountArray containsObject:@(indexPath.row)] == YES) {
//        if (self.accordionDataSource) {
//            return [self.accordionDataSource tableView:self.accordionTableView cellForSectionAtIndexPath:indexPath section:quotient];
//        } else {
//            return [[UITableViewCell alloc] init];
//        }
//    } else {
//        if (self.accordionDataSource) {
//            return [self.accordionDataSource tableView:self.accordionTableView cellForRowAtIndexPath:indexPath row:remainder];
//        } else {
//            return [[UITableViewCell alloc] init];
//        }
//    }
    
    
    
//    if (remainder == 0) {
//        if (self.accordionDataSource) {
//          return [self.accordionDataSource tableView:self.accordionTableView cellForSectionAtIndexPath:indexPath section:quotient];
//        } else {
//            return [[UITableViewCell alloc] init];
//        }
//    } else {
//        if (self.accordionDataSource) {
//            return [self.accordionDataSource tableView:self.accordionTableView cellForRowAtIndexPath:indexPath row:remainder];
//        } else {
//            return [[UITableViewCell alloc] init];
//        }
//    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    RKAccordionObject *accordionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
//    [self reorderControlCustomisationForCell:cell];
    if (accordionObject.objectType == AccordionSection) {
    } else {
        
    }
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  NO;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    RKAccordionObject *accordionObjectFrom = [_rkAccordionObjectArray objectAtIndex:fromIndexPath.row];
    RKAccordionObject *accordionObjectTo = [_rkAccordionObjectArray objectAtIndex:toIndexPath.row];
    if ([accordionObjectFrom isEqual:accordionObjectTo] != YES) {
        
    
    NSInteger fromSectionNumber = accordionObjectFrom.sectionNumber, toSectionNumber = accordionObjectTo.sectionNumber;
    if (accordionObjectFrom.objectType == AccordionSection) {
        if (accordionObjectTo.objectType == AccordionSection) {
            if (fromSectionNumber == toSectionNumber) {
                [self.accordionTableView reloadData];
            } else {
                if([self.accordionDataSource respondsToSelector:@selector(accordion:moveSection:toSection:)]) {
                    fromSectionNumber = accordionObjectFrom.sectionNumber;
                    toSectionNumber = accordionObjectTo.sectionNumber;
                    
                    NSNumber *fromSectionExpandedState = _isExpandedArray[fromSectionNumber];
//                    _isExpandedArray[fromSectionNumber] = @(accordionObjectTo.isExpanded);
                    [_isExpandedArray removeObjectAtIndex:fromSectionNumber];
                    [_isExpandedArray insertObject:fromSectionExpandedState atIndex:toSectionNumber];
//                    _isExpandedArray[toSectionNumber] = @(accordionObjectFrom.isExpanded);
                    
                    [self.accordionDataSource accordion:self.accordionTableView moveSection:fromSectionNumber toSection:toSectionNumber];
                }
            }
        }
        [self.accordionTableView reloadValues];
        [self restoreExpandedState];
    } else {
        NSInteger fromRowNumber = accordionObjectFrom.rowNumber, toRowNumber = accordionObjectTo.rowNumber;
        if (accordionObjectTo.objectType == AccordionSection) {
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
        if (fromSectionNumber == toSectionNumber) {
            if (fromRowNumber == toRowNumber) {
                [self.accordionTableView reloadData];
            } else {
                if (accordionObjectTo.objectType == AccordionFooter) {
                    [self.accordionTableView reloadData];
                }else {
                if([self.accordionDataSource respondsToSelector:@selector(accordion:moveRow:inSection:toRow:inSection:)]) {
                    [self.accordionDataSource accordion:self.accordionTableView moveRow:fromRowNumber inSection:fromSectionNumber toRow:toRowNumber inSection:toSectionNumber];
                }
                [self.accordionTableView reloadValues];
                [self restoreExpandedState];
                }
            }
           
        } else {
            if (accordionObjectTo.objectType == AccordionFooter) {
                [self.accordionTableView reloadData];
            } else {
            if([self.accordionDataSource respondsToSelector:@selector(accordion:moveRow:inSection:toRow:inSection:)]) {
                [self.accordionDataSource accordion:self.accordionTableView moveRow:fromRowNumber inSection:fromSectionNumber toRow:toRowNumber inSection:toSectionNumber];
            }
            [self.accordionTableView reloadValues];
            [self restoreExpandedState];
            }
        }
//            accordionObjectFrom = [_rkAccordionObjectArray objectAtIndex:fromSectionNumber];
//            accordionObjectFrom.isExpanded = YES;
//            NSInteger numberOfRows = accordionObjectFrom.numberOfRows;
//            NSMutableArray *indexPaths = [NSMutableArray new];
//            if (numberOfRows != 0) {
//                for (NSInteger i=fromSectionNumber + 1; i <= fromSectionNumber + numberOfRows; i++) {
//                    RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
//                    accordionObject.sectionNumber = fromSectionNumber;
//                    accordionObject.rowNumber = i - fromSectionNumber - 1;
//                    accordionObject.isSection = NO;
//                    [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
//                    [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//                }
//                [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//                //            [self.accordionTableView reloadData];
//            }
        }
    }

//
//    if (accordionObjectFrom.isSection == YES) {
//        if (accordionObjectTo.isSection == YES) {
//            [_rkAccordionObjectArray removeObjectAtIndex:fromIndexPath.row];
//            [_rkAccordionObjectArray insertObject:accordionObjectFrom atIndex:toIndexPath.row];
//        } else {
//            [self.accordionTableView reloadData];
//        }
//    } else {
//        [_rkAccordionObjectArray removeObjectAtIndex:fromIndexPath.row];
//        [_rkAccordionObjectArray insertObject:accordionObjectFrom atIndex:toIndexPath.row];
//        
//        NSInteger j=0; NSInteger currentSectionNumber=0;RKAccordionObject *object1 = nil;
//        for (NSInteger i=0; i<_rkAccordionObjectArray.count; i++) {
//            RKAccordionObject *object = [_rkAccordionObjectArray objectAtIndex:i];
//            if (object.isSection == YES) {
//                for (j=i+1; j<_rkAccordionObjectArray.count; j++) {
//                    object1 = [_rkAccordionObjectArray objectAtIndex:j];
//                    if (object1.isSection == YES) {
//                        break;
//                    } else {
//                        object1.sectionNumber = currentSectionNumber;
//                        object1.rowNumber = j-i-1;
//                    }
//                }
//                object.numberOfRows = j-i-1;
//                currentSectionNumber += 1;
//            }
//
//        }
//        
//    }
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

- (void)recogniozerDidTap:(UITapGestureRecognizer *)recognizer {
    if (_isExpandedArray == nil) {
        _isExpandedArray = [NSMutableArray new];
        for (int i = 0 ; i < _rkAccordionObjectArray.count; i++) {
            [_isExpandedArray addObject:@0];
        }
    }
    UITableViewCell *cell = (UITableViewCell *)recognizer.view;
    NSIndexPath *indexPath = [self.accordionTableView indexPathForCell:cell];
    RKAccordionObject *accordionSectionObject = [_rkAccordionObjectArray objectAtIndex:indexPath.row];
    NSMutableArray *indexPaths = [NSMutableArray new];
    if (accordionSectionObject.isExpanded == YES) {
        NSInteger numberOfRows = accordionSectionObject.numberOfRows;
        if (numberOfRows != 0) {
            [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@0];
            accordionSectionObject.isExpanded = NO;
            for (NSInteger i=indexPath.row+1; i<=indexPath.row+numberOfRows; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row+1, numberOfRows)]];
            [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.accordionTableView reloadData];
        }
    } else {
        NSInteger numberOfRows = accordionSectionObject.numberOfRows;
        
        if (numberOfRows != 0) {
            [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@1];
            accordionSectionObject.isExpanded = YES;
            for (NSInteger i=indexPath.row+1; i<=indexPath.row+numberOfRows; i++) {
                RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                accordionObject.rowNumber = i - indexPath.row - 1;
                accordionObject.objectType = AccordionRow;
                [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.accordionTableView reloadData];
        }
    }
}

- (void)tapActionForSection:(NSInteger)section {
    if (_isExpandedArray == nil) {
        _isExpandedArray = [NSMutableArray new];
        for (int i = 0 ; i < _rkAccordionObjectArray.count; i++) {
            [_isExpandedArray addObject:@0];
        }
    }
//    UITableViewCell *cell = (UITableViewCell *)sender.view;
//    NSIndexPath *indexPath = [self.accordionTableView indexPathForCell:cell];
    RKAccordionObject *accordionSectionObject = [self objectForSection:section];
    NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:[_rkAccordionObjectArray indexOfObject:accordionSectionObject] inSection:0];
    NSMutableArray *indexPaths = [NSMutableArray new];
    if (accordionSectionObject.isExpanded == YES) {
        NSInteger numberOfRows = accordionSectionObject.numberOfRows;
        if (numberOfRows != 0) {
            [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@0];
            accordionSectionObject.isExpanded = NO;
            NSInteger i = 0;
            for (i=sectionIndexPath.row+1; i<=sectionIndexPath.row+numberOfRows; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }
            if (accordionSectionObject.isFooterRequired) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
                numberOfRows += 1;
            }
            
            [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndexPath.row+1, numberOfRows)]];
            [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [self.accordionTableView reloadData];
        } else {
            if (accordionSectionObject.isFooterRequired) {
                [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@0];
                accordionSectionObject.isExpanded = NO;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionIndexPath.row+1 inSection:0];
                [indexPaths addObject:indexPath];
                numberOfRows += 1;
                [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndexPath.row+1, numberOfRows)]];
                [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } else {
        if (self.accordionTableView.allowMultipleSectionsOpen == NO) {
            [self removePreviousSections];
        }
        RKAccordionObject *accordionSectionObject = [self objectForSection:section];
        NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:[_rkAccordionObjectArray indexOfObject:accordionSectionObject] inSection:0];
        NSMutableArray *indexPaths = [NSMutableArray new];
        NSInteger numberOfRows = accordionSectionObject.numberOfRows;
        if (numberOfRows != 0) {
            [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@1];
            accordionSectionObject.isExpanded = YES;
            NSInteger i = 0;
            for (i=sectionIndexPath.row+1; i<=sectionIndexPath.row+numberOfRows; i++) {
                RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                accordionObject.rowNumber = i - sectionIndexPath.row - 1;
                accordionObject.objectType = AccordionRow;
                [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            if (accordionSectionObject.isFooterRequired) {
                RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                accordionObject.rowNumber = i - sectionIndexPath.row - 1;
                accordionObject.objectType = AccordionFooter;
                [_rkAccordionObjectArray insertObject:accordionObject atIndex:i];
                [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [self.accordionTableView reloadData];
        } else {
            if (accordionSectionObject.isFooterRequired) {
                [_isExpandedArray replaceObjectAtIndex:accordionSectionObject.sectionNumber withObject:@1];
                accordionSectionObject.isExpanded = YES;
                RKAccordionObject *accordionObject = [[RKAccordionObject alloc] init];
                accordionObject.sectionNumber = accordionSectionObject.sectionNumber;
                accordionObject.objectType = AccordionFooter;
                [_rkAccordionObjectArray insertObject:accordionObject atIndex:sectionIndexPath.row+1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:sectionIndexPath.row+1 inSection:0]];
                [self.accordionTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    }
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

- (void)removePreviousSections {
    RKAccordionObject *accordionObject =  nil;
    for (RKAccordionObject *accordionSectionObject in _rkAccordionObjectArray) {
        if (accordionSectionObject.objectType == AccordionSection) {
            if (accordionSectionObject.isExpanded == YES) {
            accordionObject = accordionSectionObject;
            break;
            }
        }
    }
    
    if (accordionObject) {
        [_isExpandedArray replaceObjectAtIndex:accordionObject.sectionNumber withObject:@0];
            NSMutableArray *indexPaths = [NSMutableArray new];
            NSInteger numberOfRows = accordionObject.numberOfRows;
            NSIndexPath *sectionIndexPath = [NSIndexPath indexPathForRow:[_rkAccordionObjectArray indexOfObject:accordionObject] inSection:0];
            if (numberOfRows != 0) {
                [_isExpandedArray replaceObjectAtIndex:accordionObject.sectionNumber withObject:@0];
                accordionObject.isExpanded = NO;
                NSInteger i = 0;
                for (i=sectionIndexPath.row+1; i<=sectionIndexPath.row+numberOfRows; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:indexPath];
                }
                if (accordionObject.isFooterRequired) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [indexPaths addObject:indexPath];
                    numberOfRows += 1;
                }
                [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndexPath.row+1, numberOfRows)]];
                [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                if (accordionObject.isFooterRequired) {
                    [_isExpandedArray replaceObjectAtIndex:accordionObject.sectionNumber withObject:@0];
                    accordionObject.isExpanded = NO;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sectionIndexPath.row+1 inSection:0];
                    [indexPaths addObject:indexPath];
                    numberOfRows += 1;
                    [_rkAccordionObjectArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(sectionIndexPath.row+1, numberOfRows)]];
                    [self.accordionTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
}

@end
