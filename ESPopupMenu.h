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


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ESPopupMenuDelegate <NSObject>

/// Return the title for each row in the menu here
/// @param row The number of row for title
-(NSString*) rowTitleFor:(NSInteger) row;

/// Handle event when user tapped the menu
/// @param row The number of row that has been tapped
-(void) userDidTapMenu:(NSInteger) row;

@optional

/// Return the icon image for each row in the menu here
/// @param row  The number of row for image
-(nullable UIImage*) imageFor:(NSInteger) row;

/// Return title text font size
/// @param row The number of row for font size
-(CGFloat) titleFontSizeFor:(NSInteger) row;

@end

@interface ESPopupMenu : UIView

/// This will automatically pop a menu with an arrow pointed to the view.
/// @param view  Any UI component that has a view of frame that can be used to calculate the menu's frame and arrow
/// @param delegate ESPopupMenuDelegate, should not be nil
/// @param numOfRows Number of rows to show in menu
/// @param rowWidth Row's width
/// @param rowHeight SINGLE row's height, NOT the height of entire menu
+(void) addPopupMenuTo:(id) view delegate:(id<ESPopupMenuDelegate>) delegate numOfRows:(NSInteger) numOfRows rowWidth:(CGFloat) rowWidth rowHeight:(CGFloat) rowHeight;

@end

NS_ASSUME_NONNULL_END
