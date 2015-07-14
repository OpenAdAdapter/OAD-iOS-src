//
//  OADAdapterAdmob.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//
#import "OpenAdAdapter.h"
#import "OADAdapterAdmob.h"
@import GoogleMobileAds;

@implementation OADAdapterAdmob
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * bannerId;
    NSString * fullscreenId;
    NSString * videoId;
    GADInterstitial *interstitial_;
    GADInterstitial *videoAd;
    GADBannerView * banner;
    UIViewController * rootViewController;
    UIViewController * bannerRootViewController;
    BOOL top, _showBanner, bannerShown, bannerFailed;
    CGFloat bannerHeight;
    NSArray * testDevices;
}
-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
    self->bannerId = [d1 objectForKey:@"bannerId"];
    self->fullscreenId = [d1 objectForKey:@"fullscreenId"];
    self->videoId = [d1 objectForKey:@"videoId"];
    id _id = [d1 objectForKey:@"testDevices"];
    if([_id isKindOfClass:[NSArray class]]){
        self->testDevices = _id;
    }
    self->_showBanner = NO;
    
    
    [self preloadFullscreen];
    [self preloadVideo];
    
}
-(void)preloadFullscreen{
    if(self->fullscreenId){
        self->interstitial_ = [[GADInterstitial alloc] init];
        self->interstitial_.adUnitID = self->fullscreenId;
        self->interstitial_.delegate = self;
        
        GADRequest * request = [GADRequest request];
        request.testDevices = self->testDevices;
        [self->interstitial_ loadRequest:request];
    }
}
-(void)preloadVideo{
    if(self->videoId){
        self->videoAd = [[GADInterstitial alloc] init];
        self->videoAd.adUnitID = self->videoId;
        self->videoAd.delegate = self;
        
        GADRequest * request = [GADRequest request];
        request.testDevices = self->testDevices;
        [self->videoAd loadRequest:request];
    }
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
            self->banner = [[GADBannerView alloc]  initWithAdSize:kGADAdSizeSmartBannerPortrait origin:CGPointMake(0,0)];
            self->banner.adUnitID = self->bannerId;
            self->banner.rootViewController = self->bannerRootViewController;
            self->banner.delegate = self;
            
            
            GADRequest * request = [GADRequest request];
            //request.testDevices = self->testDevices;
            [self->banner loadRequest:request];
            
            
            [self->bannerRootViewController.view addSubview:self->banner];
            
        }
        
        CGPoint bannerOrigin = self->banner.frame.origin;
        CGSize bannerSize = self->banner.frame.size;
        self->bannerHeight = bannerSize.height;
        //CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        //CGRect appRect = [[UIScreen mainScreen] applicationFrame];
        //CGRect superRect = self->bannerRootViewController.view.superview.bounds;
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
    if(self->interstitial_){
        if ([self->interstitial_ isReady]) {
            [self->interstitial_ presentFromRootViewController:rootViewController1];
            return YES;
        }else{
        }
    }
    return NO;
}
-(BOOL)showVideo:(UIViewController *)rootViewController1{
    if(self->videoAd){
        if ([self->videoAd isReady]) {
            [self->videoAd presentFromRootViewController:rootViewController1];
            return YES;
        }else{
        }
    }
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


-(BOOL)available{     //   GADBannerView
    //if(NSClassFromString(@"GADBannerView")){
    if(NSClassFromString(@"GADInterstitial")){
        NSLog(@"Admob framework detected");
        return YES;
    }else{
        NSLog(@"Admob framework is mssing");
        return NO;
    }
}

-(float)heightPts{
    if(self->banner == nil)return 0;
    if(self->top) return bannerHeight;
    return -bannerHeight;
}








/// Called when an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    NSLog(@"oad admob adViewDidReceiveAd");
    self->bannerShown = YES;
}

/// Called when an ad request failed.
- (void)adView:(GADBannerView *)adView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"oad admob adViewDidFailToReceiveAdWithError: %@", [error localizedDescription]);
    self->bannerFailed = YES;
}

/// Called just before presenting the user a full screen view, such as
/// a browser, in response to clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"oad admob adViewWillPresentScreen");
}

/// Called just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"oad admob adViewWillDismissScreen");
}

/// Called just after dismissing a full screen view.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"oad admob adViewDidDismissScreen");
}

/// Called just before the application will background or terminate
/// because the user clicked on an ad that will launch another
/// application (such as the App Store).
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"oad admob adViewDidLeaveApplication");
}












/// Called when an interstitial ad request succeeded.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"oad admob interstitialDidReceiveAd");
}

/// Called when an interstitial ad request failed.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"oad admob interstitialDidFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Called just before presenting an interstitial.
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"oad admob interstitialWillPresentScreen");
}

/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"oad admob interstitialWillDismissScreen");
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"oad admob interstitialDidDismissScreen");
//    [self preloadFullscreen];
    [self performSelector:@selector(preloadFullscreen) withObject:nil afterDelay:1.0];
}

/// Called just before the application will background or terminate because the user clicked on an
/// ad that will launch another application (such as the App Store).
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"oad admob interstitialWillLeaveApplication");
}




@end
