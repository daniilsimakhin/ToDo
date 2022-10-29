//
//  DateService.swift
//  ToDo
//
//  Created by Даниил Симахин on 28.10.2022.
//

import Foundation

extension DateFormatter {
    
    static func stringFromDate(date: Date, inputType: String, outputType: String) -> String {
        let dateFormatterGet = DateFormatter()
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterGet.dateFormat = inputType
        dateFormatterPrint.dateFormat = outputType
        
        let date: NSDate? = dateFormatterGet.date(from: dateFormatterGet.string(from: date)) as NSDate?
        
        return dateFormatterPrint.string(from: date! as Date)
    }
}
