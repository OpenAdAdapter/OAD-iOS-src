//
//  OpenAdAdapter.h
//  OpenAdAdapter
//
//  Created by Artem Babenko on 5/25/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class OADAdapter;


@interface OADReward : NSObject
-(id)initWithNetwork:(NSString*)network amount:(float)amount currency:(NSString*) currency;
-(NSString*)network;
-(float)amount;
-(NSString*)currency;
@end

@interface OpenAdAdapter : NSObject
+(void)startWithUrl:(NSString*)u;
+(void)test1;
+(void)test2:(UIViewController *)rootViewController;
+(void)test3:(UIViewController *)rootViewController;
+(BOOL)verifyFramework:(NSString*)s1;
+(OADAdapter*)adapter:(NSString*)s1;
+(void)showTopBanner:(UIViewController *)controller;
+(void)showBottomBanner:(UIViewController *)controller;
+(void)hideBanner;
+(void)showFullscreen:(UIViewController *)controller;
+(void)showVideo:(UIViewController *)controller;
+(void)showRewarded:(UIViewController *)controller;
+(BOOL)hasReward;
+(OADReward*)reward;
-(void)addReward:(OADReward*)reward;
+(float)bannerHeightPts;
+(float)bannerHeightPixels;
@end
