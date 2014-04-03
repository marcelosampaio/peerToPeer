//
//  ViewController.h
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/22/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


// Swipe Gesture Control
//@property float swipeBaseX;
//@property float swipeBaseY;

@property(nonatomic,strong) NSArray *blankCandidates;

// array of coard's cell objects
@property(nonatomic,strong) NSMutableArray *boardCells;

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;


@end
