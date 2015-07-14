//
//  OADAdapterInmobi.h
//  OADAdapterInmobi
//
//  Created by Artem Babenko on 5/26/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OADAdapter.h"

@protocol IMBannerDelegate;
@protocol IMInterstitialDelegate;

@interface OADAdapterInmobi : OADAdapter<IMBannerDelegate, IMInterstitialDelegate>


-(BOOL)available;



@end
