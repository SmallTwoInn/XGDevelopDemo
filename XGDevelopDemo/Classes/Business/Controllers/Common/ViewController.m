//
//  ViewController.m
//  XGDevelopDemo
//
//  Created by 小广 on 16/8/30.
//  Copyright © 2016年 小广. All rights reserved.
//  主页

#import "ViewController.h"
#import "XGTableTestController.h"
#import "XGCollectionController.h"
#import "XGAddCellController.h"
#import "XGChoseDateView.h"
#import "XGDatePicerViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "XGAutoHeightTabController.h"
#import "WKWebViewBridgeController.h"
#import "XGWKWebViewController.h"
#import "MSSCalendarViewController.h"
#import "MSSCalendarDefine.h"
#import "XGSacnController.h"
#import "XGSearchController.h"

#import "SCSharePlatformMenu.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, MSSCalendarViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSDate *choseDate;

@property (nonatomic, strong) MSSCalendarViewController *calendarVC; // 日历页面
@property (nonatomic, assign) NSInteger startDate;
@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, strong) SCSharePlatformMenu *platformMenu;

@end

@implementation ViewController

#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initDatas];
    
    NSInteger tempNum = (NSInteger)ceil(3.1);
    NSLog(@"tempNum===%ld==",(long)tempNum);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 自定义方法
- (void)initSubViews {
    self.title = @"开发模板";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self registerNibWithTableView];
}

- (void)initDatas {
    NSArray  *dataArray =  @[@"封装的Tab测试", @"CollectionView网格测试",
                             @"Tab弹出小cell测试", @"选择日期的测试一",
                             @"选择日期的测试二",@"日历的选择一",
                             @"自动算高的Tab+设置view指定位置的边框",
                             @"第三方WebViewJavascriptBridge使用WKWebView",
                             @"普通WKWebView使用",@"JSPatch热修复",
                             @"二维码扫描",@"UISearchController测试",
                             @"自定义分享弹出选择平台页面"];
    self.titleArray = [NSMutableArray arrayWithArray:dataArray];
}

// 注册cell
- (void)registerNibWithTableView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell className]];

}

// 将时间字符串 转化为时间戳
- (NSInteger)timestamp:(NSString *)dateString {
    if (!dateString) return 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *tempDate = [dateFormatter dateFromString:dateString];
    if (!tempDate) return 0;
    return [tempDate timeIntervalSince1970];
}

#pragma mark - action事件
// 列表cell点击事件的处理
- (void)selectRowAction:(NSInteger)row {
    
    NSString *tempTitle = self.titleArray[row];
    UIViewController *controller = nil;
    if ([tempTitle isEqualToString:@"封装的Tab测试"]) {
        controller = [[XGTableTestController alloc] init];
    } else if ([tempTitle isEqualToString:@"CollectionView网格测试"]) {
        controller = [[XGCollectionController alloc] init];
    } else if ([tempTitle isEqualToString:@"Tab弹出小cell测试"]) {
        controller = [[XGAddCellController alloc] init];
    } else if ([tempTitle isEqualToString:@"选择日期的测试一"]) {
        [self showDateView:0];
        return;
    } else if ([tempTitle isEqualToString:@"选择日期的测试二"]) {
        [self showDateView:1];
        return;
    } else if ([tempTitle isEqualToString:@"日历的选择一"]) {
        controller = self.calendarVC;
        controller.title = @"日期选择" ;
    } else if ([tempTitle isEqualToString:@"自动算高的Tab+设置view指定位置的边框"]) {
        controller = [[XGAutoHeightTabController alloc] init];
    } else if ([tempTitle isEqualToString:@"第三方WebViewJavascriptBridge使用WKWebView"]) {
        controller = [[WKWebViewBridgeController alloc] init];
    } else if ([tempTitle isEqualToString:@"普通WKWebView使用"]) {
        controller = [[XGWKWebViewController alloc] init];
    } else if ([tempTitle isEqualToString:@"JSPatch热修复"]) {
        // 详细的js用法 https://github.com/bang590/JSPatch/wiki
        [self showJSPatchMethod];
    } else if ([tempTitle isEqualToString:@"二维码扫描"]) {
        controller = [[XGSacnController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    } else if ([tempTitle isEqualToString:@"UISearchController测试"]) {
        controller = [[XGSearchController alloc] init];
    } else if ([tempTitle isEqualToString:@"自定义分享弹出选择平台页面"]) {
        if (!self.platformMenu) {
            self.platformMenu = [[SCSharePlatformMenu alloc] initWithShareWay:SCShareWayAll];
        }
        [self.platformMenu presentMenu:YES];
        
        return;
    }
    
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}


// 热修复方法
- (void)showJSPatchMethod {
    
}

// 扫描蓝牙失败的alert
- (void)actionForShowBLEScanFailAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"重新扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    /// 系统版本必须大于等于8.3
    if ([self compareCurrentVersionGreaterThanV83]) {
        // 此代码 可以修改按钮颜色
        [cancleAction setValue:UIColorFromHexValue(0x00AE08) forKey:@"titleTextColor"];
    }
    NSAttributedString *attributedMessage = [[NSAttributedString alloc] initWithString:@"找不到蓝牙点，可能是蓝牙出现了故障，请报事完成打点" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f], NSForegroundColorAttributeName:UIColorFromHexValue(0x334455)}];
    [alertController setValue:attributedMessage forKey:@"attributedMessage"];
    [alertController addAction:cancleAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

/// 比较当前版本是否大于8.3版本（修改UIAlertController的titleTextColor会用到）
- (BOOL)compareCurrentVersionGreaterThanV83 {
    
    NSString *currentVersion = [UIDevice currentDevice].systemVersion;
    NSArray *versionArray = [currentVersion componentsSeparatedByString:@"."];
    if (versionArray.count > 0) {
        NSInteger mainVersion = [versionArray[0] integerValue];
        if (mainVersion > 8) {
            /// 主版本大于8，直接return YES;
            return YES;
        } else if (mainVersion == 8) {
            /// 主版本等于8，判断次要版本是否大于3
            NSInteger secondVersion = [versionArray[1] integerValue];
            if (secondVersion >= 3) {
                return YES;
            }
        }
    }
    
    return NO;
}

// 选择日期的view
- (void)showDateView:(NSInteger)index {
    
    kWeakSelf
    if (index == 0) {
        // 选择日期的测试一
        XGChoseDateView *choseView = [[XGChoseDateView alloc] initWithFrame:XGScreenBounds
                                                             datePickerMode:UIDatePickerModeDate
                                                                   lastDate:self.choseDate];
        [choseView showView];
        [choseView confirmDate:^(NSDate *date) {
            weakSelf.choseDate = date;
            NSLog(@"当前选择的时间是==%@==",date);
        }];
        return;
    }
    
    // 选择日期的测试二
    XGDatePicerViewController *datePickerVC = [[XGDatePicerViewController alloc] init];
    datePickerVC.curDate = [NSDate date];
    datePickerVC.datePickerMode = UIDatePickerModeDate;
    datePickerVC.title = @"请选择";
    
    [datePickerVC choseDateFinishBlock:^(ButtonType btnType, NSDate *date) {
        NSLog(@"当前的date是====%@===", date);
        [weakSelf dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    }];
    [self presentPopupViewController:datePickerVC animationType:MJPopupViewAnimationFade];
    
}

#pragma mark - lazy load
- (MSSCalendarViewController *)calendarVC {
    if (!_calendarVC) {
        _calendarVC = [[MSSCalendarViewController alloc] init];
        _calendarVC.limitMonth = 12 * 15;// 显示几个月的日历
        _calendarVC.type = MSSCalendarViewControllerMiddleType;
        _calendarVC.beforeTodayCanTouch = YES;// 今天之后的日期是否可以点击
        _calendarVC.afterTodayCanTouch = YES;// 今天之前的日期是否可以点击
        _calendarVC.showType = MSSCalendarShowTypeIsPush; // 模态还是push
        // _calendarView.endDate = _endDate;// 选中结束时间
        /*以下两个属性设为YES,计算中国农历非常耗性能（在5s加载15年以内的数据没有影响）*/
        _calendarVC.showChineseHoliday = NO;// 是否展示农历节日
        _calendarVC.showChineseCalendar = YES;// 是否展示农历
        _calendarVC.showHolidayDifferentColor = NO;// 节假日是否显示不同的颜色
        _calendarVC.showAlertView = YES;// 是否显示提示弹窗
        _calendarVC.delegate = self;
    }
    return _calendarVC;
}
#pragma mark - 代理方法
// cell的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

// 区头和区脚的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

// cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

// cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell className] forIndexPath:indexPath];
    cell.textLabel.text = self.titleArray[indexPath.row];
    // 分割线 设置
    cell.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
    // 选中状态设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

// 选中的处理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self selectRowAction:indexPath.row];
    
}

//// 只是一个删除按钮
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}
//
//// 删除的处理
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请三思而行再删除" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self.tableView setEditing:NO animated:YES];
//    }]];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        // 先移除数据源数据
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        // 再动态刷新UITableView
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

// 必须写的方法（否则iOS 8无法删除，iOS 9及其以上不写没问题），和editActionsForRowAtIndexPath配对使用，里面什么不写也行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 添加自定义的侧滑功能
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 添加一个删除按钮
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        // 先移除数据源数据
        [self.titleArray removeObjectAtIndex:indexPath.row];
        // 再动态刷新UITableView
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"删除按钮");
    }];
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"置顶按钮");
        
    }];
    /// 设置按钮颜色，Normal默认是灰色的，Default默认是红色的
    topRowAction.backgroundColor = [UIColor orangeColor];
    
    UITableViewRowAction *cancelRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"取消关注" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"取消关注按钮");
    }];
    
    return @[deleteRowAction,topRowAction,cancelRowAction];
}

//  日历代理方法
- (void)calendarViewConfirmClickWithStartDate:(NSInteger)startDate endDate:(NSInteger)endDate {
    self.startDate = startDate;
    self.endDate = endDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.startDate]];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.endDate]];
    NSDictionary *dic = @{@"startTime":startDateString,@"endTime":endDateString};
    NSLog(@"日期的dic===%@==",dic);
}




@end
