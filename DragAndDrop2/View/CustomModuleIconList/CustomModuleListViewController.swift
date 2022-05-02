//
//  CustomModuleListViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/04/28.
//

import UIKit
import MobileCoreServices
enum CustomModuleType : Codable {
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
    

    case Button
    case Switch
}

final class CustomModule : NSObject , NSItemProviderWriting , Codable,NSItemProviderReading {
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
    
    let type : CustomModuleType
    
    init(type:CustomModuleType) {
        self.type = type
    }
    

  
     
    
}

let modulelist = [CustomModule(type: .Button) , CustomModule(type: .Switch)]

class CustomModuleListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var moduleListTableView: UITableView!
    
    var dragImageView : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moduleListTableView.delegate = self
        moduleListTableView.dataSource = self
        moduleListTableView.dragInteractionEnabled = true
        moduleListTableView.dragDelegate = self
        moduleListTableView.dropDelegate = self
    }
    
   
  

}

extension CustomModuleListViewController : UITableViewDragDelegate,UITableViewDropDelegate {
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modulelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomModuleListTableViewCell", for: indexPath) as? CustomModuleListTableViewCell else{ fatalError("cell error")}
        let image = getImage(type: modulelist[indexPath.row].type)
        cell.moduleImageView.image = image
        return cell
    }
    
    private func getImage(type:CustomModuleType) -> UIImage?{
       switch type {
       case .Button:
           return UIImage(named: "lineBtn")

       case .Switch:
           return UIImage(named: "lineSwitch")
       default:
           return UIImage()
       }
   }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning")
        let module = modulelist[indexPath.row]
        let provider = NSItemProvider(object: module)
        return [UIDragItem(itemProvider: provider)]
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        print("canHandle")
        

        return true
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        print("dropSessionDidUpdate")
        
        return UITableViewDropProposal(operation: .copy)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("coordinator \(coordinator)")
    }
    
    
   
    
}


extension CustomModuleListViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        print("touchesBegan")
        let location  = touch.location(in: self.view)
        dragImageView = UIImageView(image: UIImage(named: "buttonModule"))
        dragImageView!.frame = CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100)
        self.view.addSubview(dragImageView!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self.view)
        dragImageView?.frame.origin = CGPoint(x: location.x - 50, y: location.y - 50)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dragImageView = nil
    }
}