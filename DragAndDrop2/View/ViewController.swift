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
        view.addInteraction(UIDragInteraction(delegate: self))
    }
    
    
    func addChildVC(_ childVC : UIViewController,container:UIView){
        addChild(childVC)
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        childVC.willMove(toParent: self)
        childVC.didMove(toParent: self)
    }
    
    func addContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        self.view.addSubview(container)
        return container
    }
    

}


extension ViewController : UIDropInteractionDelegate{
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        print("ViewController canHandle \(session.canLoadObjects(ofClass: CustomModule.self))")
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        if customModuleListVC.moduleListTableView.hasActiveDrag {
            return UIDropProposal(operation: .copy)
        }else{
            return UIDropProposal(operation: .move)

        }

    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: CustomModule.self) {[weak self] items in
            guard let self = self ,
                  let customModule = items.first as? CustomModule else { return }
            let location = session.location(in: self.view)
            print("type \(customModule.type) location \(location)")
            
            switch customModule.type {
            case .Button:
                let container = self.addContainer()
                container.tag = 69
                container.snp.makeConstraints { maker in
                    maker.width.height.equalTo(128)
                    maker.center.equalTo(location)
                }
                self.addChildVC(CustomButtonModuleViewController(), container: container)
                
            case .Switch:
                let container = self.addContainer()
                container.tag = 18

                container.snp.makeConstraints { maker in
                    maker.width.equalTo(128)
                    maker.height.equalTo(80)
                    maker.center.equalTo(location)
                }
                self.addChildVC(CustomSwitchModuleViewController(), container: container)
                
            }
        }
        
       
    }
 
}


extension ViewController : UIDragInteractionDelegate{
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let location = session.location(in: self.view)
        let moduleView = self.view.hitTest(location, with: nil)
//        moduleView.tag
        print("moduleView \(moduleView)\(moduleView?.tag)")
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
//        dragItem.previewProvider = createPreviewProvider
        return [dragItem]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
        
        return UITargetedDragPreview(view: getPreviewImage(),parameters:UIDragPreviewParameters(), target: target)
    }
    
    
//    func createPreviewProvider() -> UIDragPreview{
//        let dragImageView = getDropImage()
//        return UIDragPreview(view: dragImageView)
//    }
    
    func getPreviewImage() -> UIImageView{
        let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
        let dragImage = UIImage(named: "buttonModule")
        dragImageView.image = dragImage
        return dragImageView
    }
    
}
