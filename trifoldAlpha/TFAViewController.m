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
#import "TFAApiClient.h"
#import "TFAApiKey.h"

@interface TFAViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBeahvior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;

@end

@implementation TFAViewController

- (void)showPoster:(NSURL *)fileUrl
{
    NSData *imageData = [NSData dataWithContentsOfFile:fileUrl.path];
    UIImage *image = [[UIImage alloc] initWithData:imageData scale:[UIScreen mainScreen].scale];
    UIImageView *posterView = [[UIImageView alloc] initWithImage:image];
    [posterView setCenter:CGPointMake(self.view.frame.size.width / 2.0, 0.0)];
    [self.view addSubview:posterView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravityBeahvior = [[UIGravityBehavior alloc] init];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:nil];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:nil];
    
    TFAMovie *movie = [[TFAMovie MR_findAll] firstObject];
    
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

- (void)downloadPoster
{
    TFAMovie *movie = [[TFAMovie MR_findAll] firstObject];
    
    [[TFAApiClient sharedInstance] fetchPosterWithPath:movie.posterPath
                                  andCompletionHandler:^(NSURL *localUrl, NSError *error) {
                                      if (localUrl) {
                                          [self performSelectorOnMainThread:@selector(showPoster:)
                                                                 withObject:localUrl
                                                              waitUntilDone:NO
                                                                      modes:@[NSDefaultRunLoopMode]];
                                      } else {
                                          NSLog(@"Error downloading poster: %@", error);
                                      }
                                  }];
}

- (void)downloadMovieWithId:(NSNumber *)movieId
{
    [[TFAApiClient sharedInstance] fetchMovieWithId:movieId
                               andCompletionHandler:^(id object, NSError *error) {
                                   if (object) {
                                       TFAMovie *movie = [TFAMovie MR_createEntity];
                                       movie.id = object[@"id"];
                                       movie.posterPath = object[@"poster_path"];
                                       movie.originalTitle = object[@"original_title"];
                                       movie.voteAverage = object[@"vote_average"];
                                       
                                       [movie.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
                                           if (!success) {
                                               NSLog(@"Error during save: %@", error);
                                               return;
                                           }
                                           [self performSelectorOnMainThread:@selector(downloadPoster)
                                                                  withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
                                       }];
                                   } else {
                                       NSLog(@"Error fetching movie: %@", error);
                                   }
                               }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment this line to delete the movie from the database
    //[TFAMovie MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"id == 550"]];
    
    NSNumber *movieId = @550;
    NSArray *movies = [TFAMovie MR_findByAttribute:@"id" withValue:movieId];
    
    if (!movies.count) {
        [self downloadMovieWithId:movieId];
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
