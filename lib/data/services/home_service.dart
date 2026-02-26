import '../../core/constants/app_constants.dart';
import '../models/contact_response.dart';
import 'api_service.dart';

class HomeService {
  final ApiService _apiService;

  HomeService(this._apiService);

  Future<ContactData> fetchContacts() async {
    try {
      final response = await _apiService.get(AppConstants.contactsEndpoint);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final contactResponse = ContactResponse.fromJson(response.data);
        return contactResponse.data;
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (e) {
      throw Exception('Network error occurred: $e');
    }
  }
}
