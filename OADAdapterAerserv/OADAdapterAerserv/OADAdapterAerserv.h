//
//  OADAdapterAerserv.h
//  OADAdapterAerserv
//
//  Created by Artem Babenko on 5/26/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OADAdapter.h"

@protocol ASInterstitialViewControllerDelegate;

@interface OADAdapterAerserv : OADAdapter<ASInterstitialViewControllerDelegate>


-(BOOL)available;



@end
