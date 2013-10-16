// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TFAMovie.h instead.

#import <CoreData/CoreData.h>


extern const struct TFAMovieAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *originalTitle;
	__unsafe_unretained NSString *posterPath;
	__unsafe_unretained NSString *voteAverage;
} TFAMovieAttributes;

extern const struct TFAMovieRelationships {
} TFAMovieRelationships;

extern const struct TFAMovieFetchedProperties {
} TFAMovieFetchedProperties;







@interface TFAMovieID : NSManagedObjectID {}
@end

@interface _TFAMovie : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TFAMovieID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int64_t idValue;
- (int64_t)idValue;
- (void)setIdValue:(int64_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* originalTitle;



//- (BOOL)validateOriginalTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* posterPath;



//- (BOOL)validatePosterPath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* voteAverage;



@property float voteAverageValue;
- (float)voteAverageValue;
- (void)setVoteAverageValue:(float)value_;

//- (BOOL)validateVoteAverage:(id*)value_ error:(NSError**)error_;






@end

@interface _TFAMovie (CoreDataGeneratedAccessors)

@end

@interface _TFAMovie (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int64_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int64_t)value_;




- (NSString*)primitiveOriginalTitle;
- (void)setPrimitiveOriginalTitle:(NSString*)value;




- (NSString*)primitivePosterPath;
- (void)setPrimitivePosterPath:(NSString*)value;




- (NSNumber*)primitiveVoteAverage;
- (void)setPrimitiveVoteAverage:(NSNumber*)value;

- (float)primitiveVoteAverageValue;
- (void)setPrimitiveVoteAverageValue:(float)value_;




@end
