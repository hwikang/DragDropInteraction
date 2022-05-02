//
//  CustomSwitchModuleViewController.swift
//  DragAndDrop2
//
//  Created by Hwi kang on 2022/05/02.
//

import UIKit
import SnapKit
class CustomSwitchModuleViewController: UIViewController {
    
    let label = UILabel()
    let switchModule = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(switchModule)
        switchModule.setImage(UIImage(named: "switchModuleOn"), for: .normal)
        switchModule.snp.makeConstraints { maker in
            maker.edges.equalTo(UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 8))
            maker.width.equalTo(104)
            maker.height.equalTo(60)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
