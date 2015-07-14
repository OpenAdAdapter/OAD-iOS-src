//
//  ViewController.m
//  OpenAdAdapterApp
//
//  Created by Artem Babenko on 4/28/15.
//  Copyright (c) 2015 Artem Babenko. All rights reserved.
//

#import "ViewController.h"
#import "OpenAdAdapter.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnInit;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@end

@implementation ViewController
{
    bool btick;
    NSString * rewardText;
}
- (IBAction)clickChkReward:(id)sender {
    OADReward * reward = [OpenAdAdapter reward];
    if(reward != nil){
        self->rewardText = [NSString stringWithFormat:@"%@ %f %@", [reward network], [reward amount], [reward currency]];
    }else{
        self->rewardText = @"";
    }
}
- (IBAction)clickInit:(id)sender {
    if(!self->btick){
        self->btick = true;
        [self performSelector:@selector(tick) withObject:nil afterDelay:1.0];
    }
    self.label1.text = @"Initializing 1";
    [OpenAdAdapter startWithUrl:@"https://raw.githubusercontent.com/sample-data/oad1/master/ios-redir.json"];
    //    [OpenAdAdapter startWithUrl:@"https://raw.githubusercontent.com/sample-data/oad1/master/ios-no-heyzap.json"];
    //[OpenAdAdapter startWithUrl:@"https://raw.githubusercontent.com/sample-data/oad1/master/ios-heyzap.json"];
    self.label1.text = @"Initializing 2";
}
-(void)tick{
    [self performSelector:@selector(tick) withObject:nil afterDelay:1.0];
    NSString * s1 = [NSString stringWithFormat:@"bh %g %g %@", [OpenAdAdapter bannerHeightPts], [OpenAdAdapter bannerHeightPixels], self->rewardText];
    self.label1.text = s1;
}
- (IBAction)clickBanner:(id)sender {
    [OpenAdAdapter showTopBanner:self];
}
- (IBAction)clickBottomBanner:(id)sender {
    [OpenAdAdapter showBottomBanner:self];
}
- (IBAction)clickHideBanner:(id)sender {
    [OpenAdAdapter hideBanner];
}
- (IBAction)clickFullscreen:(id)sender {
    [OpenAdAdapter showFullscreen:self];
}
- (IBAction)clickVideo:(id)sender {
    [OpenAdAdapter showVideo:self];
}
- (IBAction)clickRewarded:(id)sender {
    [OpenAdAdapter showRewarded:self];
}
- (IBAction)clickTest:(id)sender {
    
//    [TestX1 test1];
    
    [OpenAdAdapter test1];
}
- (IBAction)clickTest2:(id)sender {
    //[OpenAdAdapter test2:self];
    [OpenAdAdapter showTopBanner:self];
}
- (IBAction)clickTest3:(id)sender {
    //[OpenAdAdapter test3:self];
    [OpenAdAdapter showBottomBanner:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
