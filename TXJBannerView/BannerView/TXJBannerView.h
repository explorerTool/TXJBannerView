//
//  TXJBannerView.h
//  TXJBannerView
//
//  Created by iOS_BFDL on 2019/1/4.
//  Copyright © 2019 AG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TXJBannerView;

@interface TXJIndexPath : NSObject

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger section;

// 类初始化
+ (instancetype)indexPathWithIndex:(NSUInteger)index;
+ (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section;

// 实例初始化
- (instancetype)initWithIndex:(NSUInteger)index;
- (instancetype)initForRow:(NSInteger)row inSection:(NSInteger)section;

@end

@protocol TXJBannerViewDelegate <NSObject>

@optional
//- (void)

- (void)bannerView:(TXJBannerView *)bannerView didSelectItemAtIndexPath:(TXJIndexPath *)indexPath;

@end

@protocol TXJBannerViewDataSource <NSObject>

- (NSArray*)dataSourceInBannerView:(TXJBannerView*)bannerView;

@optional

@end

@interface TXJBannerView : UIView

@property (nonatomic, weak) id<TXJBannerViewDelegate>delegate;
@property (nonatomic, weak) id<TXJBannerViewDataSource>dataSource;

@end


@interface TXJBannerViewCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) UIImageView* exhibitionBoothImageView;


@end


@interface CAnimationCollectionViewFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
