//
//  EMTFeedParser.swift
//  EMTFeed
//
//  Created by Adolfo on 13/5/15.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

internal class EMTFeedParser: NSObject
{
	/**
		Elementos que conforman el channel del feed
	*/
	private enum FeedTag: String
	{
		case Title = "title"
		case Description = "description"
		case LastBuild = "lastBuildDate"
		case TTL = "ttl"
		case Channel = "channel"
		case Item = "item"
	}

	/// Parser.
	private var parser: NSXMLParser!
	/// Referencia al objecto que tiene
	/// el control de la operacion de lectura 
	private var otherDelegate: NSXMLParserDelegate?
	/// Elemento del feed que se esta procesando actualmente
    private var actualElement: String!

    /// Objeto principal
	private var feed: EMTFeed?
	/// Las incidencias encontradas
	private var incidents: [Incident]?
    
    /**
		Nos preparamos para parsear el documento
    */
    override internal init()
    {
        self.actualElement = String()
    }

	/**
		Convierte el contenido del feed de incidencias 
		en una estructura de datos.

		- parameter data: Stream con el contenido recuperado del HTTP Request
		- returns: Una estructura de datos con la informacion del feed
		- Throws ParseError: Se ha producido un error durante el parseo
	*/
	internal func incidentWithData(data: NSData) throws -> EMTFeed?
	{
		self.parser = NSXMLParser(data: data)
		self.parser.delegate = self

		self.actualElement = String()

		self.feed = EMTFeed()
		self.incidents = [Incident]()

		self.parser.parse()

		return self.feed
	}
}

//
// MARK: - NSXMLParserDelegate Protocol
//

extension EMTFeedParser: NSXMLParserDelegate
{
	/**
		Comienza un elemento...
	*/
	func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
	{
        if let elemento = FeedTag(rawValue: elementName)
        {
            switch(elemento)
            {
                case FeedTag.Item:
                    // Preparamos para parsear
                    let itemParser: ItemParser = ItemParser()
                    itemParser.delegate = self
                    // Ahora el parseo lo lleva Item
                    self.parser.delegate = itemParser
                    // Asi no perdemos la referencia
                    self.otherDelegate = itemParser
                default:
                    self.actualElement = elementName;
            }
        }
	}

	/**
		...y aqui termina el elemento
	*/
	func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI namespaceURI: String?, qualifiedName qName: String?)
	{
		if elementName == FeedTag.Channel.rawValue
		{
			self.feed?.incidents = self.incidents
			//self.parser.abortParsing()
		}
	}

	/**
		Contenido de un elemento
	*/
	func parser(parser: NSXMLParser, foundCharacters string: String)
	{
        let character_set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        guard let string_value: String = string.stringByTrimmingCharactersInSet(character_set) where !string_value.isEmpty else
        {
            return
        }
        
        if let elemento = FeedTag(rawValue: self.actualElement)
        {
			switch(elemento)
			{
				case FeedTag.Title:
					self.feed?.title = self.feed!.title + string_value
				case FeedTag.Description:
					self.feed?.feedDescription = self.feed!.feedDescription + string_value
				case FeedTag.LastBuild:
					self.feed?.lastBuild = NSDate(feedStringFormat: string_value)
				case FeedTag.TTL:
					self.feed?.ttl = Int(string_value)
	            default:
	                break
			}
        }
	}

	/**
		Error al procesar
	*/
	func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) throws -> Void
	{
		let reason: String = "Error parsing Xml Channel feed at line \(parser.lineNumber), column \(parser.columnNumber)"
		
		throw ParseError.WrongContent(line: parser.lineNumber, column: parser.columnNumber, reason: reason)
	}
}

//
// MARK: - ItemParserDelegate Protocol
//

extension EMTFeedParser: ItemParserDelegate
{
	/**
		El parser de **incidencias** ha encontrado una
	*/
	func incident(incident: Incident, fromItemParser parser: ItemParser) -> Void
	{
        self.incidents?.append(incident)
	}

	/**
		El parser de ** incidencias** ha terminado
	*/
	func parseFinishedFromItemParser(parser: ItemParser) -> Void
	{
		self.parser.delegate = self
	}
}