//
//  MainViewController.m
//  multyDocumentCrop
//
//  Created by Daniele Ceglia on 09/05/14.
//  Copyright (c) 2014 Relifeit. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action's methods

- (IBAction)iniziaTest:(id)sender
{
    NSLog(@"iniziaTest...");
}

@end
