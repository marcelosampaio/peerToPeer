//
//  Cell.h
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/30/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cell : NSObject

@property(strong,nonatomic) NSString *location;
@property CGPoint locationCoordinate;
@property (strong,nonatomic) NSString *locationContent;


-(id)initWithLocation:(NSString *)cellLocation coordinate:(CGPoint)cellCoordinate content:(NSString *)cellContent;

@end
