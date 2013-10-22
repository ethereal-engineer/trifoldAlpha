//
//  TFAApiClient.m
//  trifoldAlpha
//
//  Created by Adam Iredale on 21/10/13.
//  Copyright (c) 2013 Bionic Monocle. All rights reserved.
//

#import "TFAApiClient.h"
#import "AFNetworking.h"
#import "TFAApiKey.h"

/**
 *  DON'T change THIS key. This one is just a reference to see if you have replaced the one
 *  in TFAApiKey.h - see hasValidApiKey below
 */
static NSString *const kNoApiKey = @"YOUR_API_KEY_HERE";
/**
 *  Error message in case of invalid API key
 */
static NSString *const kInvalidApiKeyErrorDomain = @"*** INVALID API KEY: Please replace the API key in TFAApiKey.h with your own API key from TMDb! ***";
/**
 *  Error code for invalid API key (if handling a bunch of these, they would be done using NS_ENUM
 */
static const NSInteger kInvalidApiKeyErrorCode = -1;

@interface TFAApiClient ()
/**
 *  The TMDb configuration JSON object
 */
@property (nonatomic, strong) NSDictionary *configuration;
/**
 *  YES if the API key provided is valid
 */
@property (nonatomic, readonly) BOOL hasValidApiKey;
/**
 *  Creates and returns an error for invalid API key
 */
@property (nonatomic, readonly) NSError *invalidApiKeyError;

@end

@implementation TFAApiClient

#pragma mark - Accessors

- (NSError *)invalidApiKeyError
{
    return [NSError errorWithDomain:kInvalidApiKeyErrorDomain
                               code:kInvalidApiKeyErrorCode
                           userInfo:nil];
}

- (BOOL)hasValidApiKey
{
    return ![kApiKey isEqualToString:kNoApiKey];
}

#pragma mark - Private

/**
 *  Before the posters can be downloaded, we need to fetch the configuration from TMDb
 *  This includes information required to build the image URLs etc
 */
- (void)fetchConfigurationWithCompletionHandler:(void (^)(BOOL wasSuccessful, NSError *error))handler
{
    NSParameterAssert(handler);
    
    if (self.configuration) {
        handler(YES, nil);
        return;
    }
    __weak __block typeof(self) blockSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.themoviedb.org/3/configuration" parameters:@{@"api_key" : kApiKey}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [blockSelf setConfiguration:responseObject];
             handler(YES, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(NO, error);
         }];
}

/**
 *  Constructs the poster URL given the three required components
 *
 *  @param basePath   e.g. @"http://akamaiserver123.com/abc"
 *  @param sizePath   e.g. @"w1234"
 *  @param posterPath e.g. @"/123-gddg-1.jpg"
 *
 *  @return The URL to the movie poster
 */
- (NSURL *)posterUrlWithBasePath:(NSString *)basePath sizePath:(NSString *)sizePath andPosterPath:(NSString *)posterPath
{
    NSParameterAssert(basePath.length > 0);
    NSParameterAssert(sizePath.length > 0);
    NSParameterAssert(posterPath.length > 0);
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@", basePath, sizePath, posterPath]];
}

/**
 *  Figure out where we will be storing the poster file locally (always the same for a given poster of
 *  a given size).
 *
 *  @param posterPath Movie object poster path argument
 *  @param sizePath   Chosen size for the movie poster
 *
 *  @return A local file URL for the movie poster
 */
- (NSURL *)posterFileUrlWithPosterPath:(NSString *)posterPath andSizePath:(NSString *)sizePath
{
    // NOTE: When using threads, it's best to create an instance of NSFileManager - we aren't here, though
    NSArray *directories = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask];
    NSURL *documentsUrl = [directories firstObject];
    documentsUrl = [documentsUrl URLByAppendingPathComponent:sizePath];
    return [documentsUrl URLByAppendingPathComponent:posterPath];
}

/**
 *  Having assured that we have the configuration, we can now build the poster path and fetch it
 *
 *  @param path    Poster name/path argument
 *  @param config  Pre-fetched configuration
 *  @param handler Call this when done, either way
 */
- (void)fetchPosterWithPath:(NSString *)path configuration:(NSDictionary *)config andCompletionHandler:(void (^)(NSURL *localUrl, NSError *error))handler
{
    NSParameterAssert(path);
    NSParameterAssert(config);
    NSParameterAssert(handler);
    
    // The v3 configuration of TMDb has an "images" dictionary
    // which contains the "base_url" and an array of valid "poster_sizes"
    NSDictionary *imagesConfig  = config[@"images"];
    NSArray *posterSizes        = imagesConfig[@"poster_sizes"];
    
    // For the purposes of the demo, we will choose the first (smallest) poster size
    // Note the use of the newly non-private API "firstObject" call
    NSString *chosenSize = [posterSizes firstObject];
    NSString *basePath   = imagesConfig[@"base_url"];
    
    // If we have this file already, skip the download - otherwise, this is where it WILL be
    NSURL *fileUrl = [self posterFileUrlWithPosterPath:path andSizePath:chosenSize];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileUrl.path]) {
        handler(fileUrl, nil);
        return;
    } else {
        // Make sure the directory exists at least
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtURL:[fileUrl URLByDeletingLastPathComponent]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error]) {
            handler(nil, error);
            return;
        }
    }
    
    // In production code, I'd suggest more error checking on the inputs before going onward here
    NSURL *url = [self posterUrlWithBasePath:basePath sizePath:chosenSize andPosterPath:path];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *sconfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sconfig];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return fileUrl;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        handler(filePath, error);
    }];
    [downloadTask resume];
}

#pragma mark - Public

- (void)fetchMovieWithId:(NSNumber *)movieId andCompletionHandler:(void (^)(id object, NSError *error))handler
{
    NSParameterAssert(handler);
    
    if (!self.hasValidApiKey) {
        handler(nil, self.invalidApiKeyError);
        return;
    }
    
    NSString *movieRequest = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@", movieId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:movieRequest parameters:@{@"api_key" : kApiKey}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             handler(responseObject, nil);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             handler(nil, error);
         }];
}

- (void)fetchPosterWithPath:(NSString *)path andCompletionHandler:(void (^)(NSURL *localUrl, NSError *error))handler
{
    NSParameterAssert(handler);
    
    if (!self.hasValidApiKey) {
        handler(nil, self.invalidApiKeyError);
        return;
    }
    
    __weak __block typeof(self) blockSelf = self;
    [self fetchConfigurationWithCompletionHandler:^(BOOL wasSuccessful, NSError *error) {
        if (wasSuccessful) {
            [blockSelf fetchPosterWithPath:path
                             configuration:blockSelf.configuration
                      andCompletionHandler:handler];
        } else {
            handler(nil, error);
        }
    }];
}

#pragma mark - Class Methods

+ (TFAApiClient *)sharedInstance
{
    static TFAApiClient *apiClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        apiClient = [[TFAApiClient alloc] init];
    });
    return apiClient;
}

@end
