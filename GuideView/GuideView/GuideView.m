//
//  GuideView.m
//  GuideView
//
//  Created by pxh on 16/7/5.
//  Copyright © 2016年 裴新华. All rights reserved.
//

#import "GuideView.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface GuideView()<UIScrollViewDelegate>
{
    UIScrollView*   _scrollView;
    CGSize          _size;
}

@property(nonatomic,strong)UIPageControl* pageControl;

@end

@implementation GuideView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _size = frame.size;
        //声明滚动视图
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [self addSubview:_scrollView];
        _scrollView.bounces                        = NO;
        _scrollView.delegate                       = self;
        _scrollView.pagingEnabled                  = YES;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        //加载pagecontrol
        [self addSubview:self.pageControl];
        //添加移除操作
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)removeSelf{
    if (_pageControl.currentPage == _guideImages.count - 1) {
        [self removeFromSuperview];
    }
}

/**
 *  懒加载pagecontrol
 *
 *  @return pagecontrol本身
 */
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(_size.width * 0.5, _size.height - 60, 0, 40)];
        _pageControl.backgroundColor = [UIColor redColor];
    }
    return _pageControl;
}
/**
 *  图片数组的Setting函数
 *
 *  @param guideImages 图片数组
 */
-(void)setGuideImages:(NSArray *)guideImages{
    _guideImages = guideImages;
    if (guideImages.count > 0) {
        _pageControl.numberOfPages = guideImages.count;
        _scrollView.contentSize = CGSizeMake(guideImages.count * _size.width, _size.height);
        //遍历加载所有图片
        for (int i = 0; i < guideImages.count; i ++) {
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * _size.width, 0, _size.width, _size.height)];
            [imageView setImage:[UIImage imageNamed:guideImages[i]]];
            [_scrollView addSubview:imageView];
        }
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    _pageControl.currentPage = round(offset.x / kScreenWidth);
}

@end
