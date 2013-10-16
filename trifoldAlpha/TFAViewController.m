//
//  TFAViewController.m
//  trifoldAlpha
//
//  Created by Adam Iredale on 16/10/13.
//  Copyright (c) 2013 Bionic Monocle. All rights reserved.
//

#import "TFAViewController.h"
#import "AFNetworking.h"
#import "TFAMovie.h"

static NSString *const kAPIKey = @"b5d26209529912e8b01d28a08ab81aea";

@interface TFAViewController ()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

@end

@implementation TFAViewController

- (void)showPoster
{
    NSData *imageData = [NSData dataWithContentsOfFile:[self posterFileUrl].path];
    UIImage *image = [[UIImage alloc] initWithData:imageData scale:[UIScreen mainScreen].scale];
    UIImageView *posterView = [[UIImageView alloc] initWithImage:image];
    [posterView setCenter:CGPointMake(self.view.frame.size.width / 2.0, 0.0)];
    [self.view addSubview:posterView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravityBeahvior = [[UIGravityBehavior alloc] init];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    
    TFAMovie *movie = [TFAMovie MR_findByAttribute:@"id" withValue:@550][0];
    
    self.itemBehavior.elasticity = movie.voteAverageValue / 10.0;
    self.itemBehavior.friction = 0.5;
    self.itemBehavior.resistance = 0.4;
    
    
    [self.animator addBehavior:self.gravityBeahvior];
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.itemBehavior];
    
    [self.gravityBeahvior addItem:posterView];
    [self.collisionBehavior addItem:posterView];
    [self.itemBehavior addItem:posterView];
    
}

- (NSURL *)posterFileUrl
{
    NSURL *path = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    return [path URLByAppendingPathComponent:@"550.jpg"];
}

- (void)downloadPosterWithConfiguration:(id)configuration
{
    NSLog(@"%@", configuration);
    // images.poster_sizes and base_url
    
    id images = configuration[@"images"];
    id posterSizes = images[@"poster_sizes"];
    id baseUrl = images[@"base_url"];
    
    TFAMovie *movie = [TFAMovie MR_findByAttribute:@"id" withValue:@550][0];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@", baseUrl, posterSizes[1], movie.posterPath]];
    NSLog(@"Downloading poster from: %@", URL);
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return [self posterFileUrl];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [self performSelectorOnMainThread:@selector(showPoster)
                               withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
    }];
    [downloadTask resume];
}

- (void)downloadPoster
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSURL *path = [self posterFileUrl];
    
    [fileMan removeItemAtURL:path error:nil];
    
    if ([fileMan fileExistsAtPath:path.path]) {
        NSLog(@"Got poster already. Skipping download.");
        [self showPoster];
        return;
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.themoviedb.org/3/configuration" parameters:@{@"api_key" : kAPIKey}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self performSelectorOnMainThread:@selector(downloadPosterWithConfiguration:)
                                    withObject:responseObject waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Configuration fetch failed: %@", error);
         }];
}

- (void)downloadMovie
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.themoviedb.org/3/movie/550" parameters:@{@"api_key" : kAPIKey}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"Downloaded");
             
             TFAMovie *movie = [TFAMovie MR_createEntity];
             movie.id = responseObject[@"id"];
             movie.posterPath = responseObject[@"poster_path"];
             movie.originalTitle = responseObject[@"original_title"];
             movie.voteAverage = responseObject[@"vote_average"];
             
             [movie.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                 if (!success) {
                     NSLog(@"Error during save: %@", error);
                     return;
                 }
                 [self performSelectorOnMainThread:@selector(downloadPoster)
                                        withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
             }];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Could also use MR_findFirstByAttribute and then delete, but this is one line (a save is required of course)
    [TFAMovie MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"id == 550"]];
    
    // If we haven't already got 550, go get it now
    NSArray *movies = [TFAMovie MR_findByAttribute:@"id" withValue:@550];
    
    if (movies.count == 0) {
        [self downloadMovie];
    } else {
        [self downloadPoster];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
