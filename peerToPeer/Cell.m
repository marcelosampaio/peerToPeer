//
//  Cell.m
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/30/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize location,locationContent,locationCoordinate;


-(id)initWithLocation:(NSString *)cellLocation coordinate:(CGPoint)cellCoordinate content:(NSString *)cellContent
{
    self=[super init];
    if (self) {
        location=cellLocation;
        locationCoordinate=cellCoordinate;
        locationContent=cellContent;
    }
    return self;
}

@end
