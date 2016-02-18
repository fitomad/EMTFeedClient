//
//  Incident.swift
//  EMTFeed
//
//  Created by Adolfo on 13/5/15.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

public class Incident
{
	/**
		Motivos por los que se puede ver
		modificado la ruta de una linea
	*/
	public enum CauseType: Int
	{
		case Manifestacion = 4
		case Obras = 8
		case ActoOficial = 10
		case ActoReligioso = 11
		case EventoDeportivo = 12
		case EventoCultural = 13
		case Mercadillo = 14
		case PodaArboles = 15
        case OtrasCausas = 99
		
		/**
			Creamos el tipo de incidencia en 
            al codigo que llega del feed

			- parameter googleTransitCause: El codigo de la incidencia
		*/
		init?(googleTransitCause code: Int)
		{
            self.init(rawValue: code)
		}
	}

	/**
		Estado en el que se encuentra la incidencia

		- Finished: Ya ha terminado
		- InProgress: Vigente en estos momentos
		- Scheduled: Aun no ha comenzado
	*/
	public enum State
	{
		case Finished
		case InProgress
		case Scheduled
	}

	///
	public internal(set) var guid: String!
	///
	public internal(set) var title: String!
	///
	public internal(set) var incidentDescription: String!
	///
	public internal(set) var associatedLink: NSURL!
	///
	public internal(set) var publicationDate: NSDate!
	///
	public internal(set) var effectStart: NSDate!
	///
	public internal(set) var effectEnd: NSDate!
	///
	public internal(set) var cause: CauseType?
	///
	public internal(set) var busLines: [String]!

	///
	public var state: State
	{
		let hoy: NSDate = NSDate()

		if hoy.compare(self.effectEnd) == NSComparisonResult.OrderedDescending
		{
		    return State.Finished
		}

		if hoy.compare(self.effectStart) == NSComparisonResult.OrderedAscending
		{
		    return State.Scheduled
		}

		return State.InProgress
	}

	/**

	*/
	internal init()
	{
	    self.title = String()
	    self.incidentDescription = String()
	}
}

//
// MARK: Equatable Protocol
//

extension Incident: Equatable {}

public func ==(lhs: Incident, rhs: Incident) -> Bool
{
	return lhs.guid == rhs.guid
}

public func !=(lhs: Incident, rhs: Incident) -> Bool
{
	return !(lhs == rhs)
}

//
// MARK: - Comparable Protocol
//

extension Incident: Comparable {}

public func <(lhs: Incident, rhs: Incident) -> Bool
{
    return lhs.publicationDate.timeIntervalSince1970 < rhs.publicationDate.timeIntervalSince1970
}