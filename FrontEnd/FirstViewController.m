//
//  FirstViewController.m
//  Demo1
//
//  Created by Diekai Zeng on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "FirstViewController.h"
#import <sqlite3.h> 
#import "SecondViewController.h"
#import "Constants.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "ASIHTTPRequest.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize imgPickerCtrller;//保证了imgPickerCtrller的实施
@synthesize imageView;
@synthesize questionField;
@synthesize labelA;
@synthesize labelB;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (NSString *)dataFilePath {//获取数据库路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ( [ACCESS_KEY_ID isEqualToString:@"CHANGE ME"]) 
    {
        [[Constants credentialsAlert] show];
    }
    imageView.frame = CGRectMake(0, 0, 320, 460);//图片覆盖整个画面
    if (imgPickerCtrller==nil) {//判断是否已经初始化imgPickerCtrller
        UIImagePickerController* aImgPickerCtrller = [[UIImagePickerController alloc] init];//初始化一个UIImagePickerController
        imgPickerCtrller = aImgPickerCtrller;//将初始完的实例指定为imgPickerCtrller
        imgPickerCtrller.delegate = self;//设置delegate
        imgPickerCtrller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//指定源为Photo Library
    }	
}

- (void)viewDidUnload
{
    imgView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {//处理触屏函数
    UITouch *touch = [touches anyObject];
    CGPoint coord = [touch locationInView:self.view];//获取当前触摸的中心坐标    
    if (CGRectContainsPoint(imgView.frame, coord)) {//系统函数，判断触摸中心是否在imgView内
        [self presentModalViewController:self.imgPickerCtrller animated:YES];
    }
}

//static NSString *image_name;//图片名字


- (IBAction)textFieldDoneEditing:(id)sender
{
  //  NSLog(@"%d",questionField.text.length);
    [questionField resignFirstResponder];
}

- (IBAction)takepicture:(id)sender 
{/*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.mediaTypes = temp_MediaTypes;
        picker.delegate = self;
      //  picker.allowsImageEditing = YES;    
    }
    [self presentModalViewController:picker animated:YES];
    [picker release];
    */
}

-(IBAction)selectPhoto:(id)sender
{
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
}

static NSString *photourl = nil;
-(IBAction)showInBrowser:(id)sender
{
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
        // Set the content type so that the browser will treat the URL as an image.
        S3ResponseHeaderOverrides *override = [[[S3ResponseHeaderOverrides alloc] init] autorelease];
        override.contentType = @"image/jpeg";
        
        // Request a pre-signed URL to picture that has been uplaoded.
        S3GetPreSignedURLRequest *gpsur = [[[S3GetPreSignedURLRequest alloc] init] autorelease];
        gpsur.key                     = PICTURE_NAME;
        gpsur.bucket                  = [Constants pictureBucket];
        gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600]; // Added an hour's worth of seconds to the current time.
        gpsur.responseHeaderOverrides = override;
        
        // Get the URL
        NSURL *url = [s3 getPreSignedURL:gpsur];
        NSString *urlString = [url absoluteString];//类型转换
        photourl = urlString;
        NSLog(@"photourl = %@",photourl);
        // Display the URL in Safari
   //     [[UIApplication sharedApplication] openURL:url];
    }
    @catch (AmazonClientException *exception) {
        [Constants showAlertMessage:exception.message withTitle:@"Browser Error"];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Get the selected image.
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Convert the image to JPEG data.
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    // Initial the S3 Client.
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY] autorelease];
    
    @try {
        // Create the picture bucket.
        //[s3 createBucket:[[[S3CreateBucketRequest alloc] initWithName:[Constants pictureBucket]] autorelease]];
        
        // Upload image data.  Remember to set the content type.
        S3PutObjectRequest *por = [[[S3PutObjectRequest alloc] initWithKey:PICTURE_NAME inBucket:[Constants pictureBucket]] autorelease];
        por.contentType = @"image/jpeg";
        por.data        = imageData;
        
        // Put the image data into the specified s3 bucket and object.
        [s3 putObject:por];
    }
    @catch (AmazonClientException *exception) {
        [Constants showAlertMessage:exception.message withTitle:@"Upload Error"];
    }
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (IBAction)Resize:(id)sender
{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    imageView.frame = CGRectMake(80, 40, 160, 230);
    [UIView commitAnimations];
}

- (IBAction)Originalsize:(id)sender 
{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1.0];
    imageView.frame = CGRectMake(0, 0, 320, 460);
    [UIView commitAnimations];
}

- (void)dealloc
{
    [imgPickerCtrller release];//保证了imgPickerCtrller的释放
    [imageView release];
    [questionField release];
    [labelA release];
    [labelB release];
    [super dealloc];
}

- (IBAction)grabURL:(id)sender//同步请求
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) 
    {
        NSString *response = [request responseString];
        NSLog(@"response = %@",response);
    }
}

NSData * UIImageJPEGRepresentation (//图片数据转化为NSData
    UIImage *image,
    CGFloat compressionQuality
);


- (IBAction)Opendatabase:(id)sender 
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) //打开数据库,路径/数据库句柄
    {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");//类似NSLog
    }
    NSLog(@"open database success!");    //打开数据库 
	
    char *errorMsg;
    //  NSString *createSQL = @"CREATE TABLE IF NOT EXISTS channel2 (id integer primary key, cid text, title text, imageData BLOB, imageLen integer, imageWeight integer);";
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS Front (image_ID integer primary key, timestamp text, text text, photourl text, answered text);";
    
    if (sqlite3_exec (database, [createSQL UTF8String],NULL, NULL, &errorMsg) != SQLITE_OK)//1打开数据库句柄,2SQL语句,34待定,5错误信息
    {
        sqlite3_close(database);
        NSAssert1(0, @"Error creating table: %s", errorMsg);
    }
    sqlite3_free(errorMsg);
    NSLog(@"hello1");
    
    //  NSString *query = @"SELECT id, cid, title, imageData, imageLen,imageWeight FROM channel2 ORDER BY id";
    NSString *query = @"SELECT * FROM Front ORDER BY image_ID;";
    sqlite3_stmt *statement;
    NSLog(@"hello2");
    int sss = sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil);//1打开数据库句柄,2SQL语句,3语句长度,负数为第二参数完整长度,4返回结构体信息,5指向前语句结束位置
    NSLog(@"sss=%i",sss);
    if (sqlite3_prepare_v2(database, [query UTF8String],-1, &statement, nil) == SQLITE_OK) 
    {
        NSLog(@"hello3");
        NSLog(@"DONE=%i",SQLITE_DONE);
        int success = sqlite3_step(statement);
        NSLog(@"success=%i",success);
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:CREATE TABLE IMAGE");
            return ;
        }
        sqlite3_finalize(statement);
        NSLog(@"Create table 'Front' successed.");
        sqlite3_close(database);
    }    //建表成功 
}

int ID = 1;

- (IBAction)Submit:(id)sender //发送图片信息到数据库
{
    NSString *lString =questionField.text;
    if (questionField.text.length == 0)
    {
        NSString *msg = nil;
        msg = [[NSString alloc] initWithFormat:@"please provide a text description!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something was error" message:msg delegate:self cancelButtonTitle:@"Yes!" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [msg release];
        return;
    }
    //弹出模块
    
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK) 
    {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    NSLog(@"open database success!");   
    //打开数据库
    
    NSDateFormatter *formatter =[[[NSDateFormatter alloc] init] autorelease];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *str=[formatter stringFromDate:date]; 
    NSLog(@"date = %@",str);        
    //日期    
    
 /* UIImageView *im = [[UIImageView alloc] init];
    im.image = [UIImage imageNamed:@"image_name"];
    NSLog(@"image.size :%f,%f",[im image].size.width,[im image].size.height) ;    
    //图片宽高
    //  NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"image_name"]);
    //  NSUInteger length = [data length];//这个法参数用来计算data数据的大小的
    int aaa = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL);
    NSLog(@"aaa=%i",aaa);
    NSLog(@"SQLITE_OK=%i",SQLITE_OK);*/
    
    sqlite3_stmt *statement;  
    NSString *query = @"INSERT INTO Front(timestamp,text,photourl,answered) VALUES (?,?,?,?);";
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL)!=SQLITE_OK)
    {
        NSLog(@"I have read an error");
        return;
    }
    //插入数据
    NSString *answered = nil;
    //回答模块
    NSLog(@"photourl = %@",photourl);
    
    //绑定数据并插入数据
    sqlite3_bind_text(statement, 1, [str UTF8String], -1, SQLITE_TRANSIENT);//这里对应query里的问号，第几个问号，里面的参数就填几
    sqlite3_bind_text(statement, 2, [lString UTF8String], -1, SQLITE_TRANSIENT);  
    sqlite3_bind_text(statement, 3, [photourl UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [answered UTF8String], -1, SQLITE_TRANSIENT);
    
    NSLog(@"insert success!");
    ++ID;
    sqlite3_step(statement);
    sqlite3_finalize(statement);
     
    char *labelstr1 = "SELECT COUNT(*) FROM Front;";
    if (sqlite3_prepare_v2(database, labelstr1 , -1, &statement, NULL) != SQLITE_OK) 
    {
        NSLog(@"Error: failed to prepare statement with message:read DB.");
    }
    while (sqlite3_step(statement) == SQLITE_ROW) 
    {
        int result =  sqlite3_column_int(statement, 0);
        labelA.text = [[NSString alloc]initWithFormat:@"%d",result];
    }//显示所有问题数
    
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    char *labelstr2 = "SELECT COUNT(*) FROM Front where answered not null;";
    if (sqlite3_prepare_v2(database, labelstr2 , -1, &statement, NULL) != SQLITE_OK) 
    {
        NSLog(@"Error: failed to prepare statement with message:read DB.");
    }
    while (sqlite3_step(statement) == SQLITE_ROW) 
    {
        int result =  sqlite3_column_int(statement, 0);
        labelB.text = [[NSString alloc]initWithFormat:@"%d",result];
    }//显示已回答问题数
    
    //显示查询信息
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    sqlite3_close(database);
    //插入数据成功
    
    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
    [viewController2.view reloadInputViews];
}

-(IBAction)readDBImage:(id)sender
{
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    NSLog(@"open database success!"); 
    
    sqlite3_stmt *statement = nil;
    char *sql = "SELECT * FROM Front;";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) 
    {
        NSLog(@"Error: failed to prepare statement with message:read IMAGEDB.");
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW) 
    {
        int ID2 =  sqlite3_column_int(statement, 0);
        const unsigned char *str = sqlite3_column_text(statement, 1);
        const unsigned char *lString = sqlite3_column_text(statement, 2);
        const unsigned char *photourl1 = sqlite3_column_text(statement, 3);
        const unsigned char *answered = sqlite3_column_text(statement, 4);
        
        NSLog(@"read data success!");
        NSLog(@"image_ID=%i",ID2);
        NSLog(@"timestamp = %s",str);  
        NSLog(@"question = %s",lString);
        NSLog(@"photourl = %s",photourl1);
        NSLog(@"answered = %s",answered);
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
}
@end