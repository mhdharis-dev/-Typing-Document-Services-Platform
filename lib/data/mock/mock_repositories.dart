import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../models/category_model.dart';
import '../models/request_model.dart';
import '../models/customer_model.dart';
import '../models/notification_model.dart';
import '../models/testimonial_model.dart';
import '../models/faq_model.dart';
import '../models/blog_model.dart';
import '../models/settings_model.dart';
import 'mock_data.dart';

// --- SERVICES NOTIFIER ---
class ServicesNotifier extends Notifier<List<ServiceModel>> {
  @override
  List<ServiceModel> build() {
    return List.from(MockData.services);
  }

  void addService(ServiceModel service) {
    state = [...state, service];
  }

  void updateService(ServiceModel service) {
    state = [
      for (final item in state)
        if (item.id == service.id) service else item
    ];
  }

  void deleteService(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final servicesProvider =
    NotifierProvider<ServicesNotifier, List<ServiceModel>>(ServicesNotifier.new);

// --- CATEGORIES NOTIFIER ---
class CategoriesNotifier extends Notifier<List<CategoryModel>> {
  @override
  List<CategoryModel> build() {
    return List.from(MockData.categories);
  }

  void addCategory(CategoryModel category) {
    state = [...state, category];
  }

  void updateCategory(CategoryModel category) {
    state = [
      for (final item in state)
        if (item.id == category.id) category else item
    ];
  }

  void deleteCategory(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final categoriesProvider =
    NotifierProvider<CategoriesNotifier, List<CategoryModel>>(CategoriesNotifier.new);

// --- REQUESTS NOTIFIER ---
class RequestsNotifier extends Notifier<List<RequestModel>> {
  @override
  List<RequestModel> build() {
    return List.from(MockData.requests);
  }

  void addRequest(RequestModel request) {
    state = [request, ...state];
  }

  void updateRequestStatus(String id, String newStatus) {
    state = [
      for (final req in state)
        if (req.id == id)
          req.copyWith(
            status: newStatus,
            updatedAt: DateTime.now(),
            timeline: [
              ...req.timeline,
              TimelineStep(
                title: 'Status: $newStatus',
                description: 'Request status updated to $newStatus.',
                timestamp: DateTime.now(),
                isCompleted: true,
              )
            ],
          )
        else
          req
    ];
  }

  void addInternalNote(String requestId, String author, String noteText) {
    final note = InternalNote(
      id: 'note_${DateTime.now().millisecondsSinceEpoch}',
      author: author,
      note: noteText,
      createdAt: DateTime.now(),
    );
    state = [
      for (final req in state)
        if (req.id == requestId)
          req.copyWith(
            internalNotes: [...req.internalNotes, note],
            updatedAt: DateTime.now(),
          )
        else
          req
    ];
  }
}

final requestsProvider =
    NotifierProvider<RequestsNotifier, List<RequestModel>>(RequestsNotifier.new);

// --- CUSTOMERS NOTIFIER ---
class CustomersNotifier extends Notifier<List<CustomerModel>> {
  @override
  List<CustomerModel> build() {
    return List.from(MockData.customers);
  }

  void addCustomer(CustomerModel customer) {
    state = [...state, customer];
  }

  void updateCustomer(CustomerModel customer) {
    state = [
      for (final c in state)
        if (c.id == customer.id) customer else c
    ];
  }

  void toggleCustomerStatus(String id) {
    state = [
      for (final c in state)
        if (c.id == id)
          c.copyWith(status: c.status == 'Active' ? 'Disabled' : 'Active')
        else
          c
    ];
  }
}

final customersProvider =
    NotifierProvider<CustomersNotifier, List<CustomerModel>>(CustomersNotifier.new);

// --- NOTIFICATIONS NOTIFIER ---
class NotificationsNotifier extends Notifier<List<NotificationModel>> {
  @override
  List<NotificationModel> build() {
    return List.from(MockData.notifications);
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }

  void clearAll() {
    state = [];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationModel>>(NotificationsNotifier.new);

// --- TESTIMONIALS NOTIFIER ---
class TestimonialsNotifier extends Notifier<List<TestimonialModel>> {
  @override
  List<TestimonialModel> build() {
    return List.from(MockData.testimonials);
  }

  void addTestimonial(TestimonialModel testimonial) {
    state = [...state, testimonial];
  }

  void updateTestimonial(TestimonialModel testimonial) {
    state = [
      for (final t in state)
        if (t.id == testimonial.id) testimonial else t
    ];
  }

  void deleteTestimonial(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void toggleTestimonialStatus(String id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(isEnabled: !t.isEnabled) else t
    ];
  }
}

final testimonialsProvider =
    NotifierProvider<TestimonialsNotifier, List<TestimonialModel>>(TestimonialsNotifier.new);

// --- FAQ NOTIFIER ---
class FaqNotifier extends Notifier<List<FaqModel>> {
  @override
  List<FaqModel> build() {
    return List.from(MockData.faqs);
  }

  void addFaq(FaqModel faq) {
    state = [...state, faq];
  }

  void updateFaq(FaqModel faq) {
    state = [
      for (final f in state)
        if (f.id == faq.id) faq else f
    ];
  }

  void deleteFaq(String id) {
    state = state.where((f) => f.id != id).toList();
  }

  void toggleFaqStatus(String id) {
    state = [
      for (final f in state)
        if (f.id == id) f.copyWith(isEnabled: !f.isEnabled) else f
    ];
  }
}

final faqProvider = NotifierProvider<FaqNotifier, List<FaqModel>>(FaqNotifier.new);

// --- BLOG NOTIFIER ---
class BlogNotifier extends Notifier<List<BlogModel>> {
  @override
  List<BlogModel> build() {
    return List.from(MockData.blogPosts);
  }

  void addArticle(BlogModel post) {
    state = [post, ...state];
  }

  void updateArticle(BlogModel post) {
    state = [
      for (final b in state)
        if (b.id == post.id) post else b
    ];
  }

  void deleteArticle(String id) {
    state = state.where((b) => b.id != id).toList();
  }

  void toggleArticleStatus(String id) {
    state = [
      for (final b in state)
        if (b.id == id)
          b.copyWith(
              status: b.status == 'Published' ? 'Draft' : 'Published')
        else
          b
    ];
  }
}

final blogProvider =
    NotifierProvider<BlogNotifier, List<BlogModel>>(BlogNotifier.new);

// --- SETTINGS NOTIFIER ---
class SettingsNotifier extends Notifier<SettingsModel> {
  @override
  SettingsModel build() {
    return MockData.settings;
  }

  void updateSettings(SettingsModel newSettings) {
    state = newSettings;
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsModel>(SettingsNotifier.new);

// --- CURRENT USER PROFILE STATE ---
class CurrentUserNotifier extends Notifier<CustomerModel> {
  @override
  CustomerModel build() {
    return MockData.customers.first;
  }

  void setUser(CustomerModel user) {
    state = user;
  }
}

final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, CustomerModel>(CurrentUserNotifier.new);
