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
#define BOARD_CELL_HEIGHT       50
#define BOARD_CELL_WIDTH        50
#define BOARD_BASE_COORD_X      10
#define BOARD_BASE_COORD_Y      130
#define BOARD_ANIMATION_TIME    0.10f


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

@synthesize blankCandidates;
@synthesize blankColumn,blankRow;

@synthesize cells;

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
    
    // Relationship between cell & content
    self.cells=[[NSMutableDictionary alloc]init];

    self.blankSpaceCreated=NO;
    for (int rowIndex=0; rowIndex<BOARD_ROWS; rowIndex++) {
        for (int columnIndex=0; columnIndex<BOARD_COLUMNS; columnIndex++) {
            [self createBoardCellAtRow:rowIndex Column:columnIndex];
        }
    }
    
    for (NSString *key in self.cells){
        NSLog(@"key=%@   value=%@",key,[self.cells objectForKey:key]);
    }
}

-(void)createBoardCellAtRow:(int)rowIndex Column:(int)columnIndex
{
    if (rowIndex==0 && columnIndex==0) {
        xPrint=BOARD_BASE_COORD_X;
        yPrint=BOARD_BASE_COORD_Y;
    } else if (columnIndex==0) {
        xPrint=BOARD_BASE_COORD_X;
        yPrint=yPrint+BOARD_CELL_HEIGHT;
    } else {
        xPrint=xPrint+BOARD_CELL_WIDTH;
    }
    [self loadCellAtCoordinateX:xPrint CoordinateY:yPrint RowIndex:rowIndex ColumnIndex:columnIndex];
}

-(void)loadCellAtCoordinateX:(float)coordinateX CoordinateY:(float)coordinateY RowIndex:(int)rowIndex ColumnIndex:(int)columnIndex
{
    int numericLocation=(rowIndex*10)+columnIndex;
    NSString *location=[NSString stringWithFormat:@"%d",numericLocation];
    
    
    // Generate random spare space on the board
    if (!blankSpaceCreated) {
        int num=arc4random() %16;

        blankSpacePositionNumber=[[self.blankCandidates objectAtIndex:num]intValue];
        blankSpaceCreated=YES;
//        
        blankRow=blankSpacePositionNumber/10;
        blankColumn=blankSpacePositionNumber-(blankRow*10);
        
        
        NSLog(@"generated blank Row & Column  row=%d  column=%d",self.blankRow,self.blankColumn);

    }
    
    if (blankRow==rowIndex && blankColumn==columnIndex) {
        [self.cells setValue:@"0" forKey:location];
    } else {
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(coordinateX, coordinateY, BOARD_CELL_WIDTH, BOARD_CELL_HEIGHT)];
        if (rowIndex==0 || columnIndex==0 || rowIndex==5 || columnIndex==5) {
            img.backgroundColor=[UIColor darkGrayColor];
        } else {
            if (rowIndex==1) {
                img.backgroundColor=[UIColor yellowColor];
            }else if (rowIndex==2) {
                img.backgroundColor=[UIColor greenColor];
            }else if (rowIndex==3) {
                img.backgroundColor=[UIColor blueColor];
            }else{
                img.backgroundColor=[UIColor redColor];
            }
            [self.cells setValue:location forKey:location];
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
    int moveToRowLocation;
    int moveToColumnLocation;
    
    int rowSeed=0;
    int columnSeed=0;

    // =====================================================
    // Get blank location at any swipe touch
    // =====================================================
    self.blankSpacePositionNumber=[self blankSpaceLocation];
    //======================================================
    
    self.blankRow=blankSpacePositionNumber/10;
    self.blankColumn=blankSpacePositionNumber-(blankRow*10);
    
    NSLog(@" ********  BASE  Blank Space is at blankRow=%d  blankColumn=%d",self.blankRow,self.blankColumn);
    
    
    if ([direction isEqualToString:@"left"]) {
        if (self.blankColumn==4) {
            NSLog(@"LEFT - invalid swipe");
            return;
        } else {
            moveToRowLocation=self.blankRow;
            moveToColumnLocation=self.blankColumn+1;
            
            rowSeed=(-1)*BOARD_CELL_WIDTH;
        }
        
    } else if (([direction isEqualToString:@"right"])) {
        if (self.blankColumn==1) {
            NSLog(@"RIGHT - invalid swipe");
            return;
        } else {
            moveToRowLocation=self.blankRow;
            moveToColumnLocation=self.blankColumn-1;
            
            rowSeed=BOARD_CELL_WIDTH;
        }
    } else if (([direction isEqualToString:@"up"])) {
        if (self.blankRow==4) {
            NSLog(@"UP - invalid swipe");
            return;
        } else {
            moveToRowLocation=self.blankRow+1;
            moveToColumnLocation=self.blankColumn;
            
            columnSeed=(-1)*BOARD_CELL_HEIGHT;
        }
    } else if (([direction isEqualToString:@"down"])) {
        if (self.blankRow==1) {
            NSLog(@"DOWN - swipe invalido");
            return;
        } else {
            moveToRowLocation=self.blankRow-1;
            moveToColumnLocation=self.blankColumn;
            
            columnSeed=BOARD_CELL_HEIGHT;
        }
    }
    int movingLocation=(moveToRowLocation*10)+moveToColumnLocation;
    NSLog(@" ******    WILL MOVE object FROM %d        TO location %d%d",movingLocation,self.blankRow,self.blankColumn);

    // Animation
    // INICIO DA ANIMACAO
//    __block NSString *newRowLocation;
//    __block NSString *newColumnLocation;
    
    [UIView animateWithDuration:BOARD_ANIMATION_TIME animations:^(void)
     // Aqui se faz a animacao
     {
         for (UIView *subview in self.view.subviews)
         {
             if (subview.tag==movingLocation) {
                 NSLog(@"                   **** found origin cell in subviews    tag=%d",subview.tag);
                 
                 CGPoint target=CGPointMake(subview.center.x+rowSeed,subview.center.y+columnSeed);
                 subview.center=target;

             }
         }

         

     } completion:^(BOOL finished)
     //  Aqui executamos os procedimentos logo apos o termino da animacao
     {
     }];
    // FIM DA ANIMACAO
    [UIView commitAnimations];

    // Update references
    
    // Update board cells array
    // location where was blank is set to origin location of the movement
    int blankLocation=(self.blankRow*10)+self.blankColumn;
    [self.cells setValue:[NSString stringWithFormat:@"%d",movingLocation] forKey:[NSString stringWithFormat:@"%d",blankLocation]];
    NSLog(@"update -1- board's cell key=%@   value=%@",[NSString stringWithFormat:@"%d",blankLocation],[NSString stringWithFormat:@"%d",movingLocation]);
    
    // origin location is set to blak tag key 0
    [self.cells setValue:@"0" forKey:[NSString stringWithFormat:@"%d",movingLocation]];
    NSLog(@"update -2- board's cell key=%@   value=%@",[NSString stringWithFormat:@"%d",movingLocation],@"0");
    
    
    self.blankRow=moveToRowLocation;
    self.blankColumn=moveToColumnLocation;
    

    NSLog(@"--------NEW LOCATION----------->%d%d",self.blankRow,self.blankColumn);
    
    for (NSString *key in self.cells) {
        NSLog(@"----------->key=%@  value=%@",key,[self.cells objectForKey:key]);
    }

    
}

#pragma mark - Working Methods
-(int)blankSpaceLocation
{
    int blankLocation=0;
    // determine Blank Space Location
    for (NSString *key in self.cells) {
        NSString *value=[self.cells objectForKey:key];
        if ([value isEqualToString:@"0"]) {
            blankLocation=[key intValue];
            NSLog(@"********************* ###### found blankSpace !!!! :)    location=%d",blankLocation);
        }
    }
    return blankLocation;
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
