//
//  SecondViewController.m
//  Demo1
//
//  Created by Diekai Zeng on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "SecondViewController.h"
#import <sqlite3.h> 

@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize listData;
@synthesize tv;

-(void)TReloadData{
    [self readDB];
    [self.tv reloadData];
}

- (NSString *)dataFilePath {//数据库路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        self.title = NSLocalizedString(@"Histroy", @"Histroy");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

-(void)readDB
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:nil];//初始化数组
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)!= SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    NSLog(@"open database success!"); 
    
    sqlite3_stmt *statement = nil;
    char *sql = "SELECT * FROM IMAGE1;";
    if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) 
    {
        NSLog(@"Error: failed to prepare statement with message:get IMAGEDB.");
    }
    while (sqlite3_step(statement) == SQLITE_ROW) 
    {
        int ID2 =  sqlite3_column_int(statement, 0);
        NSData* imageData = sqlite3_column_blob(statement, 1);
        const unsigned char *str=sqlite3_column_text(statement, 2);
        
        NSLog(@"image_ID=%i",ID2);
        NSLog(@"read data success!%@",imageData);
        
        [array addObject:[NSString stringWithFormat:@"image_%i \n date:%s", ID2,str]];
        // [array addObject:[NSString stringWithFormat:@"date:%s",str]];
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    
    self.listData = array;
    [array release];
    
}

- (void)viewDidLoad 
{
    [self readDB];
    [super viewDidLoad];
    tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];
    tv.dataSource =self;
    tv.delegate=self;
    [self.view addSubview:tv];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.listData = nil;
    [super viewDidUnload];
}


- (void)dealloc {
    [listData release];
    [tv release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.listData count];
}

//绘制方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";//静态字符串实例,保存各行数据
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];//可重用单元
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier] autorelease];
    }
	
    UIImage *image = [UIImage imageNamed:@"first@2x.png"];//图片
    cell.imageView.image = image;
    
    NSUInteger row = [indexPath row];//显示行
    cell.textLabel.text = [listData objectAtIndex:row];//从数组获取数据
    //	cell.textLabel.font = [UIFont boldSystemFontOfSize:20];//字体大小
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    cell.backgroundColor = [UIColor blueColor];
    cell.textLabel.textColor = [UIColor redColor];
    //  cell.textLabel.
	/*
     if (row < 7)
     cell.detailTextLabel.text = @"Mr. Disney";
     else
     cell.detailTextLabel.text = @"Mr. Tolkien";
     */
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 30;//行高
}

/*
 - (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath 
 {//设置缩进
 NSUInteger row = [indexPath row];
 return row;
 }
 */
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSUInteger row = [indexPath row];
    if (row == 0)
        return nil;
    return indexPath;//返回选中的行号
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
	
    NSString *message = [[NSString alloc] initWithFormat:@"You selected %@", rowValue];//提示语言
    UIAlertView *alert = [[UIAlertView alloc]//提示框
			initWithTitle:@"Row Selected!"
			message:message
			delegate:nil
			cancelButtonTitle:@"Yes I Did"
			otherButtonTitles:nil];
    [alert show];
    [message release];
    [alert release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
