import '../models/service_model.dart';
import '../models/category_model.dart';
import '../models/request_model.dart';
import '../models/customer_model.dart';
import '../models/notification_model.dart';
import '../models/testimonial_model.dart';
import '../models/faq_model.dart';
import '../models/blog_model.dart';
import '../models/settings_model.dart';

class MockData {
  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat_typing',
      name: 'Typing Services',
      description: 'Official government forms typing, legal document preparation and entry.',
      iconName: 'keyboard',
      status: 'Active',
      serviceCount: 4,
    ),
    CategoryModel(
      id: 'cat_translation',
      name: 'Translation Services',
      description: 'Certified legal and general document translation in over 50 languages.',
      iconName: 'translate',
      status: 'Active',
      serviceCount: 3,
    ),
    CategoryModel(
      id: 'cat_visa',
      name: 'Visa Services',
      description: 'Family, residence, investor, and UAE Golden Visa processing.',
      iconName: 'card_travel',
      status: 'Active',
      serviceCount: 5,
    ),
    CategoryModel(
      id: 'cat_gov',
      name: 'Government Services',
      description: 'Amer, Tasheel, Tawjeeh, Ejari, and DED municipal assistance.',
      iconName: 'account_balance',
      status: 'Active',
      serviceCount: 4,
    ),
    CategoryModel(
      id: 'cat_business',
      name: 'Business Services',
      description: 'Trade license issuance, renewal, corporate bank account setup, and PRO.',
      iconName: 'business_center',
      status: 'Active',
      serviceCount: 4,
    ),
    CategoryModel(
      id: 'cat_doc',
      name: 'Document Attestation',
      description: 'MOFA, Embassy, Notary Public, and degree certificate attestation.',
      iconName: 'verified',
      status: 'Active',
      serviceCount: 3,
    ),
  ];

  static const List<ServiceModel> services = [
    ServiceModel(
      id: 'srv_golden_visa',
      name: 'UAE Golden Visa Application',
      categoryId: 'cat_visa',
      categoryName: 'Visa Services',
      shortDescription: '10-year residency visa for investors, entrepreneurs, specialized talents, and executives.',
      fullDescription: 'Comprehensive end-to-end guidance for securing a 10-year UAE Golden Visa. We handle eligibility assessment, document attestation, ICP/GDRFA pre-approval, medical fitness scheduling, Emirates ID typing, and final visa stamping.',
      requirements: [
        'Valid Passport copy (min 6 months validity)',
        'Degree certificate or proof of investment / property ownership',
        'Current UAE Visa copy (if applicable)',
        'Passport size photograph with white background',
        'Bank statements (last 6 months)'
      ],
      process: [
        'Initial Eligibility & Document Review',
        'ICP Nomination / Pre-Approval Filing',
        'Medical Fitness Test & Emirates ID Typing',
        'Residency Stamping & E-Visa Delivery'
      ],
      estimatedTime: '3 - 5 Working Days',
      price: 2499.0,
      pricePrefix: 'Starting from AED',
      isPopular: true,
      isActive: true,
      iconName: 'stars',
    ),
    ServiceModel(
      id: 'srv_certified_translation',
      name: 'Legal Certified Translation',
      categoryId: 'cat_translation',
      categoryName: 'Translation Services',
      shortDescription: 'Ministry of Justice approved legal translation for courts, embassies, and government entities.',
      fullDescription: 'Official court-certified legal translation recognized by the UAE Ministry of Justice, embassies, and all government departments. Translated by sworn legal linguists with guaranteed accuracy.',
      requirements: [
        'Original clear document scan or PDF',
        'Spelling of names as appearing in Official Passport'
      ],
      process: [
        'Document Text Analysis & Word Count',
        'Translation by Sworn Legal Translator',
        'Quality Assurance & Proofreading',
        'Legal Stamp Application & Digital Delivery'
      ],
      estimatedTime: '24 Hours',
      price: 150.0,
      pricePrefix: 'AED',
      isPopular: true,
      isActive: true,
      iconName: 'g_translate',
    ),
    ServiceModel(
      id: 'srv_family_residency',
      name: 'Family Residence Visa Typing',
      categoryId: 'cat_visa',
      categoryName: 'Visa Services',
      shortDescription: 'Complete sponsorship typing for spouse, children, and parents.',
      fullDescription: 'Streamlined processing for family member residency visas in Dubai & Abu Dhabi. Includes Entry Permit typing, status change, medical test appointment, Emirates ID typing, and residence visa approval.',
      requirements: [
        'Sponsor Passport, Visa, Emirates ID & Salary Certificate',
        'Ejari Tenancy Contract & DEWA Bill',
        'Attested Marriage Certificate (for spouse)',
        'Attested Birth Certificates (for children)',
        'Passport copies of family members'
      ],
      process: [
        'Entry Permit Application Filing',
        'In-Country Status Change Typing',
        'VIP Medical Fitness Test Appointment',
        'Emirates ID Typing & Final Stamping'
      ],
      estimatedTime: '2 - 4 Working Days',
      price: 850.0,
      pricePrefix: 'Starting from AED',
      isPopular: true,
      isActive: true,
      iconName: 'family_restroom',
    ),
    ServiceModel(
      id: 'srv_mofa_attestation',
      name: 'MOFA Certificate Attestation',
      categoryId: 'cat_doc',
      categoryName: 'Document Attestation',
      shortDescription: 'Ministry of Foreign Affairs attestation for educational, personal & commercial documents.',
      fullDescription: 'Express attestation service with UAE Ministry of Foreign Affairs (MOFA). Suitable for birth certificates, marriage certificates, university degrees, power of attorney, and commercial contracts.',
      requirements: [
        'Original Document (Embassy stamped if issued overseas)',
        'Passport copy of document owner'
      ],
      process: [
        'Document Inspection & Verification',
        'MOFA Portal Application & Fee Settlement',
        'Physical Verification Stamp',
        'Secure Express Delivery'
      ],
      estimatedTime: '1 - 2 Working Days',
      price: 350.0,
      pricePrefix: 'AED',
      isPopular: true,
      isActive: true,
      iconName: 'verified_user',
    ),
    ServiceModel(
      id: 'srv_business_license',
      name: 'Trade License Renewal & PRO',
      categoryId: 'cat_business',
      categoryName: 'Business Services',
      shortDescription: 'DED and Freezone business license renewal, Ejari renewal, and municipal compliance.',
      fullDescription: 'Hassle-free corporate PRO services and business license renewals across DED Mainland and Freezones (IFZA, Meydan, DAFZA, JAFZA, RAKEZ). Includes Ejari linkage, lease renewal, and Chamber of Commerce registration.',
      requirements: [
        'Existing Trade License copy',
        'Partners / Owner Passport & Emirates ID',
        'New Ejari / Tenancy Contract copy'
      ],
      process: [
        'License Renewal Voucher Generation',
        'Ejari & Municipality Approval',
        'Voucher Settlement & License Printing',
        'Chamber Membership Renewal'
      ],
      estimatedTime: '1 Working Day',
      price: 1200.0,
      pricePrefix: 'Starting from AED',
      isPopular: false,
      isActive: true,
      iconName: 'domain',
    ),
    ServiceModel(
      id: 'srv_amer_tasheel',
      name: 'Amer & Tasheel Typing',
      categoryId: 'cat_gov',
      categoryName: 'Government Services',
      shortDescription: 'Fast-track typing for GDRFA Amer, MOHRE Tasheel, Tawjeeh, and Emirates ID.',
      fullDescription: 'Direct access to government typing systems. Quick submission for quota approvals, offer letters, work permits, labor contract modifications, and residency cancellations.',
      requirements: [
        'Establishment Card / Trade License',
        'Employee Passport copy',
        'Existing Labor Contract (if modification)'
      ],
      process: [
        'Application Data Entry',
        'Official Government Portal Processing',
        'Receipt & Electronic Permit Issuance'
      ],
      estimatedTime: 'Same Day (2 - 4 Hours)',
      price: 200.0,
      pricePrefix: 'AED',
      isPopular: false,
      isActive: true,
      iconName: 'assignment',
    ),
  ];

  static final List<CustomerModel> customers = [
    CustomerModel(
      id: 'cust_101',
      name: 'Mohammed Al-Maktoum',
      email: 'm.maktoum@example.ae',
      phone: '+971 50 123 4567',
      address: 'Downtown Dubai, Boulevard Plaza Tower 1',
      joinedDate: DateTime.now().subtract(const Duration(days: 90)),
      status: 'Active',
      requestCount: 4,
    ),
    CustomerModel(
      id: 'cust_102',
      name: 'Sarah Jenkins',
      email: 'sarah.j@techcorp.com',
      phone: '+971 55 987 6543',
      address: 'Dubai Marina, Marina Gate 2, Apt 1402',
      joinedDate: DateTime.now().subtract(const Duration(days: 45)),
      status: 'Active',
      requestCount: 2,
    ),
    CustomerModel(
      id: 'cust_103',
      name: 'Ahmed Hassan',
      email: 'ahmed.hassan@logistics.ae',
      phone: '+971 52 444 3322',
      address: 'Business Bay, Executive Towers B',
      joinedDate: DateTime.now().subtract(const Duration(days: 120)),
      status: 'Active',
      requestCount: 6,
    ),
    CustomerModel(
      id: 'cust_104',
      name: 'Elena Rostova',
      email: 'elena.rostova@designstudio.io',
      phone: '+971 58 666 7788',
      address: 'JBR, Rimal 4, Dubai',
      joinedDate: DateTime.now().subtract(const Duration(days: 15)),
      status: 'Active',
      requestCount: 1,
    ),
  ];

  static final List<RequestModel> requests = [
    RequestModel(
      id: 'REQ-2026-1089',
      serviceId: 'srv_golden_visa',
      serviceName: 'UAE Golden Visa Application',
      categoryName: 'Visa Services',
      customerId: 'cust_101',
      customerName: 'Mohammed Al-Maktoum',
      customerEmail: 'm.maktoum@example.ae',
      customerPhone: '+971 50 123 4567',
      preferredContact: 'WhatsApp',
      message: 'Submitting degree certificate and passport for 10-year Golden Visa application under Executive category.',
      documents: [
        RequestDocument(
          id: 'doc_1',
          fileName: 'Attested_Degree_Certificate.pdf',
          fileType: 'PDF',
          fileSize: '2.4 MB',
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'Verified',
        ),
        RequestDocument(
          id: 'doc_2',
          fileName: 'Passport_Copy_Mohammed.pdf',
          fileType: 'PDF',
          fileSize: '1.1 MB',
          uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
          status: 'Verified',
        ),
      ],
      status: 'Processing',
      submittedAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
      timeline: [
        TimelineStep(
          title: 'Request Submitted',
          description: 'Request successfully received and queued for review.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Under Review',
          description: 'Document specialist verified degree & passport qualifications.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Processing with GDRFA',
          description: 'ICP Nomination submitted. Pre-approval expected within 24h.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Golden Visa Issuance',
          description: 'Final residency visa stamping & E-ID issuance.',
          timestamp: DateTime.now().add(const Duration(days: 2)),
          isCompleted: false,
        ),
      ],
      internalNotes: [
        InternalNote(
          id: 'note_1',
          author: 'Admin Team',
          note: 'Degree attestation verified with MOFA portal. Nominated under Executive track.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        )
      ],
    ),
    RequestModel(
      id: 'REQ-2026-1088',
      serviceId: 'srv_certified_translation',
      serviceName: 'Legal Certified Translation',
      categoryName: 'Translation Services',
      customerId: 'cust_102',
      customerName: 'Sarah Jenkins',
      customerEmail: 'sarah.j@techcorp.com',
      customerPhone: '+971 55 987 6543',
      preferredContact: 'Email',
      message: 'Need legal English to Arabic translation of commercial agreement for Dubai Courts submission.',
      documents: [
        RequestDocument(
          id: 'doc_3',
          fileName: 'Commercial_Agreement_V2.pdf',
          fileType: 'PDF',
          fileSize: '4.8 MB',
          uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
          status: 'Pending',
        )
      ],
      status: 'Reviewing',
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      timeline: [
        TimelineStep(
          title: 'Request Submitted',
          description: 'Request submitted online.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Under Review',
          description: 'Legal translator assigned to calculate exact word count.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Translation & Stamping',
          description: 'Sworn translation in progress.',
          timestamp: DateTime.now().add(const Duration(hours: 12)),
          isCompleted: false,
        ),
        TimelineStep(
          title: 'Completed',
          description: 'Stamped digital PDF & physical copy dispatched.',
          timestamp: DateTime.now().add(const Duration(days: 1)),
          isCompleted: false,
        ),
      ],
      internalNotes: [],
    ),
    RequestModel(
      id: 'REQ-2026-1085',
      serviceId: 'srv_mofa_attestation',
      serviceName: 'MOFA Certificate Attestation',
      categoryName: 'Document Attestation',
      customerId: 'cust_103',
      customerName: 'Ahmed Hassan',
      customerEmail: 'ahmed.hassan@logistics.ae',
      customerPhone: '+971 52 444 3322',
      preferredContact: 'Phone',
      message: 'Need MOFA stamp on UK Masters Degree Certificate.',
      documents: [
        RequestDocument(
          id: 'doc_4',
          fileName: 'UK_Masters_Certificate.pdf',
          fileType: 'PDF',
          fileSize: '3.2 MB',
          uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
          status: 'Verified',
        )
      ],
      status: 'Completed',
      submittedAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      timeline: [
        TimelineStep(
          title: 'Request Submitted',
          description: 'Request submitted online.',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'MOFA Portal Processing',
          description: 'Submitted to UAE Ministry of Foreign Affairs.',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isCompleted: true,
        ),
        TimelineStep(
          title: 'Completed',
          description: 'MOFA stamp applied successfully. Certificate delivered.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCompleted: true,
        ),
      ],
      internalNotes: [
        InternalNote(
          id: 'note_2',
          author: 'PRO Officer',
          note: 'Certificate delivered via Aramex courier tracking #982312.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        )
      ],
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'notif_1',
      title: 'Golden Visa Application Update',
      message: 'Your Golden Visa request REQ-2026-1089 status has changed to Processing.',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: false,
      type: 'request',
      relatedRequestId: 'REQ-2026-1089',
    ),
    NotificationModel(
      id: 'notif_2',
      title: 'Translation Review Started',
      message: 'Document specialist is reviewing your Legal Translation file.',
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: false,
      type: 'request',
      relatedRequestId: 'REQ-2026-1088',
    ),
    NotificationModel(
      id: 'notif_3',
      title: 'Attestation Completed',
      message: 'Your MOFA Certificate Attestation REQ-2026-1085 is completed!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'request',
      relatedRequestId: 'REQ-2026-1085',
    ),
    NotificationModel(
      id: 'notif_4',
      title: 'Welcome to Service Platform',
      message: 'Thank you for choosing our platform for your typing & legal assistance.',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      type: 'system',
    ),
  ];

  static const List<TestimonialModel> testimonials = [
    TestimonialModel(
      id: 't_1',
      customerName: 'Rashid Al-Kaitoob',
      customerRole: 'Managing Director, Al-Kaitoob Group',
      review: 'Exceptional service! They handled our corporate trade license renewal and Golden Visa applications with extreme efficiency and complete transparency.',
      rating: 5.0,
      isEnabled: true,
    ),
    TestimonialModel(
      id: 't_2',
      customerName: 'Claire Dupont',
      customerRole: 'Senior Marketing Director',
      review: 'Got my certified legal translation done within 18 hours for court submission. Highly professional, responsive, and trustworthy UAE agency!',
      rating: 5.0,
      isEnabled: true,
    ),
    TestimonialModel(
      id: 't_3',
      customerName: 'Tariq Al-Mansoori',
      customerRole: 'Tech Founder',
      review: 'From initial consultation to final Emirates ID stamping, the team made family visa processing completely stress-free.',
      rating: 5.0,
      isEnabled: true,
    ),
  ];

  static const List<FaqModel> faqs = [
    FaqModel(
      id: 'faq_1',
      question: 'What documents are needed for UAE Golden Visa application?',
      answer: 'Generally you need a valid passport scan, bank statements, current UAE visa (if applicable), and qualifying criteria proof such as an attested degree certificate or property deed.',
      category: 'Visa Services',
      isEnabled: true,
    ),
    FaqModel(
      id: 'faq_2',
      question: 'How long does Legal Certified Translation take?',
      answer: 'Standard translation takes 24 hours. Express same-day service (4-6 hours) is also available for urgent court or embassy filings.',
      category: 'Translation Services',
      isEnabled: true,
    ),
    FaqModel(
      id: 'faq_3',
      question: 'Are your translations officially accepted by UAE Ministries?',
      answer: 'Yes! All our translations are carried out by Ministry of Justice certified sworn translators and accepted by courts, embassies, MOFA, and government departments.',
      category: 'Translation Services',
      isEnabled: true,
    ),
    FaqModel(
      id: 'faq_4',
      question: 'Can I track my request status online?',
      answer: 'Yes. Every service request receives a unique tracking ID (#REQ-2026-XXXX). You can view step-by-step progress and document updates anytime under "My Requests".',
      category: 'General',
      isEnabled: true,
    ),
  ];

  static final List<BlogModel> blogPosts = [
    BlogModel(
      id: 'blog_1',
      title: 'Complete Guide to UAE Golden Visa Requirements in 2026',
      shortDescription: 'Everything you need to know about 10-year residency for professionals, investors, and engineers.',
      content: 'The UAE Golden Visa offers long-term residency to eligible individuals... In 2026, eligibility pathways have expanded to include software engineers, senior executives with salaries above AED 30,000, and property investors with real estate valued at AED 2M+.',
      category: 'Residency & Visa',
      author: 'Admin Editorial',
      publishDate: DateTime.now().subtract(const Duration(days: 10)),
      status: 'Published',
    ),
    BlogModel(
      id: 'blog_2',
      title: 'Understanding Legal Attestation vs Certified Translation',
      shortDescription: 'Learn the differences between MOFA attestation and Ministry of Justice translation.',
      content: 'When submitting foreign documents in the UAE, you often need both MOFA attestation and legal translation...',
      category: 'Document Processing',
      author: 'Legal Desk',
      publishDate: DateTime.now().subtract(const Duration(days: 20)),
      status: 'Published',
    ),
  ];

  static const SettingsModel settings = SettingsModel(
    businessName: 'Apex Typing & Document Services',
    phone: '+971 4 399 8877',
    whatsapp: '+971 50 888 9900',
    email: 'info@apexservices.ae',
    address: 'Suite 408, Al Moosa Tower 2, Sheikh Zayed Road, Dubai, UAE',
    workingHours: 'Mon - Sat: 8:00 AM - 7:00 PM (GST)',
    instagramUrl: 'https://instagram.com/apexservices_ae',
    facebookUrl: 'https://facebook.com/apexservicesae',
    linkedinUrl: 'https://linkedin.com/company/apexservicesae',
    youtubeUrl: 'https://youtube.com/@apexservicesae',
  );
}
