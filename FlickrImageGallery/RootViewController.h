//
//  RootViewController.h
//  FlickrImageGallery
//
//  Created by ABC on 7/18/17.
//  Copyright © 2017 Creative Infoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface RootViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView *dataTable;
    NSArray *dataArray;
    IBOutlet UISearchBar *imageSearchBar;
    IBOutlet UIBarButtonItem *refreshBtn;
    IBOutlet UIBarButtonItem *sortBtn;
}
-(IBAction)refreshBtnClicked:(id)sender;
-(IBAction)sortBtnClicked:(id)sender;
@end
