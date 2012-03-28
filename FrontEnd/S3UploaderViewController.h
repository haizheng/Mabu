//
//  S3UploaderViewController.h
//  FrontEnd
//
//  Created by Diekai Zeng on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3UploaderViewController:UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
}

-(IBAction)selectPhoto:(id)sender;
-(IBAction)showInBrowser:(id)sender;

@end
