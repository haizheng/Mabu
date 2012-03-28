//
//  Constants.h
//  FrontEnd
//
//  Created by Diekai Zeng on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants used to represent your AWS Credentials.
#define ACCESS_KEY_ID          @"AKIAIFHFKVFSHVC6H3BQ"
#define SECRET_KEY             @"8TyVS1F1CeF1G3cANN45O0HxaIfOn9MKfkNToCwm"


// Constants for the Bucket and Object name.
#define PICTURE_BUCKET         @"tianhu-media"
#define PICTURE_NAME           @"NameOfThePicture.jpg"


#define CREDENTIALS_MESSAGE    @"AWS Credentials not configured correctly.  Please review the README file."


@interface Constants:NSObject {
}

/**
 * Utility method to create a bucket name using the Access Key Id.  This will help ensure uniqueness.
 */
+(NSString *)pictureBucket;


/**
 * Utility method to display an alert message.  Used to communicate errors and failures.
 */
+(void)showAlertMessage:(NSString *)message withTitle:(NSString *)title;



+(UIAlertView *)credentialsAlert;


@end
