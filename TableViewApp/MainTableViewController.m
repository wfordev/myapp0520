//
//  MainTableViewController.m
//  myapp0520
//
//  Created by 渡部 可鈴 on 2018/05/20.
//  Copyright © 2018年 watabe. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.repos = [NSMutableArray new];
    self.targetUrlStr = @"";
    
    [self getList];
}
-(void)getList{
    NSString* urlString = @"https://api.github.com/search/repositories?q=created:2018+language:Swift+stars:>300&sort=stars&order=desc";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
//                                                          delegate:self
//                                                     delegateQueue:[NSOperationQueue currentQueue]];
    [[session dataTaskWithRequest: request  completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
        NSInteger statusCode = [httpRes statusCode];
        if(error){
            NSLog(@"NSURLSessionError: %@", error);
        }else{
            if (statusCode != 200) {
                NSLog(@"statusCodeError: %ld", (long)statusCode);
            }else{
                NSError* dataError = nil;
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData: data  options: NSJSONReadingAllowFragments  error:&dataError];
                if (dataError) {
                    NSLog(@"castError");
                }else{
                    if (responseData) {
                        if ([responseData isKindOfClass: [NSNull class]]) {
                            NSLog(@"json_null");
                        }else{
                            NSNumber *count = responseData[@"total_count"];
                            if (count > 0) {
                                NSArray *repos = responseData[@"items"];
                                self.repos = [repos mutableCopy];
                                [self.tableView reloadData];
                            }else{
                                NSLog(@"no_topics");
                            }
                        }
                    }else{
                        NSLog(@"not_json");
                    }
                }
            }
        }
    }] resume];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    NSDictionary *dict = self.repos[indexPath.row];
    UILabel *repoName = [cell.contentView viewWithTag:1];
    repoName.text = dict[@"name"];
    UILabel *created = [cell.contentView viewWithTag:2];
    created.text = dict[@"created_at"];
    UILabel *stars = [cell.contentView viewWithTag:3];
    NSNumber *starCount = dict[@"stargazers_count"];
    stars.text = [NSString stringWithFormat:@"%@", starCount];
    UILabel *desc = [cell.contentView viewWithTag:4];
    desc.text =dict[@"description"];
 
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.repos[indexPath.row];
    self.targetUrlStr = dict[@"html_url"];
    [self performSegueWithIdentifier:@"toDetail" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toDetail"]) {
        ViewController *detailView = segue.destinationViewController;
        detailView.urlString = self.targetUrlStr;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark - URLSession_authenticationChallenge
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"didReceiveAuthenticationChallenge");
}
-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"willSendRequestForAuthenticationChallenge");
}
-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSString* authMethod = challenge.protectionSpace.authenticationMethod;
    if ([authMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;
        if (secTrustRef) {
            SecTrustResultType result;
            OSErr err = SecTrustEvaluate(secTrustRef, &result);
            if (err != noErr) {
                completionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
                return;
            }
            NSURLCredential* credential = [NSURLCredential credentialForTrust:secTrustRef];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
