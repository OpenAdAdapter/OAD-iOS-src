//
//  OADAdapter.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/29/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "OADAdapter.h"

@implementation OADAdapter

-(BOOL)isBannerShown{
    return NO;
}
-(BOOL)isBannerFailed{
    return YES;
}


-(BOOL)showFullscreen:(UIViewController *)rootViewController{
    return NO;
}
-(BOOL)showVideo:(UIViewController *)rootViewController{
    return NO;
}
-(BOOL)showRewarded:(UIViewController *)rootViewController{
    return NO;
}
-(float)heightPts{
    return 999999999;
}
@end
