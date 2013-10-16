// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Movie.m instead.

#import "_Movie.h"

const struct MovieAttributes MovieAttributes = {
	.id = @"id",
	.originalTitle = @"originalTitle",
	.posterPath = @"posterPath",
	.voteAverage = @"voteAverage",
};

const struct MovieRelationships MovieRelationships = {
};

const struct MovieFetchedProperties MovieFetchedProperties = {
};

@implementation MovieID
@end

@implementation _Movie

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Movie";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Movie" inManagedObjectContext:moc_];
}

- (MovieID*)objectID {
	return (MovieID*)[super objectID];
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
