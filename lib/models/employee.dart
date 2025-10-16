enum EmploymentType { full_time, part_time, seasonal, contract, volunteer }
enum EmployeeStatus { active, inactive, on_leave, terminated }

class PayrollRecord {
  final String id;
  final DateTime payPeriodStart;
  final DateTime payPeriodEnd;
  final double hoursWorked;
  final double regularHours;
  final double overtimeHours;
  final double hourlyRate;
  final double overtimeRate;
  final double grossPay;
  final double deductions;
  final double netPay;
  final DateTime payDate;
  final String? notes;

  PayrollRecord({
    required this.id,
    required this.payPeriodStart,
    required this.payPeriodEnd,
    required this.hoursWorked,
    required this.regularHours,
    required this.overtimeHours,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.grossPay,
    required this.deductions,
    required this.netPay,
    required this.payDate,
    this.notes,
  });
}

class TimeRecord {
  final String id;
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final double hoursWorked;
  final String activity; // milking, feeding, field work, etc.
  final String? location;
  final String? notes;
  final bool isOvertime;

  TimeRecord({
    required this.id,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.hoursWorked,
    required this.activity,
    this.location,
    this.notes,
    this.isOvertime = false,
  });
}

class PerformanceReview {
  final String id;
  final DateTime date;
  final String reviewType; // annual, quarterly, monthly
  final double overallRating; // 1-5 scale
  final Map<String, double> skillRatings; // skill -> rating
  final String strengths;
  final String areasForImprovement;
  final String goals;
  final String reviewerId;
  final String? notes;

  PerformanceReview({
    required this.id,
    required this.date,
    required this.reviewType,
    required this.overallRating,
    required this.skillRatings,
    required this.strengths,
    required this.areasForImprovement,
    required this.goals,
    required this.reviewerId,
    this.notes,
  });
}

class Employee {
  final String id;
  final String employeeNumber;
  final String firstName;
  final String lastName;
  final String role;
  final String department;
  final EmploymentType employmentType;
  final EmployeeStatus status;
  final DateTime hireDate;
  final DateTime? terminationDate;
  final String? email;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? emergencyContact;
  final String? emergencyPhone;
  final double hourlyRate;
  final double? salary; // annual salary if not hourly
  final List<String> skills;
  final List<String> certifications;
  final String? supervisor;
  final List<TimeRecord> timeRecords;
  final List<PayrollRecord> payrollRecords;
  final List<PerformanceReview> performanceReviews;
  final String? notes;
  final bool isActive;

  Employee({
    required this.id,
    this.employeeNumber = '',
    required this.firstName,
    required this.lastName,
    this.role = '',
    this.department = '',
    this.employmentType = EmploymentType.full_time,
    this.status = EmployeeStatus.active,
    DateTime? hireDate,
    this.terminationDate,
    this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.emergencyContact,
    this.emergencyPhone,
    this.hourlyRate = 0.0,
    this.salary,
    List<String>? skills,
    List<String>? certifications,
    this.supervisor,
    List<TimeRecord>? timeRecords,
    List<PayrollRecord>? payrollRecords,
    List<PerformanceReview>? performanceReviews,
    this.notes,
    this.isActive = true,
  }) :
    hireDate = hireDate ?? DateTime.now(),
    skills = skills ?? [],
    certifications = certifications ?? [],
    timeRecords = timeRecords ?? [],
    payrollRecords = payrollRecords ?? [],
    performanceReviews = performanceReviews ?? [];

  // Legacy constructor for backward compatibility
  Employee.legacy({required this.id, required String name, this.role = ''}) :
    employeeNumber = '',
    firstName = name.split(' ').first,
    lastName = name.split(' ').length > 1 ? name.split(' ').sublist(1).join(' ') : '',
    department = '',
    employmentType = EmploymentType.full_time,
    status = EmployeeStatus.active,
    hireDate = DateTime.now(),
    terminationDate = null,
    email = null,
    phone = null,
    address = null,
    dateOfBirth = null,
    emergencyContact = null,
    emergencyPhone = null,
    hourlyRate = 0.0,
    salary = null,
    skills = [],
    certifications = [],
    supervisor = null,
    timeRecords = [],
    payrollRecords = [],
    performanceReviews = [],
    notes = null,
    isActive = true;

  // Convenience getters
  String get fullName => '$firstName $lastName'.trim();
  String get name => fullName; // For backward compatibility

  int? get yearsOfService {
    final endDate = terminationDate ?? DateTime.now();
    return endDate.difference(hireDate).inDays ~/ 365;
  }

  double get totalHoursThisMonth {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    
    return timeRecords
        .where((record) => record.date.isAfter(startOfMonth))
        .fold(0.0, (sum, record) => sum + record.hoursWorked);
  }

  double get averagePerformanceRating {
    if (performanceReviews.isEmpty) return 0.0;
    return performanceReviews
        .map((review) => review.overallRating)
        .fold(0.0, (sum, rating) => sum + rating) / performanceReviews.length;
  }

  Employee copyWith({
    String? employeeNumber,
    String? firstName,
    String? lastName,
    String? role,
    String? department,
    EmploymentType? employmentType,
    EmployeeStatus? status,
    DateTime? hireDate,
    DateTime? terminationDate,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
    String? emergencyContact,
    String? emergencyPhone,
    double? hourlyRate,
    double? salary,
    List<String>? skills,
    List<String>? certifications,
    String? supervisor,
    List<TimeRecord>? timeRecords,
    List<PayrollRecord>? payrollRecords,
    List<PerformanceReview>? performanceReviews,
    String? notes,
    bool? isActive,
  }) {
    return Employee(
      id: id,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      department: department ?? this.department,
      employmentType: employmentType ?? this.employmentType,
      status: status ?? this.status,
      hireDate: hireDate ?? this.hireDate,
      terminationDate: terminationDate ?? this.terminationDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      salary: salary ?? this.salary,
      skills: skills ?? this.skills,
      certifications: certifications ?? this.certifications,
      supervisor: supervisor ?? this.supervisor,
      timeRecords: timeRecords ?? this.timeRecords,
      payrollRecords: payrollRecords ?? this.payrollRecords,
      performanceReviews: performanceReviews ?? this.performanceReviews,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}
