import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class Product {
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: 'iPhone', price: 999),
  Product(name: 'cookie', price: 2),
  Product(name: 'ps5', price: 500),
];

final productSortTypeProvider = StateProvider<ProductSortType>(
  (ref) => ProductSortType.name,
);

final productsProvider = Provider<List<Product>>((ref) {
  final sortType = ref.watch(productSortTypeProvider);
  switch (sortType) {
    case ProductSortType.name:
      return _products.sorted((a, b) => a.name.compareTo(b.name));
    case ProductSortType.price:
      return _products.sorted((a, b) => a.price.compareTo(b.price));
  }
});

enum ProductSortType {
  name,
  price,
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(
        backgroundColor: Colors.amber[200],
        title: const Text('Products'),
        actions: [
          DropdownButton<ProductSortType>(
            value: ref.watch(productSortTypeProvider),
            onChanged: (value) {
              ref.read(productSortTypeProvider.notifier).state = value!;
            },
            items: const [
              DropdownMenuItem<ProductSortType>(
                value: ProductSortType.name,
                child: Icon(Icons.sort_by_alpha),
              ),
              DropdownMenuItem<ProductSortType>(
                value: ProductSortType.price,
                child: Icon(Icons.sort),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text('${product.price} \$'),
          );
        },
      ),
    );
  }
}
