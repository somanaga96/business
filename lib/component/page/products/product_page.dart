import 'package:business/component/page/products/product_crud.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/global.dart';
import '../../utils/login.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _OpenLoansState();
}

class _OpenLoansState extends State<ProductPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    Provider.of<Global>(context, listen: false).fetchProductList();
  }

  void fetchData() async {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProductCrud productCrud = ProductCrud();

    return Consumer<Global>(
        builder: (context, global, child) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.lightBlue,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text("product.getTitle()"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
              body: Consumer<Global>(
                builder: (context, global, child) {
                  // print('Current user set in open page: ${global.getUser()}');
                  // String name = global.getUser();
                  // print('Current user set in open page name: $name');
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // After the data is fetched, check if the list is empty
                  if (global.productList.isEmpty) {
                    return const Center(
                        child: Text('No live loans are available.'));
                  }

                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: global.productList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: ListTile(
                            title: Text(
                              '${global.productList[index].name} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    // Call the createOrUpdateDebt function with docId
                                    productCrud.createOrUpdateUser(
                                      context,
                                      existingDocId:
                                          global.productList[index].id,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    // Call the deleteDebt function with docId
                                    await productCrud.deleteUser(
                                      global.productList[index].id,
                                    );
                                    Provider.of<Global>(context, listen: false)
                                        .fetchProductList();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => productCrud.createOrUpdateUser(context),
                child: const Icon(Icons.add),
              ),
            ));
  }
}
