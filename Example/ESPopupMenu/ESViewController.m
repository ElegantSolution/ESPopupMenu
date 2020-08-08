//
//  ESViewController.m
//  ESPopupMenu
//
//  Created by ElegantSolution on 08/08/2020.
//  Copyright (c) 2020 ElegantSolution. All rights reserved.
//

#import "ESViewController.h"
#import "HelloWorldViewController.h"
#import "ESPopupMenu.h"

@interface ESViewController ()<ESPopupMenuDelegate>

@property (nonatomic, strong) NSArray* menuTitles;
@property (nonatomic, strong) NSArray* menuImages;

- (IBAction)bottomBtnTapped:(id)sender;

@end

@implementation ESViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuTitles = @[@"Scan", @"Email", @"Chat"];
    
    self.menuImages = @[[UIImage imageNamed:@"Scan"], [UIImage imageNamed:@"Email"], [UIImage imageNamed:@"Chat"]];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu:)];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showMenu:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)showMenu:(id)sender{
    
    [ESPopupMenu addPopupMenuTo:sender delegate:self numOfRows:3 rowWidth:120 rowHeight:40];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (nonnull NSString *)rowTitleFor:(NSInteger)row {

    return self.menuTitles[row];
}

- (void)userDidTapMenu:(NSInteger)row {

    HelloWorldViewController* helloVC = [[HelloWorldViewController alloc] initWithNibName:nil bundle:nil];

    [self.navigationController pushViewController:helloVC animated:YES];
}

- (UIImage *)imageFor:(NSInteger)row{
    
    return self.menuImages[row];
}

- (IBAction)bottomBtnTapped:(id)sender {
    [self showMenu:sender];
}

@end
