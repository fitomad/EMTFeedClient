//
//  ParseError.swift
//  EMTFeed
//
//  Created by Adolfo on 18/2/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

internal enum ParseError: ErrorType
{
	/// Fallo en el parseo
	case Failure(reason: String)
	/// El error se ha producido durante el parseo
	/// de un elemento en concreto
	case WrongContent(line: Int, column: Int, reason: String)
}