//
//  EMTFeed.swift
//  EMTFeed
//
//  Created by Adolfo on 13/5/15.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

public class EMTFeed
{
	///
	public internal(set) var title: String!
	///
	public internal(set) var feedDescription: String!
	///
	public internal(set) var lastBuild: NSDate!
	///
	public internal(set) var ttl: Int!
	///
	public internal(set) var incidents: [Incident]?

	/**

	*/
	internal init()
	{
	    self.title = String()
	    self.feedDescription = String()
	}
}

//
// MARK: - Equatable Protocol
//

extension EMTFeed: Equatable {}

public func ==(lhs: EMTFeed, rhs: EMTFeed) -> Bool
{
    return lhs.title == rhs.title
}

//
// MARK: - Comparable Protocol
//

extension EMTFeed: Comparable {}

/**

*/
public func <(lhs: EMTFeed, rhs: EMTFeed) -> Bool
{
	return lhs.lastBuild.timeIntervalSince1970 < rhs.lastBuild.timeIntervalSince1970
}

/**

*/
public func <(lhs: EMTFeed, rhs: NSDate) -> Bool
{
	return lhs.lastBuild.timeIntervalSince1970 < rhs.timeIntervalSince1970
}