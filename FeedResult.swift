//
//  FeedResult.swift
//  EMTFeed
//
//  Created by Adolfo on 18/2/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

/**
	Posibles resultados de obtener el feed
	de información de incidencias de la EMT.

	Los posibles valores devolvemos son:

	- Success: Lectura correcta
	- Error: Algo ha fallado en la obtencion del feed
*/
public enum FeedResult
{
	/// La operacion ha terminado bien.
	/// Devolvemos un `EMTFeed` con toda la información
	case Success(feed: EMTFeed)
	/// Algo ha salido mal.
	/// Devolvemos un mensaje con la descripcion del error
	case Error(reason: String)
}