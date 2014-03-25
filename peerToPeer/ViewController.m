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

@property int blankSpaceCreated;
@property int blankSpacePositionNumber;

@property int blankRow;
@property int blankColumn;

@end

@implementation ViewController

@synthesize xPrint,yPrint;
@synthesize blankSpaceCreated,blankSpacePositionNumber;
@synthesize swipeBaseX,swipeBaseY;
@synthesize blankCandidates;
@synthesize blankColumn,blankRow;


#pragma mark - Initilization
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create board
    [self createBoard];

   
}

-(void)createBoard
{
    // Blank Space in the board
    blankRow=0;
    blankColumn=0;
    
    // Available cell for the blank space
    self.blankCandidates=[[NSArray alloc]initWithObjects:@"11",@"12",@"13",@"14",@"21",@"22",@"23",@"24",@"31",@"32",@"33",@"34",@"41",@"42",@"43",@"44", nil];
    self.blankSpaceCreated=NO;
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
    [self loadCellAtCoordinateX:xPrint CoordinateY:yPrint RowIndex:rowIndex ColumnIndex:columnIndex];
}

-(void)loadCellAtCoordinateX:(float)coordinateX CoordinateY:(float)coordinateY RowIndex:(int)rowIndex ColumnIndex:(int)columnIndex
{
    int numericLocation=(rowIndex*10)+columnIndex;

    
    // Generate random spare space on the board
    if (!blankSpaceCreated) {
        int num=arc4random() %16;

        blankSpacePositionNumber=[[self.blankCandidates objectAtIndex:num]intValue];
        blankSpaceCreated=YES;
        
        blankRow=blankSpacePositionNumber/10;
        blankColumn=blankSpacePositionNumber-(blankRow*10);

    }
    
    if (blankRow==rowIndex && blankColumn==columnIndex) {
        self.swipeBaseX=coordinateX;
        self.swipeBaseY=coordinateY;
    } else {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(coordinateX, coordinateY, BOARD_CELL_WIDTH, BOARD_CELL_HEIGTH)];
        
        if (rowIndex==0 || columnIndex==0 || rowIndex==5 || columnIndex==5) {
            img.backgroundColor=[UIColor darkGrayColor];
        } else {
            img.backgroundColor=[UIColor lightGrayColor];
        }
        
        img.tag=numericLocation;
        [self.view addSubview:img];

    }
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
    // Determine Origin and Target
    CGPoint origin=CGPointMake(0,0);
    CGPoint target=CGPointMake(self.blankRow, self.blankColumn);
    
    NSLog(@"blanRow=%d   blankColumn=%d",blankRow,blankColumn);
    
    
    if ([direction isEqualToString:@"left"]) {
        if (self.blankColumn==1) {
            NSLog(@"LEFT - invalid swipe");
        } else {
            NSLog(@"LEFT - OK");
        }
        
    } else if (([direction isEqualToString:@"right"])) {
        if (self.blankColumn==4) {
            NSLog(@"RIGHT - invalid swipe");
        } else {
            NSLog(@"RIGHT - OK");
        }
    } else if (([direction isEqualToString:@"up"])) {
        if (self.blankRow==4) {
            NSLog(@"UP - invalid swipe");
        } else {
            NSLog(@"UP - OK");
        }
    } else if (([direction isEqualToString:@"down"])) {
        if (self.blankRow==1) {
            NSLog(@"DOWN - swipe invalido");
        } else {
            NSLog(@"DOWN - OK");
        }
    }
    
    // Animation
    
//    // INICIO DA ANIMACAO
//    [UIView animateWithDuration:0.95f animations:^(void)
//     // Aqui se faz a animacao
//     {
//         self.imgRover.center=coordenadaDestonoDoHover;
//         
//         //NSLog(@"coordX=%f",coordX);
//         //NSLog(@"coordY=%f",coordY);
//         
//         
//     } completion:^(BOOL finished)
//     //  Aqui executamos os procedimentos logo apos o termino da animacao
//     {
//         //NSLog(@"vamos reentrar");
//         [self executaInstrucoes:destinos];
//     }];
//    // FIM DA ANIMACAO
//    [UIView commitAnimations];

    
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
