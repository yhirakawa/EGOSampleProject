//
//  EGOSampleViewController.h
//  EGOSampleProject
//
//  Created by hirakawa on 2013/04/18.
//  Copyright (c) 2013年 yhirakawa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface EGOSampleViewController : UITableViewController
<
    EGORefreshTableHeaderDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>
{
    // 更新中を表示するViwe
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    // Cellの文字列、更新時に変更
    NSString *_cell_string;
}

@end
