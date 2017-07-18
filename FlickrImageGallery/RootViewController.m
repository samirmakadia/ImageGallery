//
//  RootViewController.m
//  FlickrImageGallery
//
//  Created by ABC on 7/18/17.
//  Copyright © 2017 Creative Infoway. All rights reserved.
//

#import "RootViewController.h"
#import "WCClasses.h"
#import "ImageCell.h"
#import "const.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataTable.hidden=YES;
    
    [self getDataWithParam:@""];
    
}
// Refresh button method
-(IBAction)refreshBtnClicked:(id)sender
{
     [self getDataWithParam:imageSearchBar.text];
}
// Sorting button method
-(IBAction)sortBtnClicked:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Sorting by" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Order by date taken ascending" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:kDate
                                            ascending:YES];
        dataArray = [dataArray
                           sortedArrayUsingDescriptors:@[dateDescriptor]];
       [dataTable reloadData];
        
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Order by date taken descending" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:kDate
                                            ascending:NO];
        dataArray = [dataArray
                     sortedArrayUsingDescriptors:@[dateDescriptor]];
        [dataTable reloadData];
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Order by publish ascending" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:kPublished
                                            ascending:YES];
        dataArray = [dataArray
                           sortedArrayUsingDescriptors:@[dateDescriptor]];
        [dataTable reloadData];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Order by publish descending" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:kPublished
                                            ascending:NO];
        dataArray = [dataArray
                     sortedArrayUsingDescriptors:@[dateDescriptor]];
        [dataTable reloadData];
        
    }]];
    
    
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
   
}
// Get data from feed
-(void) getDataWithParam : (NSString *)param
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WCClasses loadFeedByTag:param complete:^(NSArray *data){
        dataTable.hidden=NO;
        dataArray = [NSArray arrayWithArray:data];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [dataTable reloadData];
        
    }fail:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cell";
    
    ImageCell *cell = [tableView1 dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *dict=[dataArray objectAtIndex:indexPath.row];
   
    float height = [self getHeightForText:[dict objectForKey:kTitle]];
   
    cell.mainImg.frame=CGRectMake(15*WidthTriangle, 15, 290*WidthTriangle, 150*WidthTriangle);
    cell.titleLbl.frame=CGRectMake(15*WidthTriangle, 170*WidthTriangle, 290*WidthTriangle, height);
    cell.autherNameLbl.frame=CGRectMake(15*WidthTriangle, cell.titleLbl.frame.origin.y+height+5, 290*WidthTriangle, 21);
    cell.dateLbl.frame=CGRectMake(15*WidthTriangle, cell.autherNameLbl.frame.origin.y+21, 290*WidthTriangle, 21);
    
    cell.titleLbl.font=[UIFont fontWithName:@"SFUIDisplay-Bold" size:11*WidthTriangle];
    cell.autherNameLbl.font=[UIFont fontWithName:@"SFUIDisplay-Regular" size:10*WidthTriangle];
    cell.dateLbl.font=[UIFont fontWithName:@"SFUIDisplay-Regular" size:9*WidthTriangle];
    
    
    NSURL *imageURL = [NSURL URLWithString:[[dict objectForKey:kMedia] objectForKey:@"m"]];
    [cell.mainImg sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@""]];
    cell.titleLbl.text=[dict objectForKey:kTitle];
    cell.autherNameLbl.text=[NSString stringWithFormat:@"By %@",[dict objectForKey:kAuthor]];
    
    
    cell.dateLbl.text= [NSString stringWithFormat:@"Publish at: %@ • Taken at: %@",[self getFormattedDate:[dict objectForKey:kPublished]], [self getFormattedDate:[dict objectForKey:kDate]]];
    
    cell.moreBtn.tag=  indexPath.row;
    [cell.moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=[dataArray objectAtIndex:indexPath.row];
    float height = [self getHeightForText:[dict objectForKey:kTitle]];
    return (150*WidthTriangle)+height+65*WidthTriangle;
}
// Get height for Title
- (float)getHeightForText:(NSString *)text
{
    CGSize constrainedSize = CGSizeMake(290*WidthTriangle  , 9999);
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"SFUIDisplay-Bold" size:11*WidthTriangle], NSFontAttributeName,
                                          nil];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return requiredHeight.size.height;
}
-(void)moreBtnClicked:(UIButton *) btn
{
    NSDictionary *dict=[dataArray objectAtIndex:btn.tag];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Gallary" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Share in mail" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"Image"];
            
            [mailCont setMessageBody:@"Hi," isHTML:NO];
            [mailCont addAttachmentData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[dict objectForKey:kMedia] objectForKey:@"m"]]] mimeType:@"image/jpeg" fileName:@"image"];
            
            [self presentViewController:mailCont animated:YES completion:nil];
            
        }
        
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open in browser" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[dict valueForKey:kLink]]];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Save to gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[dict objectForKey:kMedia] objectForKey:@"m"]]];
        UIImage *image = [UIImage imageWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Gallery" message:@"Image save successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}
// Get formatted date
-(NSString *)getFormattedDate:(NSString *)dateStr
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date  = [dateFormatter dateFromString:dateStr];
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}


// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Search bar search button method
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self getDataWithParam:searchBar.text];
    [searchBar resignFirstResponder];
}
// Search bar cancel button method
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text=@"";
    [self getDataWithParam:searchBar.text];
    [searchBar resignFirstResponder];
}

@end
