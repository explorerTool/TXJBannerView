//
//  ViewController.m
//  TXJBannerView
//
//  Created by iOS_BFDL on 2019/1/4.
//  Copyright © 2019 AG. All rights reserved.
//

#import "ViewController.h"
#import "TXJBannerView.h"

@interface ViewController () <TXJBannerViewDelegate, TXJBannerViewDataSource>

@property (nonatomic, strong) TXJBannerView* bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[self view] addSubview:[self bannerView]];
    
}

#pragma mark - delegate
#pragma mark -- TXJBannerViewDataSource
- (NSArray*)dataSourceInBannerView:(TXJBannerView *)bannerView
{
    return @[@"banner_1",@"banner_2"];
}

#pragma mark -- TXJBannerViewDelegate
- (void)bannerView:(TXJBannerView *)bannerView didSelectItemAtIndexPath:(TXJIndexPath *)indexPath
{
    
    NSLog(@"%ld of %ld",indexPath.row,indexPath.section);
    
}



- (TXJBannerView*)bannerView
{
    if (!_bannerView) {
        _bannerView = [[TXJBannerView alloc] initWithFrame:CGRectMake(0, 44, [[UIScreen mainScreen] bounds].size.width, 130)];
        [_bannerView setDelegate:self];
        [_bannerView setDataSource:self];
    }
    
    return _bannerView;
}

@end
