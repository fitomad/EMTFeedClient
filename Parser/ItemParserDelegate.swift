//
//  ItemParserDelegate.swift
//  EMTFeed
//
//  Created by Adolfo on 03/2/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

///
/// 
///
internal protocol ItemParserDelegate: class
{
	/**
		Informa que se ha encontrado un incidencia durante
		la operacion de lectura y parseo del feed

		- Parameters:
			- incident: El objeto con la informacion
			- fromItemParser: El parser responsable de la operacion
	*/
	func incident(incident: Incident, fromItemParser parser: ItemParser) -> Void

	/**
		Informa que ha terminado de leer una seccion *item*
		del documento Xml

		- Parameter parser: El parser responsable de la operacion
	*/
	func parseFinishedFromItemParser(parser: ItemParser) -> Void
}