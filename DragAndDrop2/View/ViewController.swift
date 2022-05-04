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
    private var viewModel = ViewModel()
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CustomModuleIconList":
            customModuleListVC = segue.destination as! CustomModuleListViewController
            customModuleListVC.viewModel = self.viewModel
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDropInteraction(delegate: self))
//        view.addInteraction(UIDragInteraction(delegate: self))
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
            
            switch customModule.getType() {
            case .Button:
                
                let vc = CustomButtonModuleViewController(customModule: customModule)
//                let vc = CustomButtonModuleViewController(id: "\(customModule.getIndex()!)")
                self.addChildVC(vc, container: self.view)
                
                vc.view.snp.makeConstraints { maker in
                    maker.width.height.equalTo(128)
                    maker.center.equalTo(location)
                }
                
                self.addModule(module: customModule)
                
            case .Switch:
                let vc = CustomSwitchModuleViewController(customModule: customModule)

//                let vc = CustomSwitchModuleViewController(id:"\(customModule.getIndex()!)")
                self.addChildVC(vc, container: self.view)

                vc.view.snp.makeConstraints { maker in
                    maker.width.equalTo(128)
                    maker.height.equalTo(80)
                    maker.center.equalTo(location)
                }
                self.addModule(module: customModule)

            }
        }
        
       
    }
    
    private func addModule(module:CustomModule){
        if(customModuleListVC.moduleListTableView.hasActiveDrag){
            viewModel.addModule(module: module)
        }
    }
 
}

//extension ViewController : UIDragInteractionDelegate{
//    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
//        print("parent VC itemsForBeginning")
//        return []
//    }
//
//    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
//        let target = UIDragPreviewTarget(container: self.view, center: session.location(in: self.view))
//
//        print("parent VC previewForLifting")
//        return UITargetedDragPreview(view: getPreviewImage(), parameters:  UIDragPreviewParameters(),target: target)
//    }
//
//    func getPreviewImage() -> UIImageView{
//            let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
//            let dragImage = UIImage(named: "buttonModule")
//            dragImageView.image = dragImage
//            return dragImageView
//        }
//
//}

//
//extension ViewController : UIDragInteractionDelegate{
//    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
//        let location = session.location(in: self.view)
//        let touchedView = self.view.hitTest(location, with: nil)
//        let dragVC = touchedView?.parentViewController
//        print("dragVC \(dragVC)")
//        let customModule = getCustomModuleByView(view: dragVC)
//
//        let dragItem = UIDragItem(itemProvider: NSItemProvider(object:customModule))
//
//        dragItem.localObject = dragVC
//
//        return [dragItem]
//    }
//
//    func getCustomModuleByView(view:UIViewController?) -> CustomModule{
//        if let vc = view as? CustomButtonModuleViewController {
//            return CustomModule(type: .Button,index: Int(vc.id)!)
//        }
//        if let vc = view as? CustomSwitchModuleViewController {
//            return CustomModule(type: .Switch,index: Int(vc.id)!)
//        }
//
//        fatalError("getCustomModuleByView ERROR")
//    }
//
//    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
//
//        print("previewForLifting")
//        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))
//
//        return UITargetedDragPreview(view: getPreviewImage(),parameters:UIDragPreviewParameters(), target: target)
//    }
//
//    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
//        print("willAnimateLiftWith")
//        session.items.forEach { dragItem in
//            if let dragVC = dragItem.localObject as? UIViewController {
//                print("remove view \(dragVC)")
//                dragVC.view.removeFromSuperview()
//            }
//        }
//    }
//
//    func getPreviewImage() -> UIImageView{
//        let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
//        let dragImage = UIImage(named: "buttonModule")
//        dragImageView.image = dragImage
//        return dragImageView
//    }
//
//}
