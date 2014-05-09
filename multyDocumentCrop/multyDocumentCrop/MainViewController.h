//
//  MainViewController.h
//  multyDocumentCrop
//
//  Created by Daniele Ceglia on 09/05/14.
//  Copyright (c) 2014 Relifeit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAImagePickerController.h"

@interface MainViewController : UIViewController <MAImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *anteprima;

- (IBAction)iniziaTest:(id)sender;

@end
