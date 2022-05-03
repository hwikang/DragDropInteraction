//
//  ViewModel.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/03.
//

import Foundation


class ViewModel{
    var currentModuleDict : [CustomModuleType:[CustomModule]] = [:]
    
    
    func addModule(module:CustomModule){
        let index = getModuleIndex(module: module)
        print("Index \(index)")
        let indexedModule = CustomModule(type: module.type, index: index)
        
      
        if currentModuleDict[module.type] != nil{
            currentModuleDict[module.type]!.append(indexedModule)
        }else{
            currentModuleDict[module.type] = [indexedModule]
        }
       print("currentModuleDict \(currentModuleDict)")
    }
    
    func getModuleIndex(module:CustomModule) -> Int{
        var index = 1
        guard var sameModules = currentModuleDict[module.type] else {
            return index
        }
        
        sameModules.sort { $0.index! < $1.index! }
        for i in 1..<sameModules.count+2{
            let foundModule = sameModules.first {$0.index == i }
            if(foundModule == nil){
                index = i
                break
            }
        }
        
        
        return index
    }
}
