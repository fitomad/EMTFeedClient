//
//  HttpResult.swift
//  EMTFeed
//
//  Created by Adolfo on 18/2/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

/**
	Posibles resultados al ejecutat una peticion HTTP
	para el feed de información de incidencias de la EMT.

	Los posibles valores devolvemos son:

	- Success: Recuperamos el contenido del stream
	- RequestError: Problema en la peticion HTTP
	- ConnectionError: Error general
*/
internal enum HttpResult
{
	/// La operacion ha terminado bien.
	/// Devolvemos el stream de datos reacuperados
	case Success(data: NSData)
	/// Algo ha salido mal.
	/// Devolvemos un mensaje con la descripcion del error
	/// y el codigo HTTP asociado
	case RequestError(code: Int, message: String)
	/// Error general
	case ConnectionError(reason: String)
}