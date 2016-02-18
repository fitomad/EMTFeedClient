//
//  CollectionType+Incident.swift
//  EMTFeed
//
//  Created by Adolfo on 13/5/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

public extension CollectionType where Generator.Element: Incident
{
    /**
    	Filtra el contenido actual por el codigo de 
    	linea de autobus.

    	- parameter line: Codigo de linea de autobus
    	- returns: El array actual filtrado
    */
    public func filterByAffectedBusLine(line: String) -> [Generator.Element]?
    {
        return self.filter() { $0.busLines.contains(line)  }
    }

    /**
        Filtramos el contenido de la coleccion de **incidencias**
        para mostrar solo aquellas comprendidas en un periodo
        determinado de tiempo.
    
        - Parameters:
            - start: Inicio del periodo
            - toDate: Final del periodo
        - Returns: Las incidencias producidas en el periodo de tiempo si
            las hubiera 
    */
    public func filterSinceDate(start: NSDate, toDate end: NSDate) -> [Generator.Element]?
    {
        return self.filter()
        {
            ($0.effectStart.timeIntervalSince1970 > start.timeIntervalSince1970) && ($0.effectStart.timeIntervalSince1970 < end.timeIntervalSince1970)
        }
    }
}