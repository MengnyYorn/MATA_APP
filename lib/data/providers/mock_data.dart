// lib/data/providers/mock_data.dart
// Static data — replace with real API calls later

import '../models/product_model.dart';
import '../models/order_model.dart';

class MockData {
  MockData._();

  static final List<ProductModel> products = [
    const ProductModel(
      id: '1',
      name: 'Silk Wrap Dress',
      category: 'Dresses',
      price: 189.00,
      image: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&q=80&w=800',
      description: 'A luxurious silk wrap dress perfect for evening events. Features a flattering V-neck and adjustable waist tie.',
      stock: 45,
      rating: 4.8,
      reviews: 124,
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['Emerald', 'Midnight Blue', 'Champagne'],
    ),
    const ProductModel(
      id: '2',
      name: 'Cashmere Turtleneck',
      category: 'Knitwear',
      price: 245.00,
      image: 'https://images.unsplash.com/photo-1574167132757-1447ae9450c7?auto=format&fit=crop&q=80&w=800',
      description: 'Ultra-soft 100% cashmere sweater. A timeless staple for your winter wardrobe.',
      stock: 28,
      rating: 4.9,
      reviews: 89,
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['Oatmeal', 'Charcoal', 'Black'],
    ),
    const ProductModel(
      id: '3',
      name: 'High-Rise Linen Trousers',
      category: 'Bottoms',
      price: 125.00,
      image: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&q=80&w=800',
      description: 'Breathable linen trousers with a tailored high-rise fit. Ideal for summer office wear.',
      stock: 62,
      rating: 4.6,
      reviews: 56,
      sizes: ['24', '26', '28', '30', '32'],
      colors: ['Sand', 'White', 'Navy'],
    ),
    const ProductModel(
      id: '4',
      name: 'Structured Wool Blazer',
      category: 'Outerwear',
      price: 320.00,
      image: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&q=80&w=800',
      description: 'A sharp, structured blazer made from premium Italian wool blend.',
      stock: 15,
      rating: 4.7,
      reviews: 42,
      sizes: ['S', 'M', 'L'],
      colors: ['Camel', 'Black'],
    ),
    const ProductModel(
      id: '5',
      name: 'Floral Chiffon Blouse',
      category: 'Tops',
      price: 85.00,
      image: 'https://images.unsplash.com/photo-1551163943-3f6a855d1153?auto=format&fit=crop&q=80&w=800',
      description: 'Lightweight chiffon blouse with a delicate floral print and ruffle details.',
      stock: 84,
      rating: 4.5,
      reviews: 210,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['Rose', 'Sage'],
    ),
    const ProductModel(
      id: '6',
      name: 'Pleated Midi Skirt',
      category: 'Bottoms',
      price: 110.00,
      image: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?auto=format&fit=crop&q=80&w=800',
      description: 'Elegant pleated midi skirt in a flowing fabric. Perfect for day to evening transition.',
      stock: 38,
      rating: 4.4,
      reviews: 67,
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['Blush', 'Ivory', 'Black'],
    ),
  ];

  static final List<OrderModel> orders = [
    OrderModel(
      id: 'ORD-001',
      customerName: 'Sarah Jenkins',
      date: 'Mar 1, 2024',
      total: 189.00,
      status: OrderStatus.delivered,
      itemCount: 1,
    ),
    OrderModel(
      id: 'ORD-002',
      customerName: 'Sarah Jenkins',
      date: 'Mar 1, 2024',
      total: 370.00,
      status: OrderStatus.shipped,
      itemCount: 2,
    ),
    OrderModel(
      id: 'ORD-003',
      customerName: 'Sarah Jenkins',
      date: 'Feb 28, 2024',
      total: 125.00,
      status: OrderStatus.pending,
      itemCount: 1,
    ),
  ];
}
