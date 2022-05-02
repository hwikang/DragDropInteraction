//
//  ViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/04/28.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private var customModuleListVC : CustomModuleListViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segue \(segue.identifier)")
        switch segue.identifier {
        case "CustomModuleIconList":
            customModuleListVC = segue.destination as! CustomModuleListViewController
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDropInteraction(delegate: self))

    }
    
    
    func addChildVC(_ childVC : UIViewController,container:UIView){
        addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.willMove(toParent: self)
        childVC.didMove(toParent: self)
    }
    
    

}


extension ViewController : UIDropInteractionDelegate{
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("ViewController canHandle \(session.canLoadObjects(ofClass: CustomModule.self))")
        
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        
//        print("active drag \(customModuleListVC.moduleListTableView.hasActiveDrag)")
        if customModuleListVC.moduleListTableView.hasActiveDrag {
            return UIDropProposal(operation: .copy)
        }else{
            return UIDropProposal(operation: .move)

        }
//        return UIDropProposal(operation: .copy)

    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: CustomModule.self) {[weak self] items in
            guard let self = self ,
                  let customModule = items.first as? CustomModule else { return }
            let location = session.location(in: self.view)
            print("type \(customModule.type) location \(location)")
            
            switch customModule.type {
            case .Button:
                //model 추가
                //view 추가
                let container = addContainer()
                
                container.snp.makeConstraints { maker in
                    maker.width.height.equalTo(128)
                    maker.center.equalTo(location)
                }
                
                self.addChildVC(CustomButtonModuleViewController(), container: container)
                
                print(self.view.subviews)

            case .Switch:
                
                let container = addContainer()
                
                container.snp.makeConstraints { maker in
                    maker.width.equalTo(128)
                    maker.height.equalTo(80)
                    maker.center.equalTo(location)
                }
                self.addChildVC(CustomSwitchModuleViewController(), container: container)

                
                return
            }
        }
        
        func addContainer() -> UIView {
            let container = UIView()
            container.backgroundColor = .white
            self.view.addSubview(container)
            return container
        }
    }
    
}


extension ViewController : UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    
}
