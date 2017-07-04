//
//  RKAccordionCell.m
//  
//
//  Created by Pai on 7/3/17.
//
//

#import "RKAccordionCell.h"
#define REORDER_CONTROL_CLASSNAME @"UITableViewCellReorderControl"

@interface RKAccordionCell ()
{
    __weak UIView *_reorderControl;
}
@end

@implementation RKAccordionCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//-(void) setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    if (editing)
//    {
//        [self reorderControlCustomisationForCell:self];
//    }
//}
//
//- (void)reorderControlCustomisationForCell:(UITableViewCell *)cell {
//    UIView* reorderControl = [self huntedSubviewWithClassName:@"UITableViewCellReorderControl" forView:cell];
//    
//    if ([reorderControl.superview isEqual:self]) {
//        UIView* resizedGripView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(reorderControl.frame), CGRectGetMaxY(reorderControl.frame))];
//        [resizedGripView addSubview:reorderControl];
//        [cell.contentView addSubview:resizedGripView];
//        [cell.contentView sendSubviewToBack:resizedGripView];
//        
//        resizedGripView.frame = cell.bounds;
//        reorderControl.frame = cell.bounds;
//        reorderControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    }
//    
////    for(UIImageView* cellGrip in reorderControl.subviews)
////    {
////        if([cellGrip isKindOfClass:[UIImageView class]])
////            [cellGrip setImage:nil];
////    }
//}
//
//- (UIView*)huntedSubviewWithClassName:(NSString*)className forView:(UIView *)view
//{
//    if([[[view class] description] isEqualToString:className])
//        return view;
//    
//    for(UIView* subView in view.subviews)
//    {
//        UIView* huntedSubview = [self huntedSubviewWithClassName:className forView:subView];
//        
//        if(huntedSubview != nil)
//            return huntedSubview;
//    }
//    
//    return nil;
//}

- (void)layoutSubviews
{
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self setAndHideReorderControl];
}

/*
 Find the reorder control, store a reference and hide it.
 */

- (void) setAndHideReorderControl
{
    if (_reorderControl)
        return;
    
    // > iOS 7
    for(UIView* view in [[self.subviews objectAtIndex:0] subviews])
        if([[[view class] description] isEqualToString:REORDER_CONTROL_CLASSNAME])
            _reorderControl = view;
    
    // < iOS 7
    if (!_reorderControl)
        for(UIView* view in self.subviews)
            if([[[view class] description] isEqualToString:REORDER_CONTROL_CLASSNAME])
                _reorderControl = view;
    
    if (_reorderControl)
    {
        [_reorderControl setHidden:YES];
    }
}


#pragma mark - Touch magic

/*
 Just perform the specific selectors on the hidden reorder control to fire touch events on the control.
 */

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_reorderControl && [_reorderControl respondsToSelector:@selector(beginTrackingWithTouch:withEvent:)])
    {
        UITouch * touch = [touches anyObject];
        [_reorderControl performSelector:@selector(beginTrackingWithTouch:withEvent:) withObject:touch withObject:event];
    }
    
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_reorderControl && [_reorderControl respondsToSelector:@selector(continueTrackingWithTouch:withEvent:)])
    {
        UITouch * touch = [touches anyObject];
        [_reorderControl performSelector:@selector(continueTrackingWithTouch:withEvent:) withObject:touch withObject:event];
    }
    
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_reorderControl && [_reorderControl respondsToSelector:@selector(cancelTrackingWithEvent:)])
    {
        [_reorderControl performSelector:@selector(cancelTrackingWithEvent:) withObject:event];
    }
    
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_reorderControl && [_reorderControl respondsToSelector:@selector(endTrackingWithTouch:withEvent:)])
    {
        UITouch * touch = [touches anyObject];
        [_reorderControl performSelector:@selector(endTrackingWithTouch:withEvent:) withObject:touch withObject:event];
    }
    
    [super touchesEnded:touches withEvent:event];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

@end
