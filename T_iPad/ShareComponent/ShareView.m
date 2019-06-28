//
//  ShareView.m
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "ShareView.h"
#import "ShareItem.h"

@interface ShareView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *box;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, strong) NSArray *highLightImages;
@property (nonatomic, strong) UIView *lineLb;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) SelectedHandler selectedHandler;
@property (nonatomic, copy) void(^closeHandler)(void);

@property (nonatomic, retain) CAAnimationGroup *showContentBoxAnimation;
@property (nonatomic, retain) CAAnimationGroup *dismissContentBoxAnimation;
@property (nonatomic, retain) CABasicAnimation *showBackgroundBoxAnimation;
@property (nonatomic, retain) CABasicAnimation *dismissBackgroundBoxAnimation;
@property (nonatomic, retain) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation ShareView

+ (void)showShareViewWithShareConfiguration:(ShareConfiguration *)shareConfiguration
                            selectedHandler:(void (^)(ShareItem *))selectedHandler
                             dismissHandler:(void (^)(void))dismissHandler
{
    ShareView *shareView = [[ShareView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    shareView.selectedHandler = selectedHandler;
    shareView.closeHandler = dismissHandler;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        if ([self superview] == nil)
        {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            self.tag = 168;
            [window addSubview:self];
        }
        
        _items = [NSMutableArray array];

        [self addGestureRecognizer:self.tapGestureRecognizer];
        
        [self configItemWithShareType:ShareTypeWeChat];
        [self configItemWithShareType:ShareTypeWeChatTimeline];

        [self setupShareView];
        
        [self closeButton];
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:self.showBackgroundBoxAnimation forKey:@"diming"];
        [_box.layer addAnimation:self.showContentBoxAnimation forKey:@"showMenu"];
        [CATransaction commit];
    }
    
    return self;
}

+ (void)hideShareView
{
    UIView *share = [[[UIApplication sharedApplication] keyWindow] viewWithTag:168];
    
    if (share)
    {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.2];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [CATransaction setCompletionBlock:^{
            [share removeFromSuperview];
        }];
        [CATransaction commit];
    }
}

- (ShareItem *)configItemWithShareType:(ShareType)shareType
{
    ShareItem *item = [[ShareItem alloc] initWithShareType:shareType];

    [_items addObject:item];
    
    return item;
}

- (void)setupShareView
{
    UIButton *last = nil;
    
    for (int i = 0; i < _items.count; ++i)
    {
        ShareItem *shareItem = _items[i];

        UIButton *item = [[UIButton alloc] init];
        [item setTitle:shareItem.title forState:UIControlStateNormal];
        [item setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:13];
        [item setImage:[UIImage imageNamed:shareItem.iconName] forState:UIControlStateNormal];
        item.tag = i;
        [item addTarget:self action:@selector(snsItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.box addSubview:item];
        
        [item makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self->_box).offset(13);
            make.bottom.equalTo(self->_box).offset(-60);
            make.height.greaterThanOrEqualTo(140);
            
            if (last)
            {
                make.left.equalTo(last.right);
                make.width.equalTo(last);
            }
            else
            {
                make.left.equalTo(self->_box);
            }
       
            if (i == self->_items.count - 1)
            {
                make.right.equalTo(self->_box);
            }
        }];
        
        last = item;
        
        [item layoutIfNeeded];
        item.titleEdgeInsets = UIEdgeInsetsMake(item.imageView.frame.size.height + 5.0, - item.imageView.bounds.size.width, .0, .0);
        item.imageEdgeInsets = UIEdgeInsetsMake(.0, item.titleLabel.bounds.size.width / 2, item.titleLabel.frame.size.height + 10.0, - item.titleLabel.bounds.size.width / 2);
    }
}

- (UIView *)box
{
    if (_box == nil)
    {
        _box = [[UIView alloc] init];
        _box.layer.cornerRadius = 5;
        _box.layer.masksToBounds = YES;
        _box.backgroundColor = [UIColor whiteColor];

        [self.containerView addSubview:_box];

        [_box makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.containerView);
        }];
    }
    
    return _box;
}

- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil)
    {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor whiteColor];
        
        [self.box addSubview:_contentScrollView];
        
        [_contentScrollView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_box);
            make.top.equalTo(self->_box).offset(13);
            make.bottom.equalTo(self->_box).offset(-40);
        }];
    }
    
    return _contentScrollView;
}

- (UIView *)lineLb
{
    if (_lineLb == nil)
    {
        _lineLb = [[UIView alloc] init];
        _lineLb.backgroundColor = [UIColor blackColor];
        
        [self.box addSubview:_lineLb];
        
        [_lineLb makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self->_box);
            make.bottom.equalTo(self.closeButton.top);
            make.height.equalTo(1);
        }];
    }
    
    return _lineLb;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.box addSubview:btn];
            
            [btn makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(self->_box);
                make.height.equalTo(60);
            }];
            
            btn;
        });
        
        [self lineLb];
    }
    return _closeButton;
}

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (_tapGestureRecognizer == nil)
    {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeButtonAction)];
        [_tapGestureRecognizer setDelegate:self];
    }
    
    return _tapGestureRecognizer;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.tapGestureRecognizer])
    {
        CGPoint p = [gestureRecognizer locationInView:self];

        if (CGRectContainsPoint(_box.frame, p))
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Event

- (void)snsItemAction:(UIButton *)sender
{
    if (_selectedHandler)
    {
        if (sender.tag < _items.count)
        {
            _selectedHandler(_items[sender.tag]);
            
            [self closeButtonAction];
        }
    }
}

- (void)closeButtonAction
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setCompletionBlock:^{
        [self removeFromSuperview];
        [self->_box removeFromSuperview];
    }];
    [self.layer addAnimation:self.dismissBackgroundBoxAnimation forKey:@"lighting"];
    [_box.layer addAnimation:self.dismissContentBoxAnimation forKey:@"dismissMenu"];
    [CATransaction commit];
    
    if (self.closeHandler)
    {
        self.closeHandler();
    }
}

#pragma mark - ******** 动画 ********

- (CABasicAnimation *)showBackgroundBoxAnimation
{
    if (_showBackgroundBoxAnimation == nil)
    {
        _showBackgroundBoxAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        _showBackgroundBoxAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        _showBackgroundBoxAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        [_showBackgroundBoxAnimation setRemovedOnCompletion:NO];
        [_showBackgroundBoxAnimation setFillMode:kCAFillModeBoth];
    }
    
    return _showBackgroundBoxAnimation;
}

- (CABasicAnimation *)dismissBackgroundBoxAnimation
{
    if (_dismissBackgroundBoxAnimation == nil)
    {
        _dismissBackgroundBoxAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        _dismissBackgroundBoxAnimation.fromValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.4] CGColor];
        _dismissBackgroundBoxAnimation.toValue = (id)[[UIColor colorWithWhite:0.0 alpha:0.0] CGColor];
        [_dismissBackgroundBoxAnimation setRemovedOnCompletion:NO];
        [_dismissBackgroundBoxAnimation setFillMode:kCAFillModeBoth];
    }
    
    return _dismissBackgroundBoxAnimation;
}

- (CAAnimationGroup *)showContentBoxAnimation
{
    if (_showContentBoxAnimation == nil)
    {
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:200.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@0.0];
        [opacityAnimation setToValue:@1.0];
        
        _showContentBoxAnimation = [CAAnimationGroup animation];
        [_showContentBoxAnimation setAnimations:@[opacityAnimation, positionAnimation]];
        [_showContentBoxAnimation setRemovedOnCompletion:NO];
        [_showContentBoxAnimation setFillMode:kCAFillModeBoth];
    }
    
    return _showContentBoxAnimation;
}

- (CAAnimationGroup *)dismissContentBoxAnimation
{
    if (_dismissContentBoxAnimation == nil)
    {
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        [positionAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
        [positionAnimation setToValue:[NSNumber numberWithFloat:200.0]];
        
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setFromValue:@1.0];
        [opacityAnimation setToValue:@0.0];
        
        _dismissContentBoxAnimation = [CAAnimationGroup animation];
        [_dismissContentBoxAnimation setAnimations:@[opacityAnimation, positionAnimation]];
        [_dismissContentBoxAnimation setRemovedOnCompletion:NO];
        [_dismissContentBoxAnimation setFillMode:kCAFillModeBoth];
    }
    
    return _dismissContentBoxAnimation;
}

@end
