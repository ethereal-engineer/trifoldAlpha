// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Movie.h instead.

#import <CoreData/CoreData.h>


extern const struct MovieAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *originalTitle;
	__unsafe_unretained NSString *posterPath;
	__unsafe_unretained NSString *voteAverage;
} MovieAttributes;

extern const struct MovieRelationships {
} MovieRelationships;

extern const struct MovieFetchedProperties {
} MovieFetchedProperties;







@interface MovieID : NSManagedObjectID {}
@end

@interface _Movie : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MovieID*)objectID;





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

@interface _Movie (CoreDataGeneratedAccessors)

@end

@interface _Movie (CoreDataGeneratedPrimitiveAccessors)


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
