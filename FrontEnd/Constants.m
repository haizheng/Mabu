//
//  Constants.m
//  FrontEnd
//
//  Created by Diekai Zeng on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

#import "Constants.h"

@implementation Constants


+(NSString *)pictureBucket
{
    return [[NSString stringWithFormat:@"%@", PICTURE_BUCKET] lowercaseString];
}

+(void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    [[[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
}

+(UIAlertView *)credentialsAlert
{
    return [[[UIAlertView alloc] initWithTitle:@"Missing Credentials" message:CREDENTIALS_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
}

@end

