// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TFAMovie.m instead.

#import "_TFAMovie.h"

const struct TFAMovieAttributes TFAMovieAttributes = {
	.id = @"id",
	.originalTitle = @"originalTitle",
	.posterPath = @"posterPath",
	.voteAverage = @"voteAverage",
};

const struct TFAMovieRelationships TFAMovieRelationships = {
};

const struct TFAMovieFetchedProperties TFAMovieFetchedProperties = {
};

@implementation TFAMovieID
@end

@implementation _TFAMovie

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TFAMovie" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TFAMovie";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TFAMovie" inManagedObjectContext:moc_];
}

- (TFAMovieID*)objectID {
	return (TFAMovieID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"voteAverageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"voteAverage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic id;



- (int64_t)idValue {
	NSNumber *result = [self id];
	return [result longLongValue];
}

- (void)setIdValue:(int64_t)value_ {
	[self setId:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result longLongValue];
}

- (void)setPrimitiveIdValue:(int64_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithLongLong:value_]];
}





@dynamic originalTitle;






@dynamic posterPath;






@dynamic voteAverage;



- (float)voteAverageValue {
	NSNumber *result = [self voteAverage];
	return [result floatValue];
}

- (void)setVoteAverageValue:(float)value_ {
	[self setVoteAverage:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveVoteAverageValue {
	NSNumber *result = [self primitiveVoteAverage];
	return [result floatValue];
}

- (void)setPrimitiveVoteAverageValue:(float)value_ {
	[self setPrimitiveVoteAverage:[NSNumber numberWithFloat:value_]];
}










@end
