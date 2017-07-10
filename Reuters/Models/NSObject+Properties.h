

#import <Foundation/Foundation.h>

@interface NSObject (Properties)

- (NSDictionary *)properties;
- (NSDictionary *)dynamicProperties;
- (NSDictionary *)nonDynamicProperties;
- (void)encodeProperties:(NSDictionary*)properties withCoder:(NSCoder *)coder;
- (void)decodeProperties:(NSDictionary*)properties withCoder:(NSCoder *)coder;

@end
