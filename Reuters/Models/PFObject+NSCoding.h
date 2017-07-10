


#import "Parse.h"
@interface PFObject (NSCoding)

//Re-declare timestamp properties as read-write
@property (nonatomic, retain, readwrite) NSDate* updatedAt;
@property (nonatomic, retain, readwrite) NSDate* createdAt;

- (void)encodeWithCoder:(NSCoder*)encoder;
- (id)initWithCoder:(NSCoder*)aDecoder;

@end
