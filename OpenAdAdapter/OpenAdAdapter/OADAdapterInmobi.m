//
//  OADAdapterInmobi.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OpenAdAdapter.h"
#import "OADAdapterInmobi.h"

#import "IMBanner.h"
#import "IMBannerDelegate.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "IMIncentivisedDelegate.h"
#import "IMNative.h"
#import "IMNativeDelegate.h"
#import "IMError.h"
#import "InMobiAnalytics.h"




@implementation OADAdapterInmobi
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * propId;
    NSString * bannerId;
    NSString * banner320;
    NSString * fullscreenId;
    IMInterstitial *interstitial_;
    IMBanner * banner;
    UIViewController * rootViewController;
    UIViewController * bannerRootViewController;
    BOOL top, _showBanner, bannerShown, bannerFailed;
    CGFloat bannerHeight;
    BOOL gotFullscreen;
}

-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
    self->propId = [d1 objectForKey:@"propId"];
    self->bannerId = [d1 objectForKey:@"bannerId"];
    self->fullscreenId = [d1 objectForKey:@"fullscreenId"];
    
    
    [InMobi initialize:self->propId];
    [InMobi setLogLevel:IMLogLevelDebug];
    
    self->interstitial_ = [[IMInterstitial alloc] initWithAppId:fullscreenId];
    self->interstitial_.delegate = self;
    self->_showBanner = NO;
    
    
    [self preloadFullscreen];
    
}
-(void)preloadFullscreen{
    [self->interstitial_ loadInterstitial];
}
-(NSString*)name{
    return self->name;
}
-(void)showTopBanner:(UIViewController *)rootViewController1{
    self->top = YES;
    self->_showBanner = YES;
    self->bannerRootViewController = rootViewController1;
    self->bannerFailed = NO;
    self->bannerShown = NO;
    
    
}
-(void)showBottomBanner:(UIViewController *)rootViewController1{
    self->top = NO;
    self->_showBanner = YES;
    self->bannerRootViewController = rootViewController1;
    self->bannerFailed = NO;
    self->bannerShown = NO;
    
}
-(void)hideBanner{
    self->_showBanner = NO;
    if(self->banner){
        [self->banner removeFromSuperview];
        self->banner = nil;
    }
}
-(BOOL)isBannerShown{
    return self->bannerShown;
}
-(BOOL)isBannerFailed{
    return self->bannerFailed;
}
-(void)tick{
    [self moveBanner];
}
-(void)moveBanner{
    if(self->_showBanner){
        // show banner
        
        if(self->banner == nil){
            self->banner = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, 320, 50)
                                                     appId:self->bannerId
                                                    adSize:IM_UNIT_320x50];
            self->banner.delegate = self;
            [self->banner loadBanner];
            
            
  
            
            
            [self->bannerRootViewController.view addSubview:self->banner];
            
        }
        
        CGPoint bannerOrigin = self->banner.frame.origin;
        CGSize bannerSize = self->banner.frame.size;
        self->bannerHeight = bannerSize.height;
        //CGRect screenRect = [[UIScreen mainScreen] bounds];
        //CGRect appRect = [[UIScreen mainScreen] applicationFrame];
        CGRect viewRect = self->bannerRootViewController.view.bounds;
        CGPoint origin = CGPointMake(0,0);
        
        if(self->top){
            
        }else{
            // bottom
            origin.y = viewRect.size.height - self->bannerHeight;
        }
        
        CGFloat dx = bannerOrigin.x - origin.x;
        CGFloat dy = bannerOrigin.y - origin.y;
        CGFloat dist = sqrt(dx*dx+dy*dy);
        if(dist > 0.5){
            self->banner.frame = CGRectMake(origin.x, origin.y, bannerSize.width, bannerSize.height);
        }
        
        
    }else{
        // hide banner
        if(self->banner){
            [self->banner removeFromSuperview];
            self->banner = nil;
        }
    }
}
-(void)controller:(UIViewController *)rootViewController1{
    self->rootViewController = rootViewController1;
}


-(BOOL)showFullscreen:(UIViewController *)rootViewController1{
    NSLog(@"oad inmobi::showFullscreen Loaded interstitial ad");
    if (self->interstitial_.state == kIMInterstitialStateReady) {
        self->gotFullscreen = NO;
        [self->interstitial_ presentInterstitialAnimated:YES];
        return YES;
    }
    if(self->gotFullscreen){
        self->gotFullscreen = NO;
        [self->interstitial_ presentInterstitialAnimated:YES];
        return YES;
    }
    [self preloadFullscreen];
    return NO;
}
-(BOOL)verify{
    NSArray * a1 = [NSArray arrayWithObjects:@"AdSupport", @"AudioToolbox", @"AVFoundation", @"CoreGraphics", @"MessageUI", @"StoreKit", @"SystemConfiguration", nil];
    //return [oad verifyFrameworks:a1];
    
    BOOL good = YES;
    for(int i = 0; i < [a1 count]; i++){
        NSString * frmk = [a1 objectAtIndex:i];
        if([OpenAdAdapter verifyFramework:frmk]){
            // Ok
            
        }else{
            good = NO;
            NSLog(@"network %@ requires framework %@", self->name, frmk);
        }
    }
    if(good){
        NSLog(@"network %@ has all required frameworks", self->name);
    }
    
    return good;
}


-(BOOL)available{
    if(NSClassFromString(@"InMobi")){
        return YES;
    }else{
        return NO;
    }
}


-(float)heightPts{
    if(self->banner == nil)return 0;
    if(self->top) return bannerHeight;
    return -bannerHeight;
}













- (void)bannerDidReceiveAd:(IMBanner *)banner {
    NSLog(@"oad inmobi Finished loading banner ad.");
    self->bannerShown = YES;
}
- (void)banner:(IMBanner *)banner didFailToReceiveAdWithError:(IMError *)error {
    NSString *errorMessage = [NSString stringWithFormat:@"Loading banner ad failed. Error code: %d, message: %@", [error code], [error localizedDescription]];
    NSLog(@"oad inmobi didFailToReceiveAdWithError %@", errorMessage);
    self->bannerFailed = YES;
}
-(void)bannerDidInteract:(IMBanner *)banner withParams:(NSDictionary *)dictionary {
    NSLog(@"oad inmobi Interaction with Banner ad happened with params: %@", [dictionary description]);
}
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    NSLog(@"oad inmobi Banner ad preparing to present screen");
}
- (void)bannerWillDismissScreen:(IMBanner *)banner {
    NSLog(@"oad inmobi Banner ad preparing to dismiss screen");
}
- (void)bannerDidDismissScreen:(IMBanner *)banner {
    NSLog(@"oad inmobi Banner ad dismissed screen");
}
- (void)bannerWillLeaveApplication:(IMBanner *)banner {
    NSLog(@"oad inmobi Banner ad preparing to leave application");
}














- (void)interstitialDidReceiveAd:(IMInterstitial *)ad {
    NSLog(@"oad inmobi Loaded interstitial ad");
    //[ad presentInterstitialAnimated:YES];
    self->gotFullscreen = YES;
}
- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error {
    NSString *errorMessage = [NSString stringWithFormat:@"Loading ad failed. Error code: %d, message: %@", [error code], [error localizedDescription]];
    NSLog(@"%@", errorMessage);
    self->gotFullscreen = NO;
}
//Interstitial ad notifies its delegate that and error has been encountered while trying to load the ad.
//Check IMError.h for all possible errors.
- (void)interstitialWillPresentScreen:(IMInterstitial *)ad {
    NSLog(@"oad inmobi Interstitial ad preparing to present screen");
}
- (void)interstitialWillDismissScreen:(IMInterstitial *)ad {
    NSLog(@"oad inmobi Interstitial ad preparing to dismiss screen");
}
- (void)interstitialDidDismissScreen:(IMInterstitial *)ad {
    NSLog(@"oad inmobi Interstitial ad dismissed screen");
    [self preloadFullscreen];
}
- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad {
    NSLog(@"oad inmobi Interstitial ad preparing to leave application");
}
-(void)interstitialDidInteract:(IMInterstitial *)ad withParams:(NSDictionary *)dictionary {
    NSLog(@"oad inmobi Interaction with Interstitial happened with params: %@",[dictionary description]);
}


@end
