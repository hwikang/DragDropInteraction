//
//  CustomSwitchModuleViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/02.
//

import UIKit
import SnapKit
class CustomSwitchModuleViewController: UIViewController,Identifiable {
   
    init(id:String){
        self.id  = id
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    let id  : String
    let label = UILabel()
    let switchModule = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(switchModule)
        self.view.backgroundColor = .white

        switchModule.setImage(UIImage(named: "switchModuleOn"), for: .normal)
        switchModule.snp.makeConstraints { maker in
            maker.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 8))
            maker.width.equalTo(104)
            maker.height.equalTo(60)
        }
        // Do any additional setup after loading the view.
    }
    

}
