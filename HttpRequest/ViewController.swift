import UIKit
/**
 api:http://app.u17.com/v3/appV3_3/ios/phone/rank/list?pid=49915&page=20
 http://app.u17.com/v3/appV3_3/ios/phone/rank/list 域名
 pid:参数1 端口号
 page:参数2 页码
 
 */
class ViewController: UIViewController {
    var model: DMModel?
    //请求参数
    
    let pi = 1
    let pz = 1
    
    lazy var segment: UISegmentedControl = {
        let tempView = UISegmentedControl(items: ["moya", "链式", "AFN式"])
        tempView.frame = CGRect(x:0, y: 40, width: self.view.frame.width, height: 40)
        tempView.selectedSegmentIndex = 0
        tempView.addTarget(self, action: #selector(clickSegment), for: .valueChanged)
        return tempView
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x:0, y: 100, width: self.view.frame.width, height: self.view.frame.height - 100), style: .plain)
        table.rowHeight = 120

        
        table.delegate = self
        table.dataSource = self
        table.register(DMCell.self, forCellReuseIdentifier: "DMCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(segment)
        self.view.addSubview(tableView)
        loadDataByMoya()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data.returnData?.rankinglist?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DMCell = tableView.dequeueReusableCell(withIdentifier: "DMCell", for: indexPath) as! DMCell
        cell.model = model?.data.returnData?.rankinglist?[indexPath.row]
        return cell
    }
}

extension ViewController {
    
    @objc func clickSegment() {
        switch segment.selectedSegmentIndex {
        case 0:
            loadDataByMoya()
        case 1:
            loadDataByChain()
        case 2:
            loadDataByAFN()
        default:
            break
        }
    }
    
    /// moya请求
    func loadDataByMoya() {
        HttpRequest.loadData(target: DMAPI.rankList, model: DMModel.self, success: { model in
            self.model = model
            self.tableView.reloadData()
            
        }, failure: nil)

    }
    
    /// 链式请求
    func loadDataByChain() {
        NetworkKit().url("http://app.u17.com/v3/appV3_3/ios/phone/rank/list").requestType(.post).success { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(DMModel.self, from: json)
            self.model = model
            self.tableView.reloadData()
            
            }.failure { (state_code, message) in
                
            }.request()
    }
    
    /// 类AFN请求
    func loadDataByAFN() {
        NetworkTools.POST(url: "http://app.u17.com/v3/appV3_3/ios/phone/rank/list", params: nil, success: { (json) in
            let decoder = JSONDecoder()
            let model = try? decoder.decode(DMModel.self, from: json)
            self.model = model
            self.tableView.reloadData()
        }) { (state_code, message) in
            
        }
    }
}
