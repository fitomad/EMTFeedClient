//
//  NSDate+EMTFeed.swift
//  EMTFeed
//
//  Created by Adolfo on 13/5/15.
//  Copyright (c) 2016 Desappstre Studio. All rights reserved.
//

import Foundation

extension NSDate
{
    /**
        Crea una fecha a partir de una cadena de texto
        con el formato `Tue, 02 Feb 2016 09:04:55 GMT`
    */
    public convenience init?(feedStringFormat date_string: String)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZZ"
        
        if let helper_date = formatter.dateFromString(date_string)
        {
            self.init(timeIntervalSince1970: helper_date.timeIntervalSince1970)
        }
        else
        {
            return nil
        }
    }
    
    /**
        Crea una fecha a partir de una cadena de texto
        con el formato `03/03/2016 10:00:00`
    */
    public convenience init?(rssStringFormat date_string: String)
    {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        if let helper_date = formatter.dateFromString(date_string)
        {
            self.init(timeIntervalSince1970: helper_date.timeIntervalSince1970)
        }
        else
        {
            return nil
        }
    }
}
