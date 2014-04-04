//
//  ViewController.h
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/22/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>


@interface ViewController : UIViewController


// Swipe Gesture Control
//@property float swipeBaseX;
//@property float swipeBaseY;

@property(nonatomic,strong) NSArray *blankCandidates;
@property(nonatomic,strong) NSArray *boardCellImageName;

// array of board's cell objects
@property(nonatomic,strong) NSMutableArray *boardCells;

// AudioToolBox property
@property SystemSoundID soundId;



- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender;


@end
