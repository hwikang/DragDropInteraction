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
                self.addChildVC(vc, container: self.view)
                
                vc.view.snp.makeConstraints { maker in
                    maker.width.height.equalTo(128)
                    maker.center.equalTo(location)
                }
                
                self.addModule(module: customModule)
                
            case .Switch:
                let vc = CustomSwitchModuleViewController(customModule: customModule)
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
