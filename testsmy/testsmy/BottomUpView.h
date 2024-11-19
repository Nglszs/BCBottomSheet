//
//  BottomUpView.h
//  testsmy
//
//  Created by 莱昂纳多·迪卡普里奥 on 2024/11/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomUpView : UIView<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *topSlideView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat midHeight;
@property (nonatomic, assign) CGFloat minHeight;

- (instancetype)initWithMinHeight:(CGFloat)minHeight withMidHeight:(CGFloat)midHeight withMaxHeight:(CGFloat)maxHeight;
@end

NS_ASSUME_NONNULL_END
