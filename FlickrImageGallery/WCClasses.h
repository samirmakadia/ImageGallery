//
//  WCClasses.h
//  FlickrImageGallery
//
//  Created by ABC on 7/18/17.
//  Copyright © 2017 Creative Infoway. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^myComplete)(NSArray *);
typedef void(^fail)(NSError *);

@interface WCClasses : NSObject


+(void)loadFeedByTag:(NSString *)tag complete:(myComplete)block fail:(fail)failBlock;
@end
