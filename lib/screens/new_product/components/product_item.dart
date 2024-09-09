import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shopmatic/data/model.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Small corner radius
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
            child: Image.file(
              File(product.image!),
              width: 80.0,
              height: 100.0, // Set a specific height for the image
              fit: BoxFit.cover, // Ensures the image is clipped well
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Kes: ${product.price}",
                  style: TextStyle(
                    fontSize: 14.0, // Reduce size of price
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "Category: ${product.category}",
                  style: TextStyle(
                    fontSize: 14.0, // Reduce size of quantity
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
