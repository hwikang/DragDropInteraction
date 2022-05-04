//
//  CustomButtonModuleViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/02.
//

import UIKit
import SnapKit
class CustomButtonModuleViewController: CustomModuleViewController {
   
    override init(customModule:CustomModule) {
        super.init(customModule: customModule)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    let button = UIButton()
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        self.view.backgroundColor = .white
        
        button.setImage(UIImage(named: "buttonModule"), for: .normal)
        button.snp.makeConstraints {make in
            make.width.equalTo(88)
            make.height.equalTo(96)
            make.center.equalTo(self.view)
        }
        
        
    }
    


}
