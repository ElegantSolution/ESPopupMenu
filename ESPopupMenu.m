//Copyright (c) 2020 Yue Zhao @ElegantSolution <eesoto@foxmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

#import "ESPopupMenu.h"

#define OFFSET 10.0
#define PADDING 8.0
#define CORNERRADIUS 5.0
#define ARROWHEIGHT 5.0
#define ARROWHALFSIDE sqrt( ARROWHEIGHT * ARROWHEIGHT / 3.)
#define BACKGROUNDCOLOR [UIColor colorWithRed:67./255. green:67./255. blue:67./255. alpha:0.95]
#define WINDOW [[[UIApplication sharedApplication] windows] lastObject]
#define IMAGEHEIGHTRATIO 0.8

@interface ESPopupMenu()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<ESPopupMenuDelegate> delegate;
@property (nonatomic, weak) UIView* aView;
@property (nonatomic, assign) NSInteger numOfRow;
@property (nonatomic, assign) CGFloat rowWidth;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) BOOL growDown;
@property (nonatomic, strong) CAShapeLayer* arrowLayer;
@property (nonatomic, strong) UIView* background;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation ESPopupMenu

-(instancetype)initWithView:(UIView*)view delegate:(id<ESPopupMenuDelegate>)delegate numOfRows:(NSInteger)numOfRows rowWidth:(CGFloat)rowWidth rowHeight:(CGFloat)rowHeight{
    
    if (self = [super initWithFrame:CGRectZero]){
        
        self.aView = view;
        self.numOfRow = numOfRows;
        self.rowWidth = rowWidth;
        self.rowHeight = rowHeight;
        self.delegate = delegate;
        
        [self setMenuAppearance];
        
        [self setupTableView];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc{
    
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

+(void)addPopupMenuTo:(id)view delegate:(id<ESPopupMenuDelegate>)delegate numOfRows:(NSInteger)numOfRows rowWidth:(CGFloat)rowWidth rowHeight:(CGFloat)rowHeight{
    
    UIView* aView;
    
    if (![view isKindOfClass:[UIView class]]){
           
        if (!(aView = [view performSelector:@selector(view)])){
            
            Class class = [view class];
            NSLog(@"Create ESPopupMenu Failed: %@ is Not or Does Not Have a View.", class);
            return;
        }
    }
    else {
        aView = (UIView *)view;
    }
    
    ESPopupMenu* popmenu = [[ESPopupMenu alloc] initWithView:aView delegate:delegate numOfRows:numOfRows rowWidth:rowWidth rowHeight:rowHeight];
    
    [popmenu show];
}

-(void)setMenuAppearance{
    
    [self setMenuFrame];
    self.backgroundColor = BACKGROUNDCOLOR;
    self.layer.cornerRadius = CORNERRADIUS;
    [self addArrow];
}

-(void)setMenuFrame{
    
    CGRect viewFrame = [self.aView convertRect:self.aView.bounds toView:nil];
    CGFloat width = self.rowWidth;
    CGFloat height = self.numOfRow * self.rowHeight;
    CGRect windowBounds = WINDOW.screen.bounds;
    
    CGFloat x = [self getMenuOriginX:windowBounds viewFrame:viewFrame width:width];
    CGFloat y = [self getMenuOriginY:windowBounds viewFrame:viewFrame height:height];
    
    CGRect frame = CGRectMake(x, y, width, height);
    
    [self setFrame:frame];
}

-(CGFloat)getMenuOriginX:(CGRect) windowBounds viewFrame:(CGRect) viewFrame width:(CGFloat)width{
    
    CGFloat x;
    
    CGFloat windowWidth = windowBounds.origin.x + windowBounds.size.width;
    CGFloat menuHalfWidth = width/2.;
    CGFloat viewMidpoint = (viewFrame.origin.x * 2. + viewFrame.size.width) / 2.;
    CGFloat viewRightSpace = windowWidth - viewMidpoint;
    
    if (viewMidpoint < menuHalfWidth) {
        
        x = PADDING;
    }
    else if ( viewRightSpace < menuHalfWidth){
        
        x = windowWidth - ( width + PADDING );
    }
    else {
        
        x = viewMidpoint - menuHalfWidth;
    }
    
    return x;
}

-(CGFloat)getMenuOriginY:(CGRect) windowBounds viewFrame:(CGRect) viewFrame height:(CGFloat) height{
    
    CGFloat y;
    
    CGFloat viewHeight = viewFrame.size.height;
    CGFloat upperSpace = viewFrame.origin.y;
    CGFloat lowerSpace = windowBounds.size.height - (upperSpace + viewHeight);
    
    if (lowerSpace >= upperSpace){
        
        self.growDown = YES;
    }
    else {
       
        self.growDown = NO;
    }
    
    if (self.growDown){
       
        y = upperSpace + viewHeight + OFFSET;
    }
    else {
        
        y = upperSpace - OFFSET - height;
    }
    
    return y;
}

-(CGFloat)getArrowOriginX{
    
    CGFloat x;
    
    CGRect viewFrame = [self.aView convertRect:self.aView.bounds toView:nil];
    CGRect menuFrame = self.frame;
    
    CGFloat possibleX = (viewFrame.origin.x * 2. + viewFrame.size.width)/2. - ARROWHALFSIDE;
    CGFloat leftBound = menuFrame.origin.x + CORNERRADIUS;
    CGFloat rightBound = menuFrame.origin.x + menuFrame.size.width - CORNERRADIUS - ARROWHALFSIDE * 2.;
    
    if (possibleX < leftBound){
        
        x = leftBound;
    }
    else if (possibleX > rightBound){
        
        x = rightBound;
    }
    else {
        
        x = possibleX;
    }
    
    CGFloat arrowX = x - menuFrame.origin.x;
    return arrowX;
}

-(void)addArrow{
    
    CGFloat x = [self getArrowOriginX];
    
    CGPoint start;
    CGPoint arrowTip;
    CGPoint end;
    
    CGRect bounds = self.bounds;
    
    if (self.growDown){
        
        start = CGPointMake(x, bounds.origin.y);
        
        arrowTip = CGPointMake(start.x + ARROWHALFSIDE, start.y - ARROWHEIGHT);
        
        end = CGPointMake(arrowTip.x + ARROWHALFSIDE, arrowTip.y + ARROWHEIGHT);
    }
    else {
        
        start = CGPointMake(x, bounds.origin.y + bounds.size.height);
        
        arrowTip = CGPointMake(start.x + ARROWHALFSIDE, start.y + ARROWHEIGHT);
        
        end = CGPointMake(arrowTip.x + ARROWHALFSIDE, arrowTip.y - ARROWHEIGHT);
    }
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    [path moveToPoint:start];
    [path addLineToPoint:arrowTip];
    [path addLineToPoint:end];
    
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = [path CGPath];
    [layer setFillColor: [BACKGROUNDCOLOR CGColor]];
    
    [self.layer addSublayer:layer];
    self.arrowLayer = layer;
}

-(void)show{
    
    [self setBackground];
    
    [WINDOW addSubview:self];
}


-(void)setBackground{
    
    self.background = [[UIView alloc] initWithFrame: CGRectZero];
    
    self.background.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.background setBackgroundColor:UIColor.clearColor];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    
    [self.background addGestureRecognizer:tap];
    
    [WINDOW addSubview:self.background];
    
    [self setBackgroundViewConstraint];
}

-(void)setBackgroundViewConstraint{
    
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:WINDOW attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:WINDOW attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:WINDOW attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:self.background attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:WINDOW attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    [NSLayoutConstraint activateConstraints:@[centerX, centerY, width, height]];
}

-(void)tapped:(UITapGestureRecognizer *)sender{
    
    [sender removeTarget:nil action:NULL];
    [self dismiss];
}

-(void)dismiss{
    
    [self.background removeFromSuperview];
    [self removeFromSuperview];
}

-(void)orientationDidChange:(NSNotification*)noti{
    
    [self.arrowLayer removeFromSuperlayer];
    [self setMenuAppearance];
}

-(void)setupTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.layer.cornerRadius = CORNERRADIUS;
    self.tableView.rowHeight = self.rowHeight;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.tableView];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.numOfRow;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [self configCell: indexPath.row];
    
    return cell;
}

-(UITableViewCell*)configCell:(NSInteger) row{
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.backgroundColor = UIColor.clearColor;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.textColor = UIColor.whiteColor;
   
    if ([self.delegate respondsToSelector:@selector(rowTitleFor:)]){
    
        cell.textLabel.text = [self.delegate rowTitleFor:row];
    }
    else {
     
        NSLog(@"ESPopupMenu: Delegate Mandatory Method (rowTitleFor:) Not Implemented");
    }
    
    if ([self.delegate respondsToSelector:@selector(titleFontSizeFor:)]){
        
        CGFloat fontSize = [self.delegate titleFontSizeFor:row];
        
        if (fontSize){
            
            UIFont* font = [cell.textLabel.font fontWithSize:fontSize];
            cell.textLabel.font = font;
            
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(imageFor:)]){
    
        UIImage* image = [self.delegate imageFor:row];
        
        if (image) {
            
            cell.imageView.image = [self scaleImage:image];
        }
    }
 
    return cell;
}

-(UIImage*)scaleImage:(UIImage*)image{
    
    CGFloat ratio = image.size.width / image.size.height;
    CGFloat height = self.rowHeight * IMAGEHEIGHTRATIO;
    CGFloat width = height * ratio;
    
    CGSize size = CGSizeMake(width, height);
   
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(rowTitleFor:)]){
    
        [self.delegate userDidTapMenu:indexPath.row];
    }
    else {
     
        NSLog(@"ESPopupMenu: Delegate Mandatory Method (userDidTapMenu:) Not Implemented");
    }
    
    [self dismiss];
}

@end
