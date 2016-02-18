//
//  ItemParser.swift
//  EMTFeed
//
//  Created by Adolfo on 13/5/15.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

internal class ItemParser: NSObject
{
	/**
		Elementos que conforman una incidencia
	*/
	private enum ItemTag: String
	{
		case Guid = "guid"
		case Title = "title"
		case Description = "description"
		case PublicationDate = "pubDate"
		case AfectaDesde = "rssAfectaDesde"
		case AfectaHasta = "rssAfectaHasta"
		case Category = "category"
		case GoogleTransitCause = "GoogleTransitCause"
		case Item = "item"
	}

	/// El delegado al que ir informando de los
	/// avances en la operacion de parseo
	internal weak var delegate: ItemParserDelegate?
	/// Objeto donde almacenados la informacion
	/// de la incidencia que estamos tratando
	private var incident: Incident!
	/// Las lineas que se ven afectadas por esta incidencia
	private var categories: [String]!
    
    /// El elemento Xml que se esta procesando en este momento
    private var actualElement: String!

	/**
		Nos preparamos para parsear
	*/
	override internal init()
	{
        self.actualElement = String()
        
		self.incident = Incident()
		self.categories = [String]()
	}
}

//
// MARK: - NSXMLParserDelegate Protocol
//

extension ItemParser: NSXMLParserDelegate
{
	/**
		Empieza un elemento...
	*/
	func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
	{
		if let elemento = ItemTag(rawValue: elementName)
        {
        switch(elemento)
		{
			case ItemTag.Item:
                print("")
			default:
				self.actualElement = elementName;
		}
        }
	}

	/**
		...y aqui termina
	*/
	func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI namespaceURI: String?, qualifiedName qName: String?)
	{
		if elementName == ItemTag.Item.rawValue
		{
			self.incident.busLines = self.categories
			
			self.delegate?.incident(self.incident, fromItemParser: self)
			self.delegate?.parseFinishedFromItemParser(self)
		}
	}

	/**
		Contenido del elemento
	*/
	func parser(parser: NSXMLParser, foundCharacters string: String)
	{
        let character_set: NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        
        guard let string_value: String = string.stringByTrimmingCharactersInSet(character_set) where !string_value.isEmpty else
        {
            return
        }
        
        if let elemento: ItemTag = ItemTag(rawValue: self.actualElement)
        {
			switch(elemento)
			{
				case ItemTag.Guid:
					self.incident.guid = string_value
				case ItemTag.Title:
					self.incident.title = self.incident.title + string_value
				case ItemTag.PublicationDate:
					self.incident.publicationDate = NSDate(feedStringFormat: string_value)
				case ItemTag.AfectaDesde:
					self.incident.effectStart = NSDate(rssStringFormat: string_value)
				case ItemTag.AfectaHasta:
					self.incident.effectEnd = NSDate(rssStringFormat: string_value)
                case ItemTag.GoogleTransitCause:
					self.incident.cause = Incident.CauseType(googleTransitCause: string_value)
				case ItemTag.Category:
					self.categories.append(string_value)
	            default:
	                break
			}
        }
	}

	/**
		Alguno de los elementos vienve dentro de un `CDATA`
	*/
	func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) -> Void
	{
		if let elemento: ItemTag = ItemTag(rawValue: self.actualElement) where elemento == ItemTag.Description
        {
        	let cdata: String = String(data: CDATABlock, encoding: NSUTF8StringEncoding)!
        	self.incident.incidentDescription = self.incident.incidentDescription + cdata
        }
	}

	/**
		Error al procesar
	*/
	func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) throws -> Void
	{
		let reason: String = "Error parsing Xml Item feed at line \(parser.lineNumber), column \(parser.columnNumber)"
		
		throw ParseError.WrongContent(line: parser.lineNumber, column: parser.columnNumber, reason: reason)
	}
}
