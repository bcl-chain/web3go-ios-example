// Objective-C API for talking to  Go package.
//   gobind -lang=objc 
//
// File is generated by gobind. Do not edit.

#ifndef __Universe_H__
#define __Universe_H__

@import Foundation;
#include "ref.h"

@protocol Universeerror;
@class Universeerror;

@protocol Universeerror <NSObject>
- (NSString*)error;
@end

@class Universeerror;

@interface Universeerror : NSError <goSeqRefInterface, Universeerror> {
}
@property(strong, readonly) id _ref;

- (instancetype)initWithRef:(id)ref;
- (NSString*)error;
@end

#endif
