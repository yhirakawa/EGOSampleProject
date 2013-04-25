//
//  EGOSampleViewController.m
//  EGOSampleProject
//
//  Created by hirakawa on 2013/04/18.
//  Copyright (c) 2013年 yhirakawa. All rights reserved.
//

#import "EGOSampleViewController.h"

@implementation EGOSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _cell_string = @"Before";
    
	if (_refreshHeaderView == nil) {
        // 更新ビューのサイズとデリゲートを指定する
		EGORefreshTableHeaderView *view =
        [[EGORefreshTableHeaderView alloc] initWithFrame:
         CGRectMake(
                    0.0f,
                    0.0f - self.tableView.bounds.size.height,
                    self.view.frame.size.width,
                    self.tableView.bounds.size.height
                    )];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
    // 最終更新日付を記録
	[_refreshHeaderView refreshLastUpdatedDate];
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// テーブルのセル表示処理
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 表示されるセルのテキストを設定
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %d", _cell_string, indexPath.row];
    // Update後だったら文字色を変更
    if ([_cell_string isEqualToString:@"Update"]) {
        cell.textLabel.textColor = [UIColor brownColor];
    }
    
    return cell;
}

// スクロールされた事をライブラリに伝える
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

// 下に引っ張ったらここが呼ばれる、テーブルデータをリロードして三秒後にdoneLoadingTableViewDataを呼んでいる
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	_reloading = YES;
    // 非同期処理
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        // 更新処理等重い処理を書く
        // 今回は3秒待ち、_cell_stringをUpdateに変更
        [NSThread sleepForTimeInterval:3];
        _cell_string = @"Update";
        [self.tableView reloadData];
        
        // メインスレッドで更新完了処理
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self doneLoadingTableViewData];
        }];
    }];
}

// 更新終了
- (void)doneLoadingTableViewData{
	// 更新終了をライブラリに通知
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

// 更新状態を返す
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading;
}

// 最終更新日を更新する際の日付の設定
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date];
}

@end
