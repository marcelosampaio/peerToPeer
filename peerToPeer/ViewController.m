//
//  ViewController.m
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/22/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"

// Board Settings Values
#define BOARD_ROWS              6
#define BOARD_COLUMNS           6
#define BOARD_CELL_HEIGTH       50
#define BOARD_CELL_WIDTH        50
#define BOARD_BASE_COORD_X      10
#define BOARD_BASE_COORD_Y      130


@interface ViewController ()

@property float xPrint;
@property float yPrint;

@end

@implementation ViewController

@synthesize xPrint,yPrint;


#pragma mark - Initilization
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create board
    [self createBoard];

   
}

-(void)createBoard
{
    for (int rowIndex=0; rowIndex<BOARD_ROWS; rowIndex++) {
        for (int columnIndex=0; columnIndex<BOARD_COLUMNS; columnIndex++) {
            [self createBoardCellAtRow:rowIndex Column:columnIndex];
        }
    }
}

-(void)createBoardCellAtRow:(int)rowIndex Column:(int)columnIndex
{
    if (rowIndex==0 && columnIndex==0) {
        xPrint=BOARD_BASE_COORD_X;
        yPrint=BOARD_BASE_COORD_Y;
    } else if (columnIndex==0) {
        xPrint=BOARD_BASE_COORD_X;
        yPrint=yPrint+BOARD_CELL_HEIGTH;
    } else {
        xPrint=xPrint+BOARD_CELL_WIDTH;
    }
    [self loadCellAtCoordinateX:xPrint CoordinateY:yPrint];
}

-(void)loadCellAtCoordinateX:(float)coordinateX CoordinateY:(float)coordinateY
{
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(coordinateX, coordinateY, BOARD_CELL_WIDTH, BOARD_CELL_HEIGTH)];
    img.backgroundColor=[UIColor blackColor];
    [self.view addSubview:img];
}




#pragma mark - UI ACtions
- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    UISwipeGestureRecognizerDirection direction=[(UISwipeGestureRecognizer *) sender direction];
    switch (direction) {
            
        case UISwipeGestureRecognizerDirectionLeft:
            [self swiped:@"left"];
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            [self swiped:@"right"];
            break;

        case UISwipeGestureRecognizerDirectionUp:
            [self swiped:@"up"];
            break;

        case UISwipeGestureRecognizerDirectionDown:
            [self swiped:@"down"];
            break;
            
        default:
            break;
    }
}

#pragma mark - Touch Processing
-(void)swiped:(NSString *)direction
{
    NSLog(@"swiped %@",direction);
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
