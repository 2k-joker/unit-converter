import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:unit_converter/api_client.dart';
import 'package:unit_converter/backdrop.dart';
import 'package:unit_converter/category.dart';
import 'package:unit_converter/category_tile.dart';
import 'package:unit_converter/unit.dart';
import 'package:unit_converter/unit_converter.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Category? _defaultCategory;
  Category? _currentCategory;
  final _allCategories = <Category>[];

  static const _baseColors = <ColorSwatch>[
    ColorSwatch(0xFF6AB7A8, {
      'highlight': Color(0xFF6AB7A8),
      'splash': Color(0xFF0ABC9B),
    }),
    ColorSwatch(0xFFFFD28E, {
      'highlight': Color(0xFFFFD28E),
      'splash': Color(0xFFFFA41C),
    }),
    ColorSwatch(0xFFFFB7DE, {
      'highlight': Color(0xFFFFB7DE),
      'splash': Color(0xFFF94CBF),
    }),
    ColorSwatch(0xFF8899A9, {
      'highlight': Color(0xFF8899A9),
      'splash': Color(0xFFA9CAE8),
    }),
    ColorSwatch(0xFFEAD37E, {
      'highlight': Color(0xFFEAD37E),
      'splash': Color(0xFFFFE070),
    }),
    ColorSwatch(0xFF81A56F, {
      'highlight': Color(0xFF81A56F),
      'splash': Color(0xFF7CC159),
    }),
    ColorSwatch(0xFFD7C0E2, {
      'highlight': Color(0xFFD7C0E2),
      'splash': Color(0xFFCA90E5),
    }),
    ColorSwatch(0xFFCE9A9A, {
      'highlight': Color(0xFFCE9A9A),
      'splash': Color(0xFFF94D56),
      'error': Color(0xFF912D2D),
    }),
  ];

  static const _icons = <String>[
    'assets/icons/length.png',
    'assets/icons/area.png',
    'assets/icons/volume.png',
    'assets/icons/mass.png',
    'assets/icons/time.png',
    'assets/icons/digital_storage.png',
    'assets/icons/power.png',
    'assets/icons/currency.png',
  ];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_allCategories.isEmpty) {
      await _retrieveLocalCategories();
      await _retrieveApiCategory();
    }
  }

  Future<void> _retrieveLocalCategories() async {
    final json = DefaultAssetBundle.of(context)
        .loadString('assets/data/regular_units.json');
    final data = const JsonDecoder().convert(await json);

    if (data is! Map) {
      throw ('Data retrieved from API is not a Map');
    }
    var categoryIndex = 0;
    for (var key in data.keys) {
      final List<Unit> units =
          data[key].map<Unit>((dynamic data) => Unit.fromJson(data)).toList();

      var category = Category(
        name: key,
        units: units,
        color: _baseColors[categoryIndex],
        iconLocation: _icons[categoryIndex],
      );

      setState(() {
        if (categoryIndex == 0) {
          _defaultCategory = category;
        }
        _allCategories.add(category);
      });

      categoryIndex += 1;
    }
  }

  Future<void> _retrieveApiCategory() async {
    // Add a placeholder while we fetch the Currency category using the API
    setState(() {
      _allCategories.add(Category(
        name: ApiClient.apiCategory['name']!,
        units: [],
        color: _baseColors.last,
        iconLocation: _icons.last,
      ));
    });

    final apiClient = ApiClient();
    final jsonUnits = await apiClient.getUnits(ApiClient.apiCategory['route']);
    // If the API errors out or we have no internet connection, this category
    // remains in placeholder mode (disabled)
    if (jsonUnits != null) {
      final units = <Unit>[];
      for (var unit in jsonUnits) {
        units.add(Unit.fromJson(unit));
      }
      setState(() {
        _allCategories.removeLast();
        _allCategories.add(Category(
          name: ApiClient.apiCategory['name']!,
          units: units,
          color: _baseColors.last,
          iconLocation: _icons.last,
        ));
      });
    }
  }

  void _onCategoryTap(Category category) {
    setState(() {
      _currentCategory = category;
    });
  }

  ValueChanged<Category>? _configureCategoryTap(Category category) {
    return category.name == ApiClient.apiCategory['name'] &&
        category.units.isEmpty
        ? null
        : _onCategoryTap;
  }

  Widget _buildCategoryWidgets(Orientation deviceOrientation) {
    if (deviceOrientation == Orientation.portrait) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var _category = _allCategories[index];
          return CategoryTile(
            category: _category,
            onTap: _configureCategoryTap(_category),
          );
        },
        itemCount: _allCategories.length,
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        children: _allCategories.map((Category category) {
          return CategoryTile(
            category: category,
            onTap: _configureCategoryTap(category),
          );
        }).toList(),
      );
    }
  }

  List<Unit> _retrieveUnitList(String categoryName) {
    return List.generate(10, (int i) {
      i += 1;
      return Unit(
        name: '$categoryName Unit $i',
        conversion: i.toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final listView = Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 48.0,
      ),
      child: _buildCategoryWidgets(MediaQuery.of(context).orientation),
    );

    return Backdrop(
      currentCategory: _currentCategory ?? _defaultCategory!,
      frontPanel: _currentCategory == null
          ? UnitConverter(category: _defaultCategory!)
          : UnitConverter(category: _currentCategory!),
      backPanel: listView,
      frontTitle: const Text('Unit Converter'),
      backTitle: const Text('Select a Category'),
    );
  }
}
