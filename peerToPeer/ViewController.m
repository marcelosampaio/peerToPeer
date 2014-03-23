//
//  ViewController.m
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/22/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark - Initilization
- (void)viewDidLoad
{
    [super viewDidLoad];
   
}

#pragma mark - UI ACtions
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction=[(UISwipeGestureRecognizer *) sender direction];
    switch (direction) {
            
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"left");
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            NSLog(@"right");
            break;

        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"up");
            break;
            
        default:
            NSLog(@"down");
            break;
    }
}



#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
