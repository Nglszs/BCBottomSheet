//
//  BottomUpView.m
//  testsmy
//
//  Created by 莱昂纳多·迪卡普里奥 on 2024/11/18.
//

#import "BottomUpView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation BottomUpView

- (instancetype)initWithMinHeight:(CGFloat)minHeight withMidHeight:(CGFloat)midHeight withMaxHeight:(CGFloat)maxHeight{
    
    self.maxHeight = maxHeight;
    self.midHeight = midHeight;
    self.minHeight = minHeight;
    
    return [self initWithFrame:CGRectMake(0, SCREEN_HEIGHT - self.minHeight, SCREEN_WIDTH, self.maxHeight)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        
    }
    return self;
}
-(void)createUI{
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 16;
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.14].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,1);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 4;
    
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    effectView.frame =  self.bounds;
    effectView.layer.cornerRadius = 16;
    effectView.clipsToBounds = YES;
    [ self addSubview:effectView];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [ self addGestureRecognizer:panGestureRecognizer];
    
    
    
    _topSlideView = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 36)/2, 0, 38, 20)];
    [_topSlideView addTarget:self action:@selector(clickSlide:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.topSlideView];
    
    UIView *slideV = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, 38, 5)];
    slideV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    slideV.layer.cornerRadius = 2.5;
    slideV.userInteractionEnabled = NO;
    slideV.layer.masksToBounds = true;
    [_topSlideView addSubview:slideV];
    
    //    列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, self.maxHeight - 20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    _tableView.alwaysBounceVertical = YES;
    [self addSubview:_tableView];
}

#pragma mark 代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}


#pragma mark 点击顶部滑块
- (void)clickSlide:(UIButton *)sender{
    
    CGFloat targetOffset = [self targetHeightForCurrentY:self.frame.origin.y velocity:0];
    
    if (targetOffset == self.minHeight) {
        
        CGFloat newY = SCREEN_HEIGHT - self.midHeight;
        self.tableView.scrollEnabled = NO;
        if (self.midHeight <= 0) {
            newY = SCREEN_HEIGHT - self.maxHeight;
            self.tableView.scrollEnabled = YES;
        }
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(0, newY, CGRectGetWidth(self.frame), self.maxHeight);
        } completion:^(BOOL finished) {
            
        }];
    } else if (targetOffset == self.midHeight) {
        
        CGFloat newY = SCREEN_HEIGHT - self.maxHeight;
        self.tableView.scrollEnabled = YES;
        
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(0, newY, CGRectGetWidth(self.frame), self.maxHeight);
        } completion:^(BOOL finished) {
            
        }];
    } else {//最大时变为最小
        self.tableView.scrollEnabled = NO;
        [self.tableView setContentOffset:CGPointZero animated:NO];
        CGFloat newY = SCREEN_HEIGHT - self.minHeight;
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frame = CGRectMake(0, newY, CGRectGetWidth(self.frame), self.maxHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.tableView.contentOffset.y > 0) {//tableview滚动还有距离的时候禁掉滑动手势
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint velocity = [gestureRecognizer velocityInView:self];
    
    if (self.frame.origin.y == SCREEN_HEIGHT - self.maxHeight && velocity.y < 0) {
        return NO;
    } else {
        return YES;
    }
}
#pragma mark 拖拽手势
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint translation = [panGestureRecognizer translationInView:self];
    CGPoint velocity = [panGestureRecognizer velocityInView:self];
    
    
    switch (panGestureRecognizer.state) {
            
            
        case UIGestureRecognizerStateChanged: {
            CGFloat newY = self.frame.origin.y + translation.y;
            newY = MIN(MAX(newY,SCREEN_HEIGHT - self.maxHeight), SCREEN_HEIGHT - self.minHeight);
            self.frame = CGRectMake(0, newY, SCREEN_WIDTH, self.maxHeight);
            [panGestureRecognizer setTranslation:CGPointZero inView:self];
            self.tableView.scrollEnabled = NO;
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            
            CGFloat targetOffset = [self targetHeightForCurrentY:self.frame.origin.y velocity:velocity.y];
            if (targetOffset == self.maxHeight) {
                self.tableView.scrollEnabled = YES;
            } else {
                self.tableView.scrollEnabled = NO;
            }
            
            CGFloat newY = SCREEN_HEIGHT - targetOffset;
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
                self.frame = CGRectMake(0, newY, CGRectGetWidth(self.frame), self.maxHeight);
            } completion:^(BOOL finished) {
                
            }];
            break;
        }
            
        default:{
            break;
        }
    }
    
    
}

// 根据当前Y位置和速度来确定目标高度
- (CGFloat)targetHeightForCurrentY:(CGFloat)currentY velocity:(CGFloat)velocity {
    CGFloat currentOffset = SCREEN_HEIGHT - currentY;
    CGFloat closestOffset = self.minHeight;
    
    if (self.midHeight > 0) {
        if (fabs(currentOffset - self.midHeight) < fabs(currentOffset - closestOffset)) {
            closestOffset = self.midHeight;
        }
    }
    
    if (fabs(currentOffset - self.maxHeight) < fabs(currentOffset - closestOffset)) {
        closestOffset = self.maxHeight;
    }
    
    if (velocity > 0) { // 向下滑动
        if (currentOffset > closestOffset) {
            if (self.midHeight > 0) {
                closestOffset = currentOffset > self.midHeight ? self.midHeight : self.minHeight;
            } else {
                closestOffset = self.minHeight;
            }
        }
    } else {// 向上滑动
        if (currentOffset < closestOffset) {
            if (self.midHeight > 0) {
                closestOffset = currentOffset < self.midHeight ? self.midHeight : self.maxHeight;
            } else {
                closestOffset = self.maxHeight;
            }
            
        }
    }
    
    return closestOffset;
}


//关闭
-(void)clickModal{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.maxHeight);
    }];
    
}


- (void)showModal{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT - self.minHeight, SCREEN_WIDTH, self.maxHeight);
    }];
    
}
//此处是scrollview不允许向上滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.tableView] ) {
        
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        }
        
    }
    
}


@end
