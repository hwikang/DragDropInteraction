//
//  CustomModuleListViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/04/28.
//

import UIKit

let modulelist = [CustomModule(type: .Button) , CustomModule(type: .Switch)]

class CustomModuleListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var moduleListTableView: UITableView!
    
    var dragImageView : UIImageView?
    
    var viewModel : ViewModel!
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
        let image = getImage(type: modulelist[indexPath.row].getType())
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
        
        var module = modulelist[indexPath.row]
        let index = viewModel.getModuleIndex(module: module)
        module.setIndex(index: index)
        
        let provider = NSItemProvider(object: module)
        return [UIDragItem(itemProvider: provider)]
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: CustomModule.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        print("dropSessionDidUpdate")
        
        return UITableViewDropProposal(operation: .copy)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("coordinator \(coordinator)")
    }
    
    
   
    
}
