//
//  FirstViewController.h
//  FrontEnd
//
//  Created by Diekai Zeng on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kFilename    @"data.sqlite3"
@interface FirstViewController : UIViewController
<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {//注册自身为UI的Delegate，相当于函数指针
    UIImagePickerController* imgPickerCtrller;//用来进入图片库
    IBOutlet UIImageView* imgView;//让用户点击以选取图片，并显示选择的图片
}

- (IBAction)grabURL:(id)sender;
- (IBAction)Resize:(id)sender;
- (IBAction)Originalsize:(id)sender;
- (IBAction)insertImageToDB:(id)sender;
- (IBAction)readDBImage:(id)sender;
- (IBAction)Opendatabase:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)showInBrowser:(id)sender;

@property (nonatomic,retain) UIImagePickerController *imgPickerCtrller;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;



@end