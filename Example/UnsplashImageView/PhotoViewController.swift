//
//  PhotoViewController.swift
//  UnsplashImageView
//
//  Created by Olivier Collet on 2018-07-26.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UnsplashImageView!

    var query: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let query = query {
            imageView.query = query
        }
        imageView.fetchPhoto()
    }

}
