//
//  WorldViewController.m
//  xkcd
//
//  Created by Tyler Stromberg on 9/19/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "WorldViewController.h"

@interface WorldViewController()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@end


#pragma mark -

@implementation WorldViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Zoom in to the last pane of the original comic
    [self.scrollView zoomToRect:CGRectMake(4244.0f, 1744.0f, 10.0f, 10.0f) animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


#pragma mark - Zooming

- (IBAction)zoomIn:(UIGestureRecognizer *)gestureRecognizer
{
    CGRect zoomRect = [self zoomRectForScale:self.scrollView.zoomScale * 2
                                  withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [(UIScrollView *)self.view zoomToRect:zoomRect animated:YES];
}

- (IBAction)zoomOut:(UIGestureRecognizer *)gestureRecognizer
{
    CGRect zoomRect = [self zoomRectForScale:self.scrollView.zoomScale / 1.5
                                  withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    [(UIScrollView *)self.view zoomToRect:zoomRect animated:YES];
}

// Adapted from TapToZoom in Apple's ScrollViewSuite
- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGRect zoomRect = CGRectZero;
    zoomRect.size = CGSizeMake(self.scrollView.frame.size.width / scale,
                               self.scrollView.frame.size.height / scale);
    zoomRect.origin = CGPointMake(center.x - (zoomRect.size.width / 2.0f),
                                  center.y - (zoomRect.size.height / 2.0f));
    
    return zoomRect;
}

@end
