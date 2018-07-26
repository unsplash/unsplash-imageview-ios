//
//  TableViewController.swift
//  UnsplashImageView
//
//  Created by Olivier Collet on 2018-07-26.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard let photoViewController = segue.destination as? PhotoViewController else { return }
        photoViewController.query = segue.identifier?.lowercased()
    }

}
