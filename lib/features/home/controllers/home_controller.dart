import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/contact_response.dart';
import '../../../data/services/home_service.dart';
import '../../../data/services/api_service.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final HomeService _homeService = HomeService(ApiService());

  late TabController tabController;

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  final _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  final isSearchVisible = false.obs;

  final categories = <Category>[].obs;
  final allContacts = <Contact>[].obs;
  final filteredList = <Contact>[].obs;

  final _selectedCategoryId = 'all'.obs;
  String get selectedCategoryId => _selectedCategoryId.value;

  final searchController = TextEditingController();
  final _searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchData();

    // Debounce search input for 400ms
    debounce(
      _searchText,
      (_) => _filterData(),
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchData() async {
    _isLoading.value = true;
    _hasError.value = false;
    try {
      final data = await _homeService.fetchContacts();

      // Add "All" category at the beginning only if it doesn't exist
      final bool hasAll = data.categories.any(
        (c) => c.id.toLowerCase() == 'all',
      );
      if (!hasAll) {
        final allCategory = Category(id: 'all', name: 'All');
        categories.assignAll([allCategory, ...data.categories]);
      } else {
        categories.assignAll(data.categories);
      }

      // Filter out empty contact stubs returned by the API
      allContacts.assignAll(data.contacts.where((c) => !c.isEmpty));

      _filterData();
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void onSearchChanged(String text) {
    _searchText.value = text.trim();
  }

  void selectCategory(String id) {
    if (_selectedCategoryId.value != id) {
      _selectedCategoryId.value = id;
      _filterData();
    }
  }

  void _filterData() {
    final query = _searchText.value.toLowerCase();
    final category = _selectedCategoryId.value;

    final results = allContacts.where((contact) {
      // 1. Category filter
      bool matchesCategory = true;
      if (category != 'all') {
        matchesCategory = contact.categoryId == category;
      }

      // 2. Search query filter
      bool matchesSearch = true;
      if (query.isNotEmpty) {
        final nameMatches =
            contact.name?.toLowerCase().contains(query) ?? false;
        final phoneMatches = contact.phone?.contains(query) ?? false;
        matchesSearch = nameMatches || phoneMatches;
      }

      return matchesCategory && matchesSearch;
    }).toList();

    filteredList.assignAll(results);
  }
}
