import 'menu.dart';

class Restaurant {
  final int id;
  final String name;
  final List<Menu> menus;

  Restaurant({
    required this.id,
    required this.name,
    required this.menus,
  });
}

List<Restaurant> restaurants = [
  Restaurant(
    id: 1,
    name: 'Stan A',
    menus: [
      Menu(
        id: 1,
        name: 'Menu 1',
        description: 'Description 1',
        price: 10.0,
        photo: 'photo1.jpg',
        stanId: 1,
      ),
      Menu(
        id: 2,
        name: 'Menu 2',
        description: 'Description 2',
        price: 15.0,
        photo: 'photo2.jpg',
        stanId: 1,
      ),
    ],
  ),
  Restaurant(
    id: 2,
    name: 'Stan B',
    menus: [
      Menu(
        id: 3,
        name: 'Menu 3',
        description: 'Description 3',
        price: 20.0,
        photo: 'photo3.jpg',
        stanId: 2,
      ),
      Menu(
        id: 4,
        name: 'Menu 4',
        description: 'Description 4',
        price: 25.0,
        photo: 'photo4.jpg',
        stanId: 2,
      ),
    ],
  ),
];
