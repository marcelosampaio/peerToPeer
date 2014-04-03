//
//  ViewController.m
//  peerToPeer
//
//  Created by Marcelo Sampaio on 3/22/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"

// Board Settings Values
#define BOARD_ROWS              6
#define BOARD_COLUMNS           6
#define BOARD_CELL_HEIGHT       50
#define BOARD_CELL_WIDTH        50
#define BOARD_BASE_COORD_X      10
#define BOARD_BASE_COORD_Y      130
#define BOARD_ANIMATION_TIME    0.06f
// Temp Value Factor
#define TEMP_VALUE_FACTOR       300

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

//@synthesize cells;
@synthesize boardCells;

#pragma mark - Initialization
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
    self.boardCells=[[NSMutableArray alloc]init];

    self.blankSpaceCreated=NO;
    for (int rowIndex=0; rowIndex<BOARD_ROWS; rowIndex++) {
        for (int columnIndex=0; columnIndex<BOARD_COLUMNS; columnIndex++) {
            [self createBoardCellAtRow:rowIndex Column:columnIndex];
        }
    }
    
//    // Update board cell object array with the "real" X,Y cooirdinates (they depend on screen resolution & device)
//    [self updateBoardCellCoordinates];
    
    // debugging my object array - viewing my stored objects (board's cells)
    for (Cell *cell in self.boardCells) {
        NSLog(@"(init) CELL  location=%@       content=%@       x=%f  y=%f",cell.location,cell.locationContent,cell.locationCoordinate.x,cell.locationCoordinate.y);
    }

//    for (UIView *subView in self.view.subviews) {
//        NSLog(@"=====VIEW  tag=%d  ...   x=%f  y=%f",subView.tag,subView.center.x,subView.center.y);
//    }


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
        
        blankRow=blankSpacePositionNumber/10;
        blankColumn=blankSpacePositionNumber-(blankRow*10);
        
        NSLog(@"generated blank Row & Column  ----> row=%d  column=%d",self.blankRow,self.blankColumn);
    }
    
    
    if (blankRow==rowIndex && blankColumn==columnIndex) {
        Cell *cell=[[Cell alloc]initWithLocation:location coordinate:CGPointMake(coordinateX, coordinateY) content:@"9999"];
        [self.boardCells addObject:cell];
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
            // board's cell object
            Cell *cell=[[Cell alloc]initWithLocation:location coordinate:CGPointMake(coordinateX, coordinateY) content:location];
            [self.boardCells addObject:cell];
        }
        
        img.tag=numericLocation;
        [self.view addSubview:img];
    }
}

//-(void)updateBoardCellCoordinates
//{
//    //Get only valid tags of the view
//    for (UIView *subview in self.view.subviews) {
//        int locationIndex=[self locationIndex:[NSString stringWithFormat:@"%d",subview.tag]];
//
//        // Set a valid range to update (there are more views than the board cells)
//        if ([self isValidTag:subview.tag]) {
//            NSLog(@"subview.tag=%d  locationIndex=%d",subview.tag,locationIndex);
//            int locationIndex=[self locationIndex:[NSString stringWithFormat:@"%d",subview.tag]];
//            Cell *cell=[self.boardCells objectAtIndex:locationIndex];
//            cell.locationCoordinate=subview.center;
//            [self.boardCells replaceObjectAtIndex:locationIndex withObject:cell];
//        }
//
//    }
//}




#pragma mark - UI Actions
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
    int sourceLocation=(moveToRowLocation*10)+moveToColumnLocation;
    int targetLocation=(self.blankRow*10)+self.blankColumn;

    // Animate board cells
    NSLog(@"WILL animate from location (sourceLocation):%d   rowSeed=%d  columnSeed=%d",sourceLocation,rowSeed,columnSeed);
    NSLog(@"WILL animate to location (targetLocation):%d",targetLocation);
    
    [self boardAnimationFromLocation:sourceLocation toLocation:targetLocation rowSeed:rowSeed columnSeed:columnSeed];
    
    // Update references //
    [self updateContentsAtSourceLocation:sourceLocation targetLocation:targetLocation];


    for (Cell *cell in self.boardCells) {
        NSLog(@"AFTER ANIMATION - location=%@     content=%@    x=%f y=%f",cell.location,cell.locationContent,cell.locationCoordinate.x,cell.locationCoordinate.y);
    }
    
    
    self.blankRow=moveToRowLocation;
    self.blankColumn=moveToColumnLocation;
    
    NSLog(@"blank=====>  row=%d column=%d",self.blankRow,self.blankColumn);


}

#pragma mark - Working Methods
-(int)blankSpaceLocation
{
    int blankLocation=0;
    // determine Blank Space Location
    for (Cell *cell in self.boardCells) {
        if ([cell.locationContent isEqualToString:@"9999"]) {
            blankLocation=[cell.location intValue];
        }
    }
    return blankLocation;
}

-(int)locationIndex:(NSString *)location
{
    int index=-1;
    for (int i=0; i<self.boardCells.count; i++) {
        Cell *cell=[self.boardCells objectAtIndex:i];
        if ([cell.location isEqualToString:location]) {
            index=i;
        }
    }
    return index;
}

-(int)contentIndex:(NSString *)content
{
    int index=-1;
    for (int i=0; i<self.boardCells.count; i++) {
        Cell *cell=[self.boardCells objectAtIndex:i];
        if ([cell.locationContent isEqualToString:content]) {
            index=i;
        }
    }
    return index;
}

// board animation
-(void)boardAnimationFromLocation:(int)sourceLocation toLocation:(int)targetLocation rowSeed:(int)rowSeed columnSeed:(int)columnSeed
{
    // SOURCE
    int locationIndex=[self locationIndex:[NSString stringWithFormat:@"%d",sourceLocation]];
    
    Cell *sourceCell=[self.boardCells objectAtIndex:locationIndex];
    int contentTag=[sourceCell.locationContent intValue];
    
    
//    // TARGET
//    int targetIndex=[self locationIndex:[NSString stringWithFormat:@"%d",targetLocation]];
//    Cell *targetCell=[self.boardCells objectAtIndex:targetIndex];
    
    [UIView animateWithDuration:BOARD_ANIMATION_TIME animations:^(void)
     // Aqui se faz a animacao
     {
         for (UIView *subview in self.view.subviews)
         {
             if (subview.tag==contentTag) {
                 subview.center=CGPointMake(subview.center.x+rowSeed, subview.center.y+columnSeed);
             }
         }
         
     } completion:^(BOOL finished)
     //  Aqui executamos os procedimentos logo apos o termino da animacao
     {
     }];
    // FIM DA ANIMACAO
    [UIView commitAnimations];

}

-(BOOL)isValidTag:(int)tag
{
    for (int i=0; i<[self.blankCandidates count]; i++) {
        if ([[self.blankCandidates objectAtIndex:i]intValue]==tag) {
            return YES;
        }
    }
    return NO;
}

-(void)updateContentsAtSourceLocation:(int)sourceLocation targetLocation:(int)targetLocation
{
    NSLog(@"############# UPDATE REFERENCES ########### source:%d  target=%d",sourceLocation,targetLocation);
    int sourceIndex=[self locationIndex:[NSString stringWithFormat:@"%d",sourceLocation]];
    Cell *sourceCell=[self.boardCells objectAtIndex:sourceIndex];
    NSString *sourceContent=sourceCell.locationContent;
    // override source content
    sourceCell.locationContent=@"9999";
    // update array of objects
    [self.boardCells replaceObjectAtIndex:sourceIndex withObject:sourceCell];

    

    int targetIndex=[self locationIndex:[NSString stringWithFormat:@"%d",targetLocation]];
    Cell *targetCell=[self.boardCells objectAtIndex:targetIndex];
//    NSString *targetContent=targetCell.locationContent;
    // override target content
    targetCell.locationContent=sourceContent;
    // update array of objects
    [self.boardCells replaceObjectAtIndex:targetIndex withObject:targetCell];
    
    

    
    

}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
