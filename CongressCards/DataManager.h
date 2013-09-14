//
//  DataManager.h
//  Congress
//
//  Created by Christopher Febles on 2/21/13.
//  Copyright © 2013 Christopher Febles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(NSArray *) loadSenatorsFromXML;
+(NSArray *) loadRepresentativesFromXML;

@end
