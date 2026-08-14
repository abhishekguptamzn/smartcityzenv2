import 'package:flutter/material.dart';

enum CivicCategory {
  all,
  healthcare,
  libraries,
  gyms,
  yoga,
  dance,
  coaching,
  aquatics,
  heritage,
  transit,
  emergency,
  civicOffices,
}

class CivicServiceItem {
  const CivicServiceItem({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.badges,
    required this.location,
    required this.timings,
    this.phone,
    this.facilityKind,
    this.amenities = const [],
    this.featuredCenters = const [],
    this.routePath,
  });

  final String id;
  final CivicCategory category;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final List<String> badges;
  final String location;
  final String timings;
  final String? phone;
  final String? facilityKind; // 'library' or 'gym'
  final List<String> amenities;
  final List<String> featuredCenters;
  final String? routePath;
}

final List<CivicServiceItem> kCivicServicesCatalog = [
  // 1. HOSPITALS & HEALTHCARE
  const CivicServiceItem(
    id: 'hosp-01',
    category: CivicCategory.healthcare,
    title: 'District Civil & Multispecialty Hospital',
    subtitle: '24/7 Emergency, Trauma, ICU & Specialized OPD',
    description:
        'The central municipal healthcare institution providing comprehensive medical care, advanced pathology, digital X-Ray, CT Scan, emergency trauma center, and 24-hour pharmacy.',
    icon: Icons.local_hospital_rounded,
    gradientColors: [Color(0xFFE11D48), Color(0xFFFB7185)],
    badges: ['24/7 Emergency', 'Govt Subsidized', 'Free Medicine Desk'],
    location: 'Civil Lines, Medical Enclave (Ward 4)',
    timings: 'Emergency: 24/7 | OPD: 8:00 AM - 2:00 PM',
    phone: '108',
    amenities: [
      '24/7 Emergency Trauma ICU',
      'Blood Bank & Dialysis Unit',
      'Free Generic Pharmacy',
      'Pediatric & Neonatal Care',
      'Digital Diagnostics & ECG',
    ],
    featuredCenters: [
      'Central Civil Hospital, Ward 4',
      'South City Super-Specialty Unit',
      'North Zone Emergency Trauma Hub',
    ],
  ),
  const CivicServiceItem(
    id: 'hosp-02',
    category: CivicCategory.healthcare,
    title: 'Urban Primary Health Centers (UPHC)',
    subtitle: 'Routine Health Checkups, Mother Care & Vaccination',
    description:
        'Neighborhood health clinics offering preventive healthcare, universal immunization for infants, maternal care, diabetes/BP screening, and routine doctor consultations.',
    icon: Icons.health_and_safety_rounded,
    gradientColors: [Color(0xFF059669), Color(0xFF34D399)],
    badges: ['Walk-in OPD', 'Free Immunization', 'Ward Level'],
    location: 'Multiple Centers across Wards 1 to 24',
    timings: 'Mon - Sat: 9:00 AM - 4:00 PM',
    phone: '011-24567890',
    amenities: [
      'Free Doctor Consultations',
      'Child Immunization Program',
      'Maternal Health Counseling',
      'Essential Diagnostic Tests',
    ],
    featuredCenters: [
      'UPHC Sector 7',
      'UPHC Gandhi Nagar',
      'UPHC Model Town',
      'UPHC Station Road',
    ],
  ),
  const CivicServiceItem(
    id: 'hosp-03',
    category: CivicCategory.healthcare,
    title: 'Municipal 24x7 Blood Bank & Dialysis Unit',
    subtitle: 'Blood Component Separation & Subsidized Dialysis',
    description:
        'Modern civic blood storage with component separation facility (PRBC, Platelets, FFP) and subsidized 24-seat hemodialysis center for citizens.',
    icon: Icons.bloodtype_rounded,
    gradientColors: [Color(0xFFDC2626), Color(0xFFF87171)],
    badges: ['24/7 Available', 'Voluntary Donation', 'NABH Accredited'],
    location: 'Red Cross Bhawan, Hospital Road',
    timings: 'Open 24 Hours (All 365 Days)',
    phone: '104',
    amenities: [
      'Platelet & FFP Separation',
      'Subsidized Hemodialysis',
      'Rare Blood Group Registry',
      'Mobile Blood Donation Van',
    ],
    featuredCenters: [
      'Central Blood Bank, Hospital Road',
      'Red Cross Regional Unit',
    ],
  ),

  // 2. LIBRARIES
  const CivicServiceItem(
    id: 'lib-01',
    category: CivicCategory.libraries,
    title: 'Public Central Library & Digital Study Hall',
    subtitle: 'Over 100,000 Books, e-Journals & Silent Reading Rooms',
    description:
        'Flagship municipal public library equipped with vast reference archives, competitive exam study spaces, high-speed digital e-Library computers, and RFID book lending.',
    icon: Icons.local_library_rounded,
    gradientColors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
    badges: ['Active Facility', 'Free High-Speed WiFi', 'RFID Lending'],
    location: 'Civic Cultural Complex, Town Hall Road',
    timings: 'Mon - Sun: 7:00 AM - 10:00 PM',
    phone: '011-23381234',
    facilityKind: 'library',
    amenities: [
      'Silent Air-Conditioned Study Halls',
      'Digital e-Resource Computers',
      'National & International Periodicals',
      'Competitive Exam Section (UPSC, State PSC, JEE)',
      'Cafeteria & Book Return Drop-box',
    ],
    featuredCenters: [
      'Central Public Library, Town Hall',
      'East City Study Pavilion, Sector 12',
      'Children & Youth Reading Center, Model Town',
    ],
  ),
  const CivicServiceItem(
    id: 'lib-02',
    category: CivicCategory.libraries,
    title: 'Children’s Digital Library & Creative Lounge',
    subtitle: 'Interactive STEM Learning, Storytelling & Audiobooks',
    description:
        'Dedicated library space for children and young adults featuring illustrated storybooks, STEM robotics kits, multimedia educational tablets, and weekend storytelling workshops.',
    icon: Icons.auto_stories_rounded,
    gradientColors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
    badges: ['Kids Friendly', 'STEM Learning', 'Weekend Activities'],
    location: 'Bal Bhawan Complex, Lake Road',
    timings: 'Tue - Sun: 10:00 AM - 7:00 PM',
    phone: '011-23385678',
    facilityKind: 'library',
    amenities: [
      'Children’s Literature & Comics',
      'Interactive Learning Tablets',
      'Robotics & Science Activity Corner',
      'Audio-Visual Storytelling Room',
    ],
  ),

  // 3. GYMS & FITNESS
  const CivicServiceItem(
    id: 'gym-01',
    category: CivicCategory.gyms,
    title: 'Municipal Fitness Center & Sports Arena',
    subtitle: 'State-of-the-Art Cardio, Strength & Crossfit Zone',
    description:
        'Fully equipped civic fitness center featuring modern cardio treadmills, Olympic free weights, resistance machines, certified personal trainers, and shower facilities.',
    icon: Icons.fitness_center_rounded,
    gradientColors: [Color(0xFF4F46E5), Color(0xFF818CF8)],
    badges: ['Active Facility', 'Certified Trainers', 'Citizen Pass Eligible'],
    location: 'Municipal Sports Complex, Stadium Road',
    timings: 'Morning: 5:30 AM - 11:00 AM | Evening: 4:30 PM - 9:30 PM',
    phone: '011-25591234',
    facilityKind: 'gym',
    amenities: [
      'Imported Cardio & Strength Equipment',
      'Crossfit & Functional Training Rig',
      'Certified Fitness Instructors',
      'Locker & Shower Rooms',
      'Body Composition Analyzer',
    ],
    featuredCenters: [
      'Central Sports Arena, Stadium Road',
      'Green Park Civic Gym, Sector 4',
      'West Zone Strength Pavilion',
    ],
  ),
  const CivicServiceItem(
    id: 'gym-02',
    category: CivicCategory.gyms,
    title: 'Women’s Dedicated Fitness & Wellness Pavilion',
    subtitle: 'Private Fitness Space with Aerobics & Strength Training',
    description:
        'Exclusive civic fitness center managed by female certified trainers, offering aerobics, zumba, cardio training, strength conditioning, and nutritional counseling.',
    icon: Icons.sports_gymnastics_rounded,
    gradientColors: [Color(0xFFD946EF), Color(0xFFF472B6)],
    badges: ['Women Exclusive', 'Female Trainers', 'Aerobics & Zumba'],
    location: 'Mahila Kalyan Complex, Sector 9',
    timings: 'Morning: 6:00 AM - 11:30 AM | Evening: 4:00 PM - 8:30 PM',
    phone: '011-25595678',
    facilityKind: 'gym',
    amenities: [
      'Cardio & Resistance Machines',
      'Aerobics & Zumba Studio',
      'Safe & Secure Private Campus',
      'Nutrition & Diet Counseling',
    ],
  ),

  // 4. YOGA & MEDITATION
  const CivicServiceItem(
    id: 'yoga-01',
    category: CivicCategory.yoga,
    title: 'Civic Yoga Shala & Wellness Pavilion',
    subtitle: 'Daily Morning & Evening Yoga, Pranayama & Asana Sessions',
    description:
        'Serene open-air and indoor civic wellness pavilions surrounded by greenery, offering guided Hatha Yoga, Surya Namaskar, Pranayama breathing, and meditation classes.',
    icon: Icons.self_improvement_rounded,
    gradientColors: [Color(0xFFEA580C), Color(0xFFFB923C)],
    badges: ['Free Public Entry', 'Certified Gurus', 'Lush Green Campus'],
    location: 'City Eco Park & Lakefront Promenade',
    timings: 'Morning: 6:00 AM - 9:00 AM | Evening: 5:00 PM - 7:30 PM',
    phone: '011-26611234',
    amenities: [
      'Large Open-Air Wooden Deck',
      'Weatherproof Indoor Yoga Hall',
      'Complimentary Yoga Mats & Props',
      'Pranayama & Meditation Guides',
      'Ayurvedic Herbal Water Dispensers',
    ],
    featuredCenters: [
      'Lakefront Yoga Shala, Sector 3',
      'Botanical Gardens Meditation Pavillion',
      'Central Park Wellness Gazebo',
    ],
  ),
  const CivicServiceItem(
    id: 'yoga-02',
    category: CivicCategory.yoga,
    title: 'Senior Citizens Mindfulness & Holistic Club',
    subtitle: 'Gentle Stretching, Joint Mobility & Mind-Body Wellness',
    description:
        'Specialized wellness club designed for senior citizens, focusing on chair yoga, gentle joint mobility, laughter yoga therapy, and therapeutic mindfulness.',
    icon: Icons.spa_rounded,
    gradientColors: [Color(0xFF0D9488), Color(0xFF5EEAD4)],
    badges: ['Senior Friendly', 'Therapeutic Yoga', 'Health Checkups'],
    location: 'Senior Citizen Suvidha Kendra, Civil Lines',
    timings: 'Mon - Sat: 7:00 AM - 10:30 AM',
    phone: '011-26615678',
    amenities: [
      'Zero-Strain Joint Exercises',
      'Laughter Therapy Sessions',
      'Monthly Geriatric Health Checks',
      'Tea & Social Discussion Corner',
    ],
  ),

  // 5. DANCE & PERFORMING ARTS
  const CivicServiceItem(
    id: 'dance-01',
    category: CivicCategory.dance,
    title: 'Municipal Sangeet & Natya Kala Academy',
    subtitle: 'Kathak, Bharatnatyam, Classical Music & Drama Studios',
    description:
        'Premier municipal cultural institution fostering classical and folk performing arts, offering diploma courses in classical dance, Hindustani classical vocal, tabla, and theatre arts.',
    icon: Icons.theater_comedy_rounded,
    gradientColors: [Color(0xFF9333EA), Color(0xFFC084FC)],
    badges: ['Govt Certified Diploma', 'Renowned Gurus', 'Auditorium'],
    location: 'Kala Bhawan, Cultural Circle',
    timings: 'Tue - Sun: 10:00 AM - 7:30 PM',
    phone: '011-27711234',
    amenities: [
      'Acoustic Wooden Dance Rehearsal Floors',
      'Sound Recording & Music Studio',
      '500-Seater Proscenium Auditorium',
      'Costume & Instrument Lending Library',
    ],
    featuredCenters: [
      'Central Kala Bhawan, Cultural Circle',
      'West Zone Sangeet Kendra, Model Town',
    ],
  ),
  const CivicServiceItem(
    id: 'dance-02',
    category: CivicCategory.dance,
    title: 'Contemporary Dance, Aerobics & Folk Studio',
    subtitle: 'Hip-Hop, Bollywood, Zumba & Regional Folk Workshops',
    description:
        'Dynamic civic dance studio conducting energetic evening batches in contemporary dance, hip-hop, folk dance, and musical choreography for children, youth, and adults.',
    icon: Icons.music_note_rounded,
    gradientColors: [Color(0xFFDB2777), Color(0xFFF472B6)],
    badges: ['Youth & Kids Batches', 'Weekend Workshops', 'Stage Shows'],
    location: 'Youth Community Center, Ward 8',
    timings: 'Mon - Sat: 4:00 PM - 8:30 PM',
    phone: '011-27715678',
    amenities: [
      'Full-Wall Mirrored Studios',
      'High-Power Surround Audio System',
      'Air-Conditioned Practice Halls',
      'Annual Civic Cultural Showcase',
    ],
  ),

  // 6. COACHING & SKILL DEVELOPMENT
  const CivicServiceItem(
    id: 'coach-01',
    category: CivicCategory.coaching,
    title: 'Civic Civil Services & Competitive Exam Academy',
    subtitle: 'Free Mentorship for UPSC, State PSC, SSC & Banking Exams',
    description:
        'Government-backed civil services coaching institute providing free guidance, mock test series, current affairs seminars, and interview prep by retired IAS/IPS officers.',
    icon: Icons.school_rounded,
    gradientColors: [Color(0xFF2563EB), Color(0xFF60A5FA)],
    badges: ['Free Guidance', 'Mock Test Series', 'IAS Mentorship'],
    location: 'Shiksha Bhawan, University Enclave',
    timings: 'Mon - Sat: 8:30 AM - 7:00 PM',
    phone: '011-28811234',
    amenities: [
      'Smart Digital Lecture Rooms',
      'Extensive UPSC Reference Library',
      'Weekly All-India Mock Tests',
      'Personalized Interview Mentorship',
    ],
    featuredCenters: [
      'Central Civil Exam Hub, University Enclave',
      'District Study Center, Sector 15',
    ],
  ),
  const CivicServiceItem(
    id: 'coach-02',
    category: CivicCategory.coaching,
    title: 'Civic Digital Coding, AI & Robotics Lab',
    subtitle: 'Hands-on Software Development, Robotics & Cyber Skills',
    description:
        'Modern computer lab providing subsidized certification courses in Python, Web Development, Cloud Computing, Artificial Intelligence, and Robotics for students and job seekers.',
    icon: Icons.terminal_rounded,
    gradientColors: [Color(0xFF0891B2), Color(0xFF22D3EE)],
    badges: ['Industry Certified', 'High-End PCs', 'Placement Support'],
    location: 'IT Park Municipal Innovation Hub',
    timings: 'Mon - Sat: 9:00 AM - 6:00 PM',
    phone: '011-28815678',
    amenities: [
      'Dual-Monitor Developer Workstations',
      'Gigabit Fiber Internet Connectivity',
      'Robotics & IoT Prototyping Kits',
      'Industry Internship Programs',
    ],
  ),

  // 7. SWIMMING & AQUATICS
  const CivicServiceItem(
    id: 'swim-01',
    category: CivicCategory.aquatics,
    title: 'Civic Olympic Aquatic Stadium & Pool',
    subtitle: '50-Meter Heated Olympic Pool & Diving Pavilion',
    description:
        'World-class municipal aquatic complex featuring 50m 10-lane competition pool, 25m warm-up pool, diving platforms, certified lifeguards, and clean ozone-purified water.',
    icon: Icons.pool_rounded,
    gradientColors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
    badges: ['Olympic Size', 'Certified Lifeguards', 'Ozone Purified'],
    location: 'Sports Complex, Outer Ring Road',
    timings: 'Morning: 6:00 AM - 10:30 AM | Evening: 4:00 PM - 8:30 PM',
    phone: '011-29911234',
    amenities: [
      '50m Heated Olympic Swimming Pool',
      '10m Diving Tower & Springboards',
      'Children’s Shallow Splash Pool',
      'Separate Male/Female Locker Rooms',
      'On-deck Professional Lifeguards',
    ],
  ),

  // 8. HERITAGE & CITY ATTRACTIONS
  const CivicServiceItem(
    id: 'heritage-01',
    category: CivicCategory.heritage,
    title: 'City Heritage Museum & Art Gallery',
    subtitle: 'Ancient Artifacts, Numismatics & Art Exhibitions',
    description:
        'Renowned museum showcasing prehistoric artifacts, royal memorabilia, sculpture galleries, coins, miniature paintings, and modern art exhibitions.',
    icon: Icons.museum_rounded,
    gradientColors: [Color(0xFFD97706), Color(0xFFFBBF24)],
    badges: ['Historic Landmark', 'Audio Guide Available', 'Wheelchair Accessible'],
    location: 'Old Palace Complex, Heritage Circle',
    timings: 'Tue - Sun: 10:00 AM - 5:30 PM (Closed Mondays)',
    phone: '011-21111234',
    routePath: '/city/heritage',
    amenities: [
      'Audio Guide in 5 Languages',
      'Interactive 3D Virtual Gallery',
      'Museum Souvenir & Book Store',
      'Cafeteria with Palace View',
    ],
  ),

  // 9. PUBLIC TRANSPORT & TRANSIT
  const CivicServiceItem(
    id: 'transit-01',
    category: CivicCategory.transit,
    title: 'City Smart Metro & Transit Interchange',
    subtitle: 'Integrated Metro Lines, AC Feeder Buses & EV Charging Hub',
    description:
        'Central multi-modal transit hub connecting metro railway lines, intercity buses, smart EV rapid charging stations, and automated public bicycle sharing docks.',
    icon: Icons.directions_subway_rounded,
    gradientColors: [Color(0xFF2563EB), Color(0xFF38BDF8)],
    badges: ['24/7 Transit', 'Smart Card Enabled', 'High Frequency'],
    location: 'Central Railway & Metro Junction',
    timings: 'Metro: 5:30 AM - 11:30 PM | Buses: 24/7',
    phone: '1800-180-1234',
    amenities: [
      'Smart Card & QR Ticketing Gates',
      'Fast EV Charging Stations (60kW)',
      'Public Bicycle Sharing Docks',
      '24/7 CCTV & Security Assistance',
    ],
  ),

  // 10. EMERGENCY & CITIZEN SAFETY
  const CivicServiceItem(
    id: 'emerg-01',
    category: CivicCategory.emergency,
    title: '24/7 Police & Emergency Response Control (112)',
    subtitle: 'Unified Emergency Dispatch for Police, Fire & Medical Support',
    description:
        'State-of-the-art centralized command and control center for rapid police dispatch, emergency SOS response, mobile patrol coordination, and citizen safety assistance.',
    icon: Icons.local_police_rounded,
    gradientColors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    badges: ['Toll-Free 112', 'Immediate Dispatch', 'GPS Tracking'],
    location: 'Police Commissionerate Headquarters',
    timings: 'Open 24 Hours, 365 Days',
    phone: '112',
    amenities: [
      'Average 7-Minute PCR Van Response',
      'Women Safety Dispatch Unit',
      'Cybercrime & Fraud Reporting Cell',
      'GPS Emergency Location Tracking',
    ],
  ),
  const CivicServiceItem(
    id: 'emerg-02',
    category: CivicCategory.emergency,
    title: 'Fire & Disaster Rescue Headquarters (101)',
    subtitle: 'Rapid Fire Suppression, Hazardous Spill & Flood Rescue',
    description:
        'Municipal fire rescue headquarters equipped with hydraulic turntable ladders, advanced foam tenders, chemical rescue kits, and flood relief boats.',
    icon: Icons.fire_truck_rounded,
    gradientColors: [Color(0xFFEA580C), Color(0xFFEF4444)],
    badges: ['Toll-Free 101', 'High-Rise Rescue', '24/7 Alert'],
    location: 'Central Fire Station, Ring Road',
    timings: 'Open 24 Hours, 365 Days',
    phone: '101',
    amenities: [
      '60m Hydraulic Turntable Ladders',
      'Hazardous Material Mitigation Unit',
      'Swift Water Flood Rescue Boats',
      'Smoke Extraction & Thermal Cameras',
    ],
  ),

  // 11. CIVIC SUVIDHA CENTERS
  const CivicServiceItem(
    id: 'civic-01',
    category: CivicCategory.civicOffices,
    title: 'Municipal Citizen Suvidha & Ward Office',
    subtitle: 'Property Tax, Trade License, Water Connection & Grievance',
    description:
        'Single-window citizen service center for paying property tax and water bills, applying for trade licenses, registering birth/death certificates, and submitting civic grievances.',
    icon: Icons.domain_rounded,
    gradientColors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
    badges: ['Single Window', 'Online Appointments', 'Token System'],
    location: 'Nagar Nigam Bhawan, Ward 1 to 24 Offices',
    timings: 'Mon - Sat: 9:30 AM - 5:00 PM',
    phone: '011-23341234',
    amenities: [
      'Automated Token Dispensing System',
      'Cashless Payment POS Machines',
      'Senior Citizen & Specially-Abled Desk',
      'Online Certificate Download Kiosks',
    ],
    featuredCenters: [
      'Central Corporation Office, Town Hall',
      'North Zone Suvidha Kendra, Sector 14',
      'South Zone Suvidha Kendra, Model Town',
    ],
  ),
];
