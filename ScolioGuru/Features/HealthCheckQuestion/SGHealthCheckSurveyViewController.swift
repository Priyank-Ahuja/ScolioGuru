//
//  HealthCheckQuestionViewController.swift
//  ScolioGuru
//
//  Created by Priyank Ahuja on 5/31/24.
//

import UIKit

class SGHealthCheckSurveyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let model: SGHealthCheckSurveyViewModel
    
    init(model: SGHealthCheckSurveyViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SGSurveyOptionTableViewCell", bundle: nil), forCellReuseIdentifier: "SGSurveyOptionTableViewCell")
        self.tableView.register(UINib.init(nibName: "SGSurveyTableViewCell", bundle: nil), forCellReuseIdentifier: "SGSurveyTableViewCell")
        self.tableView.register(UINib.init(nibName: "SGCongratsTableViewCell", bundle: nil), forCellReuseIdentifier: "SGCongratsTableViewCell")
    }
}

extension SGHealthCheckSurveyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.options.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SGSurveyTableViewCell", for: indexPath) as? SGSurveyTableViewCell else {return UITableViewCell()}
            return cell
        case 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SGCongratsTableViewCell", for: indexPath) as? SGCongratsTableViewCell else {return UITableViewCell()}
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SGSurveyOptionTableViewCell", for: indexPath) as? SGSurveyOptionTableViewCell else {return UITableViewCell()}
            cell.setupInterface(option: model.options[indexPath.row-1], selectedCell: model.selectedIndex, row: indexPath.row)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 141
        case 6:
            return 100
        default:
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0 && indexPath.row != 6) {
            self.model.selectedIndex = indexPath.row
            self.tableView.reloadData()
        }
    }
}
