//
//  YouTubePlugin.m
//  YouTube Plugin
//
//  Created by Vincenzo Luca Mantova on 23/04/09.
//  Copyright 2009 Vincenzo Luca Mantova.
//
//  This file is part of YouTube Plugin.
//
//  YouTube Plugin is free software: you can redistribute it and/or modify
//  it undel the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  YouTube Plugin is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with YouTube Plugin.  If not, see <http://www.gnu.org/licenses/>.
//

#import "YouTubePlugin.h"
#import "YouTubePluginPreferences.h"
#import <AIUtilities/AIDictionaryAdditions.h>
#import <Adium/ESDebugAILog.h>
#import <Adium/AIContentMessage.h>

@implementation YouTubePlugin {
//	AIPreferencePane *YouTubePluginPrefs;

//	NSUInteger blockId;
//	NSCharacterSet *videoIdChars;

//	NSString *blockHTML;
//	NSString *ytThumbHTML;
}

- (NSString *)pluginAuthor
{
	return @"Vincenzo Mantova";
}

- (NSString *)pluginVersion
{
	return @"0.3devel";
}

- (NSString *)pluginDescription
{
	return @"This plugin shows youtube videos right inside the chat window.";
}

- (NSString *)pluginURL
{
	return @"http://adiumxtras.com/index.php?a=xtras&xtra_id=6655";
}

- (void)installPlugin
{
	blockId = 0;
	videoIdChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"]
					retain];
	YouTubePluginPrefs = [[YouTubePluginPreferences preferencePaneForPlugin:self] retain];
	NSDictionary *defaults = [NSDictionary dictionaryNamed:@"YouTubePluginDefaults"
												  forClass:[self class]];
	
	if (defaults) {
		[[adium preferenceController] registerDefaults:defaults
											  forGroup:PREF_GROUP_YOUTUBE];
	} else {
		AILog(@"YTP: Failed to load defaults.");
	}
	
	NSString* blockHTMLName = [[NSBundle bundleForClass:[self class]] pathForResource:@"block" ofType:@"html"];
	NSString* ytThumbHTMLName = [[NSBundle bundleForClass:[self class]] pathForResource:@"youtube_thumb" ofType:@"html"];
	
	blockHTML = [[NSString stringWithContentsOfFile:blockHTMLName usedEncoding:nil error:nil] retain];
	ytThumbHTML = [[NSString stringWithContentsOfFile:ytThumbHTMLName usedEncoding:nil error:nil] retain];

	if (!blockHTML || !ytThumbHTML) {
		AILog(@"YTP: Failed to load html code.");
	}
	
	[[adium contentController] registerHTMLContentFilter:self direction:AIFilterOutgoing];
	[[adium contentController] registerHTMLContentFilter:self direction:AIFilterIncoming];
}

- (void)uninstallPlugin
{
	[blockHTML release];
	[ytThumbHTML release];
	[videoIdChars release];
	[YouTubePluginPrefs release];
  	[[adium contentController] unregisterHTMLContentFilter:self];
}

- (NSString *)filterHTMLString:(NSString *)inHTMLString content:(AIContentObject *)content
{
	if ([[[adium preferenceController] preferenceForKey:KEY_YOUTUBE_ENABLED
												  group:PREF_GROUP_YOUTUBE] boolValue]) {
		NSUInteger border = [[[adium preferenceController] preferenceForKey:KEY_DISPLAY_BORDER group:PREF_GROUP_YOUTUBE] integerValue];
		NSUInteger width = [[[adium preferenceController] preferenceForKey:KEY_WIDTH group:PREF_GROUP_YOUTUBE] integerValue] + border * 20;
		NSUInteger height = width * 3 / 4 + border * 20;
		NSScanner *scanner = [[NSScanner alloc] initWithString:inHTMLString];
		NSString *videoId;
		NSMutableString *newMessage = [[[NSMutableString alloc] initWithString:inHTMLString] autorelease];
		NSUInteger thumbId = 0;
		[scanner scanUpToString:@"href=\"http://www.youtube.com/watch?v=" intoString:NULL];
		if (![scanner isAtEnd]) {
			NSMutableString *block = [[NSMutableString alloc] initWithString:blockHTML];
			NSMutableString *thumbs = [[NSMutableString alloc] init];
			NSUInteger thumbsPos;
			do  {
				if ([scanner scanString:@"href=\"http://www.youtube.com/watch?v=" intoString:NULL] &&
					[scanner scanCharactersFromSet:videoIdChars intoString:&videoId]) {
					thumbsPos = [thumbs length];
					[thumbs appendString:ytThumbHTML];
					[thumbs replaceOccurrencesOfString:@"{%blockId%}" withString:[NSString stringWithFormat:@"%lu", blockId]
											   options:NSLiteralSearch range:NSMakeRange(thumbsPos, [thumbs length] - thumbsPos)];
					[thumbs replaceOccurrencesOfString:@"{%videoId%}" withString:videoId
											   options:NSLiteralSearch range:NSMakeRange(thumbsPos, [thumbs length] - thumbsPos)];
					[thumbs replaceOccurrencesOfString:@"{%border%}" withString:[NSString stringWithFormat:@"%lu", border]
											   options:NSLiteralSearch range:NSMakeRange(thumbsPos, [thumbs length] - thumbsPos)];
					[thumbs replaceOccurrencesOfString:@"{%width%}" withString:[NSString stringWithFormat:@"%lu", width]
											   options:NSLiteralSearch range:NSMakeRange(thumbsPos, [thumbs length] - thumbsPos)];
					[thumbs replaceOccurrencesOfString:@"{%height%}" withString:[NSString stringWithFormat:@"%lu", height]
											   options:NSLiteralSearch range:NSMakeRange(thumbsPos, [thumbs length] - thumbsPos)];
					[thumbs replaceOccurrencesOfString:@"{%thumbId%}" withString:[NSString stringWithFormat:@"%lu", thumbId]
											   options:NSLiteralSearch range:NSMakeRange(thumbsPos, [thumbs length] - thumbsPos)];
					++thumbId;
				}
			} while ([scanner scanUpToString:@"href=\"http://www.youtube.com/watch?v=" intoString:NULL]);
			[block replaceOccurrencesOfString:@"{%thumbs%}" withString:thumbs options:NSLiteralSearch range:NSMakeRange(0, [block length])];
			[block replaceOccurrencesOfString:@"{%blockId%}" withString:[NSString stringWithFormat:@"%lu", blockId]
									  options:NSLiteralSearch range:NSMakeRange(0, [block length])];
			[newMessage appendString:block];
			++blockId;
			[block release];
			[thumbs release];
		}
		[scanner release];
		return newMessage;
	} else {
		return inHTMLString;
	}
}

- (float)filterPriority
{
	return LOW_FILTER_PRIORITY;	// We must be processed _after_ linkify
}

@end
