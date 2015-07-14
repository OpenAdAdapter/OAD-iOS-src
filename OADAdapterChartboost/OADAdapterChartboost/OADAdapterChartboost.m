//
//  OADAdapterChartboost.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OpenAdAdapter.h"
#import "OADAdapterChartboost.h"
#import <Chartboost/Chartboost.h>



@implementation OADAdapterChartboost
{
    OpenAdAdapter * oad;
    NSString * name;
    NSString * _id;
    NSString * sig;
}


-(void)start:(OpenAdAdapter*)oad1 WithDictionary:(NSDictionary*)d1{
    self->oad = oad1;
    self->name = [d1 objectForKey:@"name"];
    self->_id = [d1 objectForKey:@"id"];
    self->sig = [d1 objectForKey:@"sig"];
    
    [Chartboost startWithAppId:self->_id
                  appSignature:self->sig
                      delegate:self];
    [Chartboost cacheInterstitial:CBLocationDefault];
    [Chartboost cacheRewardedVideo:CBLocationDefault];
    
}
-(BOOL)available{
    if(NSClassFromString(@"Chartboost")){
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)verify{
    return NO;
}
-(void)tick{
    
}
-(void)showTopBanner:(UIViewController *)rootViewController{
    
}
-(void)showBottomBanner:(UIViewController *)rootViewController{
    
}
-(void)hideBanner{
    
}
-(BOOL)showFullscreen:(UIViewController *)rootViewController{
    if([Chartboost hasInterstitial:CBLocationDefault]){
        [Chartboost showInterstitial:CBLocationDefault];
        return YES;
    }
    return NO;
}
-(BOOL)showRewarded:(UIViewController *)rootViewController{
    if([Chartboost hasRewardedVideo:CBLocationDefault]){
        [Chartboost showRewardedVideo:CBLocationDefault];
        return YES;
    }
    return NO;
}
-(void)controller:(UIViewController *)rootViewController{
    
}
-(NSString*)name{
    return self->name;
}









































#pragma mark - Interstitial Delegate

/*!
 @abstract
 Called before requesting an interstitial via the Chartboost API server.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should fetch data from
 the Chartboost API servers for the given CBLocation.  This is evaluated
 if the showInterstitial:(CBLocation) or cacheInterstitial:(CBLocation)location
 are called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op.
 
 Default return is YES.
 */
- (BOOL)shouldRequestInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate shouldRequestInterstitial");
    return YES;
}

/*!
 @abstract
 Called before an interstitial will be displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should display an interstitial
 for the given CBLocation.  This is evaluated if the showInterstitial:(CBLocation)
 is called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op and nothing is displayed.
 
 Default return is YES.
 */
- (BOOL)shouldDisplayInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate shouldDisplayInterstitial");
    return YES;
}

/*!
 @abstract
 Called after an interstitial has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has
 been displayed on the screen for a given CBLocation.
 */
- (void)didDisplayInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate didDisplayInterstitial");
    
}

/*!
 @abstract
 Called after an interstitial has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate didCacheInterstitial");
    
}

/*!
 @abstract
 Called after an interstitial has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an interstitial has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error{
    NSLog(@"chartboost deletegate didFailToLoadInterstitial");
    
}

/*!
 @abstract
 Called after a click is registered, but the user is not fowrwarded to the IOS App Store.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when a click is registered, but the user is not fowrwarded
 to the IOS App Store for a given CBLocation.
 */
- (void)didFailToRecordClick:(CBLocation)location
                   withError:(CBClickError)error{
    NSLog(@"chartboost deletegate didFailToRecordClick");
    
}

/*!
 @abstract
 Called after an interstitial has been dismissed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been dismissed for a given CBLocation.
 "Dismissal" is defined as any action that removed the interstitial UI such as a click or close.
 */
- (void)didDismissInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate didDismissInterstitial");
    
}

/*!
 @abstract
 Called after an interstitial has been closed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been closed for a given CBLocation.
 "Closed" is defined as clicking the close interface for the interstitial.
 */
- (void)didCloseInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate didCloseInterstitial");
    
}

/*!
 @abstract
 Called after an interstitial has been clicked.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been click for a given CBLocation.
 "Clicked" is defined as clicking the creative interface for the interstitial.
 */
- (void)didClickInterstitial:(CBLocation)location{
    NSLog(@"chartboost deletegate didClickInterstitial");
    
}

/*!
 @abstract
 Called before an "more applications" will be displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should display an "more applications"
 for the given CBLocation.  This is evaluated if the showMoreApps:(CBLocation)
 is called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op and nothing is displayed.
 
 Default return is YES.
 */
- (BOOL)shouldDisplayMoreApps:(CBLocation)location{
    NSLog(@"chartboost deletegate shouldDisplayMoreApps");
    return YES;
}

/*!
 @abstract
 Called after an "more applications" has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an "more applications" has
 been displayed on the screen for a given CBLocation.
 */
- (void)didDisplayMoreApps:(CBLocation)location{
    NSLog(@"chartboost deletegate didDisplayMoreApps");
    
}

/*!
 @abstract
 Called after an "more applications" has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an "more applications" has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheMoreApps:(CBLocation)location{
    NSLog(@"chartboost deletegate didCacheMoreApps");
    
}

/*!
 @abstract
 Called after an "more applications" has been dismissed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an "more applications" has been dismissed for a given CBLocation.
 "Dismissal" is defined as any action that removed the "more applications" UI such as a click or close.
 */
- (void)didDismissMoreApps:(CBLocation)location{
    NSLog(@"chartboost deletegate didDismissMoreApps");
    
}

/*!
 @abstract
 Called after an "more applications" has been closed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an "more applications" has been closed for a given CBLocation.
 "Closed" is defined as clicking the close interface for the "more applications".
 */
- (void)didCloseMoreApps:(CBLocation)location{
    NSLog(@"chartboost deletegate didCloseMoreApps");
    
}

/*!
 @abstract
 Called after an "more applications" has been clicked.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an "more applications" has been clicked for a given CBLocation.
 "Clicked" is defined as clicking the creative interface for the "more applications".
 */
- (void)didClickMoreApps:(CBLocation)location{
    NSLog(@"chartboost deletegate didClickMoreApps");
    
}

/*!
 @abstract
 Called after an "more applications" has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an "more applications" has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadMoreApps:(CBLocation)location
                    withError:(CBLoadError)error{
    NSLog(@"chartboost deletegate didFailToLoadMoreApps");
    
}

#pragma mark - Video Delegate

/*!
 @abstract
 Called after videos have been successfully prefetched.
 
 @discussion Implement to be notified of when the prefetching process has finished successfully.
 */

- (void)didPrefetchVideos{
    NSLog(@"chartboost deletegate didPrefetchVideos");
    
}

#pragma mark - Rewarded Video Delegate

/*!
 @abstract
 Called before a rewarded video will be displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should display a rewarded video
 for the given CBLocation.  This is evaluated if the showRewardedVideo:(CBLocation)
 is called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op and nothing is displayed.
 
 Default return is YES.
 */
- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate shouldDisplayRewardedVideo");
    return YES;
    
}

/*!
 @abstract
 Called after a rewarded video has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has
 been displayed on the screen for a given CBLocation.
 */
- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate didDisplayRewardedVideo");
    
}

/*!
 @abstract
 Called after a rewarded video has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheRewardedVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate didCacheRewardedVideo");
    
}

/*!
 @abstract
 Called after a rewarded video has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an rewarded video has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    NSLog(@"chartboost deletegate didFailToLoadRewardedVideo");
    
}

/*!
 @abstract
 Called after a rewarded video has been dismissed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been dismissed for a given CBLocation.
 "Dismissal" is defined as any action that removed the rewarded video UI such as a click or close.
 */
- (void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate didDismissRewardedVideo");
    
}

/*!
 @abstract
 Called after a rewarded video has been closed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been closed for a given CBLocation.
 "Closed" is defined as clicking the close interface for the rewarded video.
 */
- (void)didCloseRewardedVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate didCloseRewardedVideo");
    
}

/*!
 @abstract
 Called after a rewarded video has been clicked.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been click for a given CBLocation.
 "Clicked" is defined as clicking the creative interface for the rewarded video.
 */
- (void)didClickRewardedVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate didClickRewardedVideo");
    
}

/*!
 @abstract
 Called after a rewarded video has been viewed completely and user is eligible for reward.
 
 @param reward The reward for watching the video.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been viewed completely and user is eligible for reward.
 */
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
    
    NSLog(@"chartboost deletegate didCompleteRewardedVideo %d", reward);
    
    OADReward * _reward = [[OADReward alloc] initWithNetwork:self->name amount:reward currency:@""];
    [self->oad addReward:_reward];
}

#pragma mark - InPlay Delegate

/*!
 @abstract
 Called after an InPlay object has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an InPlay object has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheInPlay:(CBLocation)location{
    NSLog(@"chartboost deletegate didCacheInPlay");
    
}

/*!
 @abstract
 Called after a InPlay has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an InPlay has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadInPlay:(CBLocation)location
                  withError:(CBLoadError)error{
    NSLog(@"chartboost deletegate didFailToLoadInPlay");
    
}

#pragma mark - General Delegate

/*!
 @abstract
 Called before a video has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a video will
 be displayed on the screen for a given CBLocation.  You can then do things like mute
 effects and sounds.
 */
- (void)willDisplayVideo:(CBLocation)location{
    NSLog(@"chartboost deletegate willDisplayVideo");
    
}

/*!
 @abstract
 Called after the App Store sheet is dismissed, when displaying the embedded app sheet.
 
 @discussion Implement to be notified of when the App Store sheet is dismissed.
 */
- (void)didCompleteAppStoreSheetFlow{
    NSLog(@"chartboost deletegate didCompleteAppStoreSheetFlow");
    
}

/*!
 @abstract
 Called if Chartboost SDK pauses click actions awaiting confirmation from the user.
 
 @discussion Use this method to display any gating you would like to prompt the user for input.
 Once confirmed call didPassAgeGate:(BOOL)pass to continue execution.
 */
- (void)didPauseClickForConfirmation{
    NSLog(@"chartboost deletegate didPauseClickForConfirmation");
    
}

















@end
