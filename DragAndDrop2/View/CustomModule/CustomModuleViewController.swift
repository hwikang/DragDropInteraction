//
//  CustomModuleViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/04.
//

import UIKit

class CustomModuleViewController: UIViewController {
    
    let customModule : CustomModule
    
    init(customModule:CustomModule){
        self.customModule  = customModule
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addInteraction(UIDragInteraction(delegate: self))
    }
    


}


extension CustomModuleViewController : UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: customModule))
        
//        dragItem.previewProvider = createPreviewProvider
        dragItem.localObject = self
        return [dragItem]
    }
    
    

    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let target = UIDragPreviewTarget(container: interaction.view!, center: session.location(in: interaction.view!))

        return UITargetedDragPreview(view: getPreviewImage(), parameters:  UIDragPreviewParameters(),target: target)
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
//        session.items.forEach { dragItem in
//            if let dragVC = dragItem.localObject as? UIViewController {
//                print("remove view \(dragVC)")
//                dragVC.view.removeFromSuperview()
//            }
//        }
        
    }
    
    
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        print("didEndWith")
        self.view.removeFromSuperview()

    }
    
    func createPreviewProvider() -> UIDragPreview{
        let dragImageView = getPreviewImage()
        return UIDragPreview(view: dragImageView)
    }

    func getPreviewImage() -> UIImageView{
            let dragImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
            let dragImage = UIImage(named: "buttonModule")
            dragImageView.image = dragImage
            return dragImageView
        }
    
}
