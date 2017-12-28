//
//  TimeLineTableViewDataSource.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 11/21/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import UIKit

class TimeLineTableViewDataSource: NSObject, UITableViewDataSource {
    var tableView: UITableView
    override init() {
        tableView = UITableView()
    }
    init(tableView: UITableView) {
        self.tableView = tableView
        tableView.estimatedRowHeight = 377
        tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         tableView.register(UINib.init(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeLineTableViewCell")
        let timeLineTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineTableViewCell", for: indexPath) as? TimeLineTableViewCell
        if indexPath.row == 1 {
            timeLineTableViewCell?.setStatus(status: "Error is straight forward and its because of wrong placeholders you have used in function call. Inside init you are not passing any parameters to your function. It should be this way")
        } else if indexPath.row == 5 {
            timeLineTableViewCell?.setStatus(status: "Error is straight forward and its because of wrong placeholders you have used in function call")
        } else {
            timeLineTableViewCell?.setStatus(status: "Interesting study")
        }
        return timeLineTableViewCell!
    }
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
