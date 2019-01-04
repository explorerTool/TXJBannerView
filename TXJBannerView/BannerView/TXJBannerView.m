//
//  TXJBannerView.m
//  TXJBannerView
//
//  Created by iOS_BFDL on 2019/1/4.
//  Copyright © 2019 AG. All rights reserved.
//

#import "TXJBannerView.h"


static NSInteger const MAXCELLS = 100;
static NSString* const cellIdentifier = @"cellIdentifier";

@interface TXJBannerView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray* indexDataSource;
@property (nonatomic, strong) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic, strong) UICollectionView* collectionView;


@property (nonatomic, weak) NSTimer* timer;

@end

@implementation TXJBannerView

- (void)dealloc
{
    [self invalidateTimer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:[self collectionView]];
        
        [self createTimer];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self collectionView] setFrame:[self bounds]];
    [[self flowLayout] setItemSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
}

#pragma mark - delegate
#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self indexDataSource] count];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TXJBannerViewCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    if (indexPath.row < [[self indexDataSource] count]) {
       
        
        NSInteger index = [[[self indexDataSource] objectAtIndex:indexPath.row] integerValue];
        
        NSString* data = [[_dataSource dataSourceInBannerView:self] objectAtIndex:index];
        
        if ([data hasPrefix:@"http"]) {
            
        } else {
            cell.exhibitionBoothImageView.image = [UIImage imageNamed:data];
        }
        
    }
    
    
    
    
    return cell;
}



#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(bannerView:didSelectItemAtIndexPath:)]) {
        
        
        if (indexPath.row < [[self indexDataSource] count]) {
            
            
            NSInteger index = [[[self indexDataSource] objectAtIndex:indexPath.row] integerValue];
            
            [_delegate bannerView:self didSelectItemAtIndexPath:[TXJIndexPath indexPathForRow:index inSection:indexPath.section]];
            
        }
        
        
        
    }
}

#pragma mark -- UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger realCount = [_dataSource dataSourceInBannerView:self].count;
    
    NSIndexPath* indexPath = [self currentIndexPath];
    
    NSInteger index = indexPath.row % realCount;
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MAXCELLS / 2 * realCount + index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:4]];
    
}

#pragma mark - event
- (void)automaticScroll
{
    //手指拖拽，禁止自动轮播
    if (self.collectionView.isDragging) {return;}
    NSLog(@"-------");
    
}

#pragma mark - private Methods
- (NSIndexPath*)currentIndexPath
{
    CGPoint point = [self convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:point];
    return indexPath;
}

- (void)scrollToItemAtRow:(NSInteger)row
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}


- (void)createTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - getter Methods
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[TXJBannerViewCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        [_collectionView setPagingEnabled:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        
        [_flowLayout setItemSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)];
    }
    
    return _collectionView;
}


- (UICollectionViewFlowLayout*)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[CAnimationCollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0;
    }
    
    return _flowLayout;
}

- (NSArray*)indexDataSource
{
    if (!_indexDataSource) {
        
        
        NSInteger realCount = [_dataSource dataSourceInBannerView:self].count;
        
        if (realCount > 0) {
            NSMutableArray* array = [NSMutableArray arrayWithCapacity:MAXCELLS];
            for (NSInteger index = 0; index < MAXCELLS; index++) {
                for (NSInteger realIndex = 0; realIndex < realCount; realIndex++) {
                    [array addObject:@(realIndex)];
                }
            }
            
            _indexDataSource = array;
        }
    
    }
    
    return _indexDataSource;
}


@end


@implementation TXJIndexPath

+ (instancetype)indexPathWithIndex:(NSUInteger)index
{
    
    TXJIndexPath* indexPath = [TXJIndexPath indexPathForRow:index inSection:0];
    return indexPath;
}

+ (instancetype)indexPathForRow:(NSInteger)row inSection:(NSInteger)section
{
    TXJIndexPath* indexPath = [[TXJIndexPath alloc] initForRow:row inSection:section];
    return indexPath;
}

- (instancetype)initWithIndex:(NSUInteger)index
{
    if (self = [self initForRow:index inSection:0]) {
        
    }
    
    return self;
}

- (instancetype)initForRow:(NSInteger)row inSection:(NSInteger)section
{
    if (self = [super init]) {
        self.section = section;
        self.row = row;
    }
    
    return self;
}

@end

@implementation TXJBannerViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        [[self contentView] addSubview:[self exhibitionBoothImageView]];
        [_exhibitionBoothImageView setFrame:self.bounds];
        
    }
    
    return self;
}


#pragma mark - getter Methods
- (UIImageView*)exhibitionBoothImageView
{
    if (!_exhibitionBoothImageView) {
        _exhibitionBoothImageView = [[UIImageView alloc] init];
    }
    
    return _exhibitionBoothImageView;
}

@end

@implementation CAnimationCollectionViewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    CGRect rect = CGRectMake(proposedContentOffset.x, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat centerX = proposedContentOffset.x + self.collectionView.bounds.size.width / 2.0;
    
    CGFloat offset = CGFLOAT_MAX;
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in attributes) {
        
        CGFloat itemCenterX = layoutAttributes.center.x;
        
        CGFloat tmpOffset = itemCenterX - centerX;
        if (fabs(tmpOffset) < fabs(offset)) {
            offset = tmpOffset;
        }
    }
    
    
    
    return CGPointMake(proposedContentOffset.x + offset, proposedContentOffset.y);
    
    
}

@end
