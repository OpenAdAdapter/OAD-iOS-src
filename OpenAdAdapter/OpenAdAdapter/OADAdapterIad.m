//
//  OADAdapterIad.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 5/6/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OpenAdAdapter.h"
#import "OADAdapterIad.h"
@import iAd;

@implementation OADAdapterIad
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * bannerId;
    NSString * fullscreenId;
    ADInterstitialAd *interstitial;
    ADBannerView * banner;
    UIViewController * rootViewController;
    UIViewController * bannerRootViewController;
    BOOL top, _showBanner, bannerShown, bannerFailed;
    CGFloat bannerHeight;
}
-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
//    self->bannerId = [d1 objectForKey:@"bannerId"];
//    self->fullscreenId = [d1 objectForKey:@"fullscreenId"];
    
    
    self->_showBanner = NO;
    
    
    [self preloadFullscreen];
    
}
-(void)preloadFullscreen{
    self->interstitial = [[ADInterstitialAd alloc] init];

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
            self->banner = [[ADBannerView alloc]  initWithAdType:ADAdTypeBanner];
            
            self->banner.delegate = self;
            
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
    if (self->interstitial.loaded)
    {
        [self->interstitial presentFromViewController:rootViewController1];
//        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
//            [self->interstitial presentFromViewController:rootViewController1];
//        }else
//        {
//            [rootViewController1 requestInterstitialAdPresentation];
//        }
        
        return YES;
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
    if(NSClassFromString(@"ADBannerView")){
        NSLog(@"iAd framework detected");
        return YES;
    }else{
        NSLog(@"iAd framework is mssing");
        return NO;
    }
}


-(float)heightPts{
    if(self->banner == nil)return 0;
    if(self->top) return bannerHeight;
    return -bannerHeight;
}















/*!
 * @method bannerViewWillLoadAd:
 *
 * @discussion
 * Called when a banner has confirmation that an ad will be presented, but
 * before the resources necessary for presentation have loaded.
 */
- (void)bannerViewWillLoadAd:(ADBannerView *)banner  NS_AVAILABLE_IOS(5_0){
    NSLog(@"oad iad bannerViewWillLoadAd");
    
}

/*!
 * @method bannerViewDidLoadAd:
 *
 * @discussion
 * Called each time a banner loads a new ad. Once a banner has loaded an ad, it
 * will display it until another ad is available.
 *
 * It's generally recommended to show the banner view when this method is called,
 * and hide it again when bannerView:didFailToReceiveAdWithError: is called.
 */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"oad iad bannerViewDidLoadAd");
    self->bannerShown = YES;
}

/*!
 * @method bannerView:didFailToReceiveAdWithError:
 *
 * @discussion
 * Called when an error has occurred while attempting to get ad content. If the
 * banner is being displayed when an error occurs, it should be hidden
 * to prevent display of a banner view with no ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"oad iad bannerView didFailToReceiveAdWithError");
    self->bannerFailed = YES;
}

/*!
 * @method bannerViewActionShouldBegin:willLeaveApplication:
 *
 * Called when the user taps on the banner and some action is to be taken.
 * Actions either display full screen content modally, or take the user to a
 * different application.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    NSLog(@"oad iad bannerViewActionShouldBegin");
    return YES;
}

/*!
 * @method bannerViewActionDidFinish:
 *
 * Called when a modal action has completed and control is returned to the
 * application. Games, media playback, and other activities that were paused in
 * bannerViewActionShouldBegin:willLeaveApplication: should resume at this point.
 */
- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"oad iad bannerViewActionDidFinish");
    
}




















/*!
 * @method interstitialAdDidUnload:
 *
 * @discussion
 * When this method is invoked, if the application is using -presentInView:, the
 * content will be unloaded from the container shortly after this method is
 * called and no new content will be loaded. This may occur either as a result
 * of user actions or if the ad content has expired.
 *
 * In the case of an interstitial presented via -presentInView:, the layout of
 * the app should be updated to reflect that an ad is no longer visible. e.g.
 * by removing the view used for presentation and replacing it with another view.
 */
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd{
    NSLog(@"oad iad interstitialAdDidUnload");
    
}

/*!
 * @method interstitialAd:didFailWithError:
 *
 * @discussion
 * Called when an error has occurred attempting to get ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error{
    NSLog(@"oad iad interstitialAd didFailWithError");
    
}


/*!
 * @method interstitialAdWillLoad:
 *
 * @discussion
 * Called when the interstitial has confirmation that an ad will be presented,
 * but before the ad has loaded resources necessary for presentation.
 */
- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd NS_AVAILABLE_IOS(5_0){
    NSLog(@"oad iad interstitialAdWillLoad");
    
}

/*!
 * @method interstitialAdDidLoad:
 *
 * @discussion
 * Called when the interstitial ad has finished loading ad content. The delegate
 * should implement this method so it knows when the interstitial ad is ready to
 * be presented.
 */
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd{
    NSLog(@"oad iad interstitialAdDidLoad");
    
}

/*!
 * @method interstitialAdActionShouldBegin:willLeaveApplication:
 *
 * @discussion
 * Called when the user chooses to interact with the interstitial ad.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */
- (BOOL)interstitialAdActionShouldBegin:(ADInterstitialAd *)interstitialAd willLeaveApplication:(BOOL)willLeave{
    NSLog(@"oad iad interstitialAdActionShouldBegin");
    return YES;
}

/*!
 * @method interstitialAdActionDidFinish:
 * This message is sent when the action has completed and control is returned to
 * the application. Games, media playback, and other activities that were paused
 * in response to the beginning of the action should resume at this point.
 */
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd{
    NSLog(@"oad iad interstitialAdActionDidFinish");
    
}













@end
