//
//  OADAdapter.h
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class OpenAdAdapter;

@interface OADAdapter : NSObject


-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1;
-(BOOL)available;
-(BOOL)verify;
-(void)tick;
-(void)showTopBanner:(UIViewController *)rootViewController;
-(void)showBottomBanner:(UIViewController *)rootViewController;
-(void)hideBanner;
-(BOOL)isBannerShown;
-(BOOL)isBannerFailed;

-(BOOL)showFullscreen:(UIViewController *)rootViewController;
-(BOOL)showVideo:(UIViewController *)rootViewController;
-(BOOL)showRewarded:(UIViewController *)rootViewController;
-(void)controller:(UIViewController *)rootViewController;
-(NSString*)name;
-(float)heightPts;

@end
