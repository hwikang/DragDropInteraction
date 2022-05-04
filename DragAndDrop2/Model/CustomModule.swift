//
//  CustomModule.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/04.
//

import Foundation
import MobileCoreServices

enum CustomModuleType : Codable {
    
    case Button
    case Switch
    
    enum ErrorType: Error {
            case encoding
            case decoding
        }
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        let decodedValue = try value.decode(String.self)
        switch decodedValue {
        case "button":
            self = .Button
        case "switch":
            self = .Switch
        
        default:
            throw ErrorType.decoding
        }
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = try encoder.singleValueContainer()
        switch self {
        case .Button:
            try container.encode("button")
        case .Switch:
            try container.encode("switch")
        }
    }
}

final class CustomModule : NSObject , NSItemProviderWriting , Codable,NSItemProviderReading {
    
    private let type : CustomModuleType
    private var index : Int?
    init(type:CustomModuleType , index:Int? = nil) {
        self.type = type
        self.index = index
    }


    static var writableTypeIdentifiersForItemProvider: [String] {
        return [String(kUTTypeData)]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
            do {
                let data = try JSONEncoder().encode(self)
                progress.completedUnitCount = 100
                completionHandler(data, nil)
            } catch {
                completionHandler(nil, error)
            }
            return progress
    }
    static var readableTypeIdentifiersForItemProvider: [String] {
           return [String(kUTTypeData)]
       }
       
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> CustomModule {
       do {
           let subject = try JSONDecoder().decode(CustomModule.self, from: data)
           return subject
       } catch {
           fatalError()
       }
    }
    
    func setIndex(index:Int){
        self.index = index
    }
    
    func getType() -> CustomModuleType{
        return self.type
    }
    
    func getIndex() -> Int?{
        return self.index
    }
    
    func toJSON() -> String{
        return """
            {
                type: \(type),
                index : \(index)
            }
        """
    }
}
