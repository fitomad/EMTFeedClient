//
//  EMTFeedClient.swift
//  EMTFeed
//
//  Created by Adolfo on 03/2/16.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

///
/// Closure donde devolvemos el resultado de lectura del feed
///
/// - Parameter result: Un valor de la enumeracion que informa del 
///     exito o fracaso de la operacion
///
public typealias FeedCompletionHandler = (result: FeedResult) -> (Void)

///
/// All API request will be *returned* here
///
private typealias HttpRequestCompletionHandler = (result: HttpResult) -> (Void)

///
///
///
public class EMTFeedClient
{
	/// El recurso donde se encuentra el feed
	private let feedURL: NSURL
	/// The API client HTTP session
    private var httpSession: NSURLSession!
    /// API client HTTP configuration
    private var httpConfiguration: NSURLSessionConfiguration!

	/// Singleton
	public static let sharedInstance: EMTFeedClient = EMTFeedClient()

	/**
        Configuramos la conexion HTTP
	*/
	private init()
	{
		self.feedURL = NSURL(string: "http://servicios.emtmadrid.es:8080/rss/emtrss.xml")!

		self.httpConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.httpConfiguration.HTTPMaximumConnectionsPerHost = 10

        let http_queue: NSOperationQueue = NSOperationQueue()
        http_queue.maxConcurrentOperationCount = 10

        self.httpSession = NSURLSession(configuration:self.httpConfiguration,
                                             delegate:nil,
                                        delegateQueue:http_queue)
	}

	//
	// MARK: - Public Methods
	//

	/**
        Recuperamos las incidencias de transito reportadas por 
        el servidor de la EMT.

        - Parameter completionHandler: Closure en el que expondremos el resultado
            de la operacion
	*/
	public func requestTransitIncidents(completionHandler: FeedCompletionHandler) -> Void
	{
        self.processHttpRequestForURL(self.feedURL) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    let parser: EMTFeedParser = EMTFeedParser()
                
                    do
                    {
                        let feed: EMTFeed? = try parser.incidentWithData(data)
                        completionHandler(result: FeedResult.Success(feed: feed!))
                    }
                    catch let ParseError.WrongContent(_, _, reason)
                    {
                        completionHandler(result: FeedResult.Error(reason: reason))
                    }
                    catch let ParseError.Failure(reason)
                    {
                        completionHandler(result: FeedResult.Error(reason: reason))
                    }
                    catch
                    {
                        completionHandler(result: FeedResult.Error(reason: "Desconocido"))
                    }
                case let HttpResult.RequestError(_, message):
                    completionHandler(result: FeedResult.Error(reason: message))
                case let HttpResult.ConnectionError(reason):
                    completionHandler(result: FeedResult.Error(reason: reason))
            }
        }
	}

	//
	// MARK: - Private Methods
	//

	/**
        Peticion a una URL

        - Parameters:
            - url: Request URL
            - completionHandler: The HTTP response will be found here.
    */
    private func processHttpRequestForURL(url: NSURL, httpHandler: HttpRequestCompletionHandler) -> Void
    {
        let request: NSURLRequest = NSURLRequest(URL: url)

        let data_task: NSURLSessionDataTask = self.httpSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error
            {
                httpHandler(result: HttpResult.ConnectionError(reason: error.localizedDescription))
                return
            }

            guard let data = data, http_response = response as? NSHTTPURLResponse else
            {
                httpHandler(result: HttpResult.ConnectionError(reason: "No data. No response"))
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    httpHandler(result: HttpResult.Success(data: data))
                default:
                    let code: Int = http_response.statusCode
                    let message: String = NSHTTPURLResponse.localizedStringForStatusCode(code)

                    httpHandler(result: HttpResult.RequestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
}