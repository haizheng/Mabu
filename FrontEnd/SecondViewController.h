//
//  SecondViewController.h
//  FrontEnd
//
//  Created by Diekai Zeng on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#define kFilename    @"data.sqlite3"
#import <Foundation/Foundation.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *listData;
}

@property (nonatomic, retain) NSArray *listData;


@end
