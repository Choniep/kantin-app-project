
import '../menu.dart';

class Restaurant {
  final String id;
  final String name;
  final List<Menu> menus;
  final double rating;
  final String imageUrl;
  final bool isOpen;
  final List<String> categories;

  Restaurant({
    required this.id,
    required this.name,
    required this.menus,
    this.rating = 0.0,
    this.imageUrl = '',
    this.isOpen = true,
    this.categories = const [],
  });
}

List<Restaurant> restaurants = [
  Restaurant(
    id: '1',
    name: 'Stan Mama Tika',
    rating: 4.5,
    categories: ['Nasi Goreng', 'Mie Goreng'],
    menus: [
      Menu(
        id: '1',
        name: 'Nasi Goreng Spesial',
        description: 'Nasi goreng dengan telur dan ayam',
        price: 15000,
        photo: 'lib/assets/images/burgers/beef_burger.webp',
        stanId: "1",
        isDiskon: false,
        jenisMenu: 'makanan'
      ),
      Menu(
        id: '2',
        name: 'Mie Goreng Spesial',
        description: 'Mie goreng dengan telur dan ayam',
        price: 15000,
        photo: 'lib/assets/images/burgers/beef_burger.webp',
        stanId: "1",
        isDiskon: false,
        jenisMenu: 'minuman',
      ),
    ],
  ),
];
