# ESPopupMenu

[![CI Status](https://img.shields.io/travis/ElegantSolution/ESPopupMenu.svg?style=flat)](https://travis-ci.org/ElegantSolution/ESPopupMenu)
[![Version](https://img.shields.io/cocoapods/v/ESPopupMenu.svg?style=flat)](https://cocoapods.org/pods/ESPopupMenu)
[![License](https://img.shields.io/cocoapods/l/ESPopupMenu.svg?style=flat)](https://cocoapods.org/pods/ESPopupMenu)
[![Platform](https://img.shields.io/cocoapods/p/ESPopupMenu.svg?style=flat)](https://cocoapods.org/pods/ESPopupMenu)

## Description
An esay-to-use popup menu for iOS that automatically calculates the frames and the arrow position according to the UI Component that pops it.

<img width="171" alt="1" src="https://user-images.githubusercontent.com/69380955/89711973-469f1380-d9c0-11ea-8f0e-6f4bbf64508f.png">     <img width="170" alt="2" src="https://user-images.githubusercontent.com/69380955/89711974-4868d700-d9c0-11ea-9011-32d929c3f608.png">    <img width="171" alt="3" src="https://user-images.githubusercontent.com/69380955/89711975-49016d80-d9c0-11ea-8645-f2009b32aa44.png">

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ESPopupMenu is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ESPopupMenu', '~> 0.1.1'
```

## Usage

```objective-c

/// This will automatically pop a menu with an arrow pointed to the view.
/// @param view:  Any UI component that has a view of frame that can be used to calculate the menu's frame and arrow
/// @param delegate: ESPopupMenuDelegate, should not be nil
/// @param numOfRows: number of rows to show in menu
/// @param rowWidth: row's width
/// @param rowHeight: SINGLE row's height, NOT the height of entire menu
[ESPopupMenu addPopupMenuTo:view delegate:self numOfRows:3 rowWidth:120 rowHeight:40];
```
### Delegate

```objective-c

/// Return the title for each row in the menu here
/// @param row: the number of row for title
- (nonnull NSString *)rowTitleFor:(NSInteger)row {
    
    return self.menuTitles[row];
}

/// Handle event when user tapped the menu
/// @param row: the number of row that has been tapped
- (void)userDidTapMenu:(NSInteger)row {
    
    MyViewController* vc = [[MyViewController alloc] initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}
```
### Optional Delegate

```objetive-c

/// Return the icon image for each row in the menu here
/// @param row: the number of row for image
- (UIImage *)imageFor:(NSInteger)row{
    
    return self.menuImages[row];
}

/// Return title text font size
/// @param row: the number of row for font size
-(CGFloat) titleFontSizeFor:(NSInteger) row{

    return 12;
}
```

## Author

Yue Zhao @ElegantSolution, eesoto@foxmail.com

## License

ESPopupMenu is available under the MIT license. See the LICENSE file for more info.
