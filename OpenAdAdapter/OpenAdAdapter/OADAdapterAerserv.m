//
//  OADAdapterAerserv.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//
#import "OpenAdAdapter.h"
#import "OADAdapterAerserv.h"

#import "AerServSDK/ASAdView.h"
#import "AerServSDK/ASInterstitialViewController.h"



@implementation OADAdapterAerserv
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * banner320;
    NSString * banner728;
    NSString * fullscreenId;
    NSString * rewardedId;
    UIViewController * bannerRootViewController;
    BOOL top, _showBanner, bannerShown, bannerFailed;
    CGFloat bannerHeight;
    ASInterstitialViewController * fullscreenAd;
    ASInterstitialViewController * rewardedAd;
    ASAdView * banner;
}
-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
    self->banner320 = [d1 objectForKey:@"banner320"];
    self->banner728 = [d1 objectForKey:@"banner728"];
    self->fullscreenId = [d1 objectForKey:@"fullscreenId"];
    self->rewardedId = [d1 objectForKey:@"rewardedId"];
    
    //self->fullscreenId = @"1000741";
    
    self->_showBanner = NO;
    
    
    // self->fullscreenAd = [ASInterstitialViewController viewControllerForPlacementID:self->fullscreenId withDelegate:self];
    [self preloadFullscreen];
    [self preloadRewarded];
    
}
-(void)preloadFullscreen{
    if(self->fullscreenId){
        self->fullscreenAd = [ASInterstitialViewController viewControllerForPlacementID:self->fullscreenId withDelegate:self];
        [self->fullscreenAd loadAd];
    }
}
-(void)preloadRewarded{
    if(self->rewardedId){
        self->rewardedAd = [ASInterstitialViewController viewControllerForPlacementID:self->rewardedId withDelegate:self];
        [self->rewardedAd loadAd];
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
            self->banner =  [[ASAdView alloc] initWithPlacementID:self->banner320 size:ASBannerSize];
            //            self->bannerAd.rootViewController = self->bannerRootViewController;
            //          self->bannerAd.delegate = self;
            
            [self->banner loadAd];
            
            
            
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




-(BOOL)available{
    if(NSClassFromString(@"ASAdView")){
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)showFullscreen:(UIViewController *)rootViewController1{
    if (self->fullscreenAd) {
        if([self->fullscreenAd isReady]){
            [self->fullscreenAd showFromViewController:rootViewController1];
            return YES;
        }else{
            
        }
    }
    return NO;
}




-(BOOL)showRewarded:(UIViewController *)rootViewController1{
    if(self->rewardedAd){
        if([self->rewardedAd isReady]){
            [self->rewardedAd showFromViewController:rootViewController1];
            return YES;
        }else{
            
        }
    }
    return NO;
}


-(float)heightPts{
    if(self->banner == nil)return 0;
    if(self->top) return bannerHeight;
    return -bannerHeight;
}





















/*!
 * Called when the ad has loaded successfuly.
 *
 * @param viewController The view controller that the ad is displayed on.
 */
- (void)interstitialViewControllerAdLoadedSuccessfully:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate interstitialViewControllerAdLoadedSuccessfully");
    self->bannerShown = YES;
}

/*!
 * Called when the ad failed has failed to load.
 *
 * @param viewController The view controller that attempted to load the ad.
 * @param error The error that caused the load to fail.
 */
- (void)intersitialViewControllerAdFailedToLoad:(ASInterstitialViewController *)viewController withError:(NSError *)error{
    NSLog(@"aerserv inter delegate intersitialViewControllerAdFailedToLoad %@", error);
    //[self performSelector:@selector(preloadFullscreen) withObject:nil afterDelay:1.0];
    self->bannerFailed = YES;
}


/*!
 * Called just before the view appears
 *
 * @param viewController The view controller whose view is about to appear.
 */
- (void)intersitialViewControllerWillAppear:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate intersitialViewControllerWillAppear");
    
}

/*!
 * Called just after the view controller's view appears.
 *
 * @param viewController The view controller whose view appeared.
 */
- (void)intersitialViewControllerDidAppear:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate intersitialViewControllerDidAppear");
    
}

/*!
 * Called just before the view is dismissed
 *
 * @param viewController The view controller whose view is about to be dismissed.
 */
- (void)interstitialViewControllerWillDisappear:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate interstitialViewControllerWillDisappear");
    if(viewController){
        if(self->rewardedAd == viewController)
            [self preloadRewarded];
        if(self->fullscreenAd == viewController)
            [self preloadFullscreen];
    }
}

/*!
 * Called just after the view is dismissed
 *
 * @param viewController The view controller whose view was dismissed.
 */
- (void)interstitialViewControllerDidDisappear:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate interstitialViewControllerDidDisappear");
    
}

/*!
 * Called when an ad has expired. One action may be to call load ad again to load the new ad.
 *
 * @param viewController The view controller whose as has expired.
 */
- (void)interstitialViewControllerAdExpired:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate interstitialViewControllerAdExpired");
    
}

/*!
 * Called when an ad has been touched.
 *
 * @param viewController The view controller whose as has expired.
 */
- (void)interstitialViewControllerAdWasTouched:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate interstitialViewControllerAdWasTouched");
    
}

/*!
 * This called when the ad has preloaded
 *
 * @param adView - The ad that preloaded.
 */
- (void)adViewDidPreloadAd:(ASInterstitialViewController *)viewController{
    NSLog(@"aerserv inter delegate adViewDidPreloadAd");
    
}

/*!
 * This called when an ad with a virtual currency reward has loaded
 *
 * @param adView - The ad that loaded with virtual currency enabled.
 * @param vcData - A dictionary containing the virtual currency data; contains "name" and "rewardAmount" keys
 */
- (void)adViewDidVirtualCurrencyLoad:(ASInterstitialViewController *)viewController vcData:(NSDictionary *)vcData{
    NSLog(@"aerserv inter delegate adViewDidVirtualCurrencyLoad %@", vcData);
    
}

/*!
 * This called when an ad with a virtual currency reward has been rewarded
 *
 * @param adView - The ad that completed with virtual currency being rewarded
 * @param vcData - A dictionary containing the virtual currency data; contains "name" and "rewardAmount" keys
 */
- (void)adViewDidVirtualCurrencyReward:(ASInterstitialViewController *)viewController vcData:(NSDictionary *)vcData{
    NSLog(@"aerserv inter delegate adViewDidVirtualCurrencyReward %@", vcData);
    if(!vcData)return;
    float amount = [[vcData objectForKey:@"rewardAmount"] floatValue];
    NSString * currency = [vcData objectForKey:@"name"];
    OADReward * reward = [[OADReward alloc] initWithNetwork:self->name amount:amount currency:currency];
    [self->oad addReward:reward];
}
























@end
