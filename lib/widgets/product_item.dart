import 'package:flutter/material.dart';
import 'package:ostad_assignment/models/product.dart';
import 'package:ostad_assignment/screens/delete_product.dart';
import 'package:ostad_assignment/screens/update_product_screen.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key, required this.product, required this.refreshList,
  });

  final Product product;
  final Function refreshList;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image or Placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: widget.product.productImage.isNotEmpty
                  ? Image.network(
                widget.product.productImage,
                height: 120.0,
                width: 120.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120.0,
                    width: 120.0,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              )
                  : Container(
                height: 120.0,
                width: 120.0,
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'No Image',
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Product Code: ${widget.product.productCode}'),
                  Text('Price: \$${widget.product.unitPrice}'),
                  Text('Quantity: ${widget.product.quantity}'),
                  Text('Total Price: \$${widget.product.totalPrice}'),
                  const SizedBox(height: 12),
                  // Action Buttons: Edit & Delete
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Edit Button
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateProductScreen(
                                  product: widget.product),
                            ),
                          ).then((result) {
                            if (result == true) {
                              widget.refreshList(); // Refresh the product list after update
                            }
                          });
                        },
                        icon: const Icon(Icons.edit, color: Colors.teal),
                        label: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.teal),
                        ),
                      ),
                      const SizedBox(width: 8), // Spacing between buttons
                      // Delete Button
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Product'),
                                content: Text(
                                  'Are you sure you want to delete "${widget.product.productName}"?',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      DeleteProduct deleteProductInstance = DeleteProduct(id: widget.product.id);
                                      int statusCode = await deleteProductInstance.deleteProduct(widget.product.id);
                                      if(statusCode == 200){
                                        widget.refreshList();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${widget.product.productName} deleted successfully'),
                                          ),
                                        );
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Failed to delete'),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
