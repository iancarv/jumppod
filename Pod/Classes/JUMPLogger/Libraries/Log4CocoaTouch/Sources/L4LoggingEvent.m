/**
 * For copyright & license, see COPYRIGHT.txt.
 */

#import "NSDate-Calendar.h"
#import "L4LoggingEvent.h"
#import "L4Logger.h"

static int   NO_LINE_NUMBER = -1;
static char *NO_FILE_NAME   = "";
static char *NO_METHOD_NAME = "";

static NSDate *startTime = nil;

@implementation L4LoggingEvent

+ (void) initialize
{
	startTime = [NSDate calendarDate];
}

+ (NSDate *) startTime
{
	return startTime;
}

+ (L4LoggingEvent *) logger: (L4Logger *) aLogger
					  level: (L4Level *) aLevel
					message: (id) aMessage
{
	return [self logger: aLogger
				  level: aLevel
			 lineNumber: NO_LINE_NUMBER
			   fileName: NO_FILE_NAME
			 methodName: NO_METHOD_NAME
				message: aMessage
			  exception: nil];
}

+ (L4LoggingEvent *) logger: (L4Logger *) aLogger
					  level: (L4Level *) aLevel
					message: (id) aMessage
				  exception: (NSException *) e;
{
	return [self logger: aLogger
				  level: aLevel
			 lineNumber: NO_LINE_NUMBER
			   fileName: NO_FILE_NAME
			 methodName: NO_METHOD_NAME
				message: aMessage
			  exception: e];
}

+ (L4LoggingEvent *) logger: (L4Logger *) aLogger
					  level: (L4Level *) aLevel
				 lineNumber: (int) aLineNumber
				   fileName: (char *) aFileName
				 methodName: (char *) aMethodName
					message: (id) aMessage
				  exception: (NSException *) e
{
	return [[L4LoggingEvent alloc] initWithLogger: aLogger
											 level: aLevel
										lineNumber: aLineNumber
										  fileName: aFileName
										methodName: aMethodName
										   message: aMessage
										 exception: e
									eventTimestamp: [NSDate calendarDate]];
}

- (id) init
{
	return nil;
}

- (id) initWithLogger: (L4Logger *) aLogger
				level: (L4Level *) aLevel
		   lineNumber: (int) aLineNumber
			 fileName: (char *) aFileName
		   methodName: (char *) aMethodName
			  message: (id) aMessage
			exception: (NSException *) e
	   eventTimestamp: (NSDate *) aDate
{
	self = [super init];
	if( self != nil )
	{
		rawFileName = aFileName;
		rawMethodName = aMethodName;
		rawLineNumber = aLineNumber;
		
		lineNumber = nil;
		fileName = nil;
		methodName = nil;
		
		logger = aLogger;
		level = aLevel;
		message = aMessage;
		exception = e;
		timestamp = aDate;
	}
	return self;
}


- (L4Logger *) logger
{
	return logger;
}

- (L4Level *) level
{
	return level;
}

- (NSNumber *) lineNumber
{
	if((lineNumber == nil) && (rawLineNumber != NO_LINE_NUMBER)) {
		lineNumber = [NSNumber numberWithInt: rawLineNumber];
	} else if (rawLineNumber == NO_LINE_NUMBER) {
		lineNumber = [NSNumber numberWithInt: NO_LINE_NUMBER];
	}
	return lineNumber;
}

- (NSString *) fileName
{
	if((fileName == nil) && (rawFileName != NO_FILE_NAME)) {
		fileName = [NSString stringWithCString: rawFileName encoding: NSUTF8StringEncoding];
	} else if (rawFileName == NO_FILE_NAME) {
		fileName = @"No file name!";
	}
	return fileName;
}

- (NSString *) methodName
{
	if((methodName == nil) && (rawMethodName != NO_METHOD_NAME)) {
		methodName = [NSString stringWithCString: rawMethodName encoding: NSUTF8StringEncoding];
	} else if (rawMethodName == NO_METHOD_NAME) {
		methodName = @"No method name!";
	}
	return methodName;
}

- (NSDate *) timestamp
{
	return timestamp;
}

- (NSException *) exception
{
	return exception;
}

- (long) millisSinceStart
{
	// its a double in seconds
	NSTimeInterval time = [timestamp timeIntervalSinceDate: startTime];
	return (long) (time * 1000);
}

- (id) message
{
	return message;
}

- (NSString *) renderedMessage	
{
	if( renderedMessage == nil && message != nil ) {
		if([message isKindOfClass: [NSString class]]) {
			renderedMessage = message;  // if its a string return it.
		} else {
			renderedMessage = [message description];
		}
	}
	
	return renderedMessage;
}
	
@end
