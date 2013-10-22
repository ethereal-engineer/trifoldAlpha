//
//  TFAApiClient.h
//  trifoldAlpha
//
//  Created by Adam Iredale on 21/10/13.
//  Copyright (c) 2013 Bionic Monocle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFAApiClient : NSObject

/**
 *  Return the JSON object or error
 *
 *  @param movieId Movie database identifier
 *  @param object The returned JSON object
 *  @param error If the return value is nil, this will be the reason why
 */
- (void)fetchMovieWithId:(NSNumber *)movieId andCompletionHandler:(void (^)(id object, NSError *error))handler;

/**
 *  Given a movie poster path (e.g. /234123kjhsfdds.jpg) from the movie information 
 *  obtained from fetchMovieWithId:andCompletionHandler, download the poster to a local file
 *  and return the path to the local file. If the file already exists, no download will occur.
 *
 *  @param path    Path information from movie object
 *  @param handler Returns the local url to the downloaded file or nil and an error
 */
- (void)fetchPosterWithPath:(NSString *)path andCompletionHandler:(void (^)(NSURL *localUrl, NSError *error))handler;

/**
 *  Standard shared instance call
 *
 *  @return The shared instance of TFAApiClient
 */
+ (TFAApiClient *)sharedInstance;

@end
