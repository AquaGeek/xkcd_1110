//
//  TilingScrollView.m
//  xkcd
//
//  Created by Tyler Stromberg on 9/19/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//

#import "TilingScrollView.h"

#import "TilingView.h"

@interface TilingScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet TilingView *tilingView;

@end


#pragma mark -

@implementation TilingScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    
    return self;
}

// Extracted from Apple's PhotoScroller
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.tilingView.frame;
    
    // Center horizontally
    if (frameToCenter.size.width < boundsSize.width)
    {
        frameToCenter.origin.x = roundf((boundsSize.width - frameToCenter.size.width) / 2);
    }
    else
    {
        frameToCenter.origin.x = 0.0f;
    }
    
    // Center vertically
    if (frameToCenter.size.height < boundsSize.height)
    {
        frameToCenter.origin.y = roundf((boundsSize.height - frameToCenter.size.height) / 2);
    }
    else
    {
        frameToCenter.origin.y = 0.0f;
    }
    
    self.tilingView.frame = frameToCenter;
    self.tilingView.contentScaleFactor = 1.0f;
}


#pragma mark - UIScrollView Delegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.tilingView;
}

@end
