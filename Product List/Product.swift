//
//  Product.swift
//  Product List
//
//  Created by Mitchell Sweet on 1/4/18.
//  Copyright © 2018 Mitchell Sweet. All rights reserved.
//

import Foundation

struct Response: Codable {
    let products: [Product]
}

struct Product: Codable {
    /// The product's name
    let title: String
    /// The product's descripton as HTML
    let body_html: String
    /// Keywords related to the product
    let tags: String
    /// Array of the product's images
    let images: [Image]
    
    struct Image: Codable {
        /// URL to image
        let src: URL
    }
    /// ID of the product
    let id: Int
    /// Vendor of product
    let vendor: String
    /// Type of product
    let product_type: String
    /// Array of the product's variants
    let variants: [Variant]
    
    struct Variant: Codable {
        /// Title of product varient
        let title: String
    }
    
    
    /// Concatenates a string of the product's title, description, type, and tags and checks it against text given to it. Used for filtering.
    func matchesSearchText(_ text: String) -> Bool {
        let concatenation = title + body_html + tags + product_type
        if concatenation.lowercased().contains(text) {
            return true
        }
        return false
    }
}


