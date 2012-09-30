//
//  TilingView.m
//  xkcd
//
//  Created by Tyler Stromberg on 9/19/12.
//  Copyright (c) 2012 Tyler Stromberg. All rights reserved.
//
//  Adapted from Apple's PhotoScroller sample code

#import "TilingView.h"

#import <QuartzCore/CATiledLayer.h>

#define ENABLE_TILE_DEBUGGING 0

@implementation TilingView

+ (Class)layerClass
{
    return [CATiledLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        tiledLayer.levelsOfDetail = 0;
        tiledLayer.levelsOfDetailBias = 4;
        tiledLayer.tileSize = CGSizeMake(512.0f, 512.0f);
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat scale = CGContextGetCTM(context).a;
    
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;
    tileSize.width /= scale;
    tileSize.height /= scale;
    
    int firstColumn = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastColumn = floorf((CGRectGetMaxX(rect) - 1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect) - 1) / tileSize.height);
    
    for (int row = firstRow; row <= lastRow; row++)
    {
        for (int column = firstColumn; column <= lastColumn; column++)
        {
            UIImage *tile = [self tileForScale:scale row:row column:column];
            CGRect tileRect = CGRectMake(tileSize.width * column, tileSize.height * row, tileSize.width, tileSize.height);
            tileRect = CGRectIntersection(self.bounds, tileRect);
            [tile drawInRect:tileRect];
            
#if ENABLE_TILE_DEBUGGING
            [[UIColor whiteColor] set];
            CGContextSetLineWidth(context, 6.0 / scale);
            CGContextStrokeRect(context, tileRect);
#endif
        }
    }
}

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    // Account for high resolution screens
    [super setContentScaleFactor:1.0f];
}

- (UIImage *)tileForScale:(CGFloat)scale row:(int)row column:(int)column
{
    NSString *tileName = [NSString stringWithFormat:@"%d-%d-%d", (int)(scale * 1000), column, row];
    UIImage *image = [self tileWithName:tileName];
    
    // Account for nil images
    if (!image)
    {
        // Calculate the relative dividing line between above and below ground
        int undergroundThreshold = (13.0f * scale / 4);
        BOOL underground = row >= undergroundThreshold;
        
        tileName = underground ? @"black" : @"white";
        image = [self tileWithName:tileName];
    }
    
    return image;
}

- (UIImage *)tileWithName:(NSString *)tileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:tileName ofType:@"png"];
    // imageWithContentsOfFile instead of imageNamed because we don't want UIImage to cache the tiles
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

@end
