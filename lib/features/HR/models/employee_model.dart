// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EmployeeModel {
  int id;
  String? department_name;
  String? finger_print_code;
  bool? is_working;
  String? father_name;
  String? mother_name;
  String? first_name;
  String? last_name;
  String? dob;
  String? pob;
  String? locality;
  String? national_id;
  String? nationality;
  String? phone_number;
  String? address;
  String? gender;
  String? marital_status;
  int? number_of_children;
  bool? smokes;
  String? military_service;
  String? employment_date;
  String? quitting_date;
  String? reason_of_leave;
  String? job_title;
  String? job_role;
  String? salary_type;
  String? local_email;
  String? ins_number;
  String? ins_registration_date;
  String? ins_cancellation_date;
  String? max_admin_leaves;
  String? base_salary;
  String? ID_number;
  String? ins_salary;
  String? details;
  String? id_image;
  String? photo;
  String? ins_reg_image;
  String? academic_level;
  String? academic_major;
  EmployeeModel({
    required this.id,
    this.department_name,
    this.finger_print_code,
    this.is_working,
    this.father_name,
    this.mother_name,
    this.first_name,
    this.last_name,
    this.dob,
    this.pob,
    this.locality,
    this.national_id,
    this.nationality,
    this.phone_number,
    this.address,
    this.gender,
    this.marital_status,
    this.number_of_children,
    this.smokes,
    this.military_service,
    this.employment_date,
    this.quitting_date,
    this.reason_of_leave,
    this.job_title,
    this.job_role,
    this.salary_type,
    this.local_email,
    this.ins_number,
    this.ins_registration_date,
    this.ins_cancellation_date,
    this.max_admin_leaves,
    this.base_salary,
    this.ID_number,
    this.ins_salary,
    this.details,
    this.id_image,
    this.photo,
    this.ins_reg_image,
    this.academic_level,
    this.academic_major,
  });

  EmployeeModel copyWith({
    int? id,
    String? department_name,
    String? finger_print_code,
    bool? is_working,
    String? father_name,
    String? mother_name,
    String? first_name,
    String? last_name,
    String? dob,
    String? pob,
    String? locality,
    String? national_id,
    String? nationality,
    String? phone_number,
    String? address,
    String? gender,
    String? marital_status,
    int? number_of_children,
    bool? smokes,
    String? military_service,
    String? employment_date,
    String? quitting_date,
    String? reason_of_leave,
    String? job_title,
    String? job_role,
    String? salary_type,
    String? local_email,
    String? ins_number,
    String? ins_registration_date,
    String? ins_cancellation_date,
    String? max_admin_leaves,
    String? base_salary,
    String? ID_number,
    String? ins_salary,
    String? details,
    String? id_image,
    String? photo,
    String? ins_reg_image,
    String? academic_level,
    String? academic_major,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      department_name: department_name ?? this.department_name,
      finger_print_code: finger_print_code ?? this.finger_print_code,
      is_working: is_working ?? this.is_working,
      father_name: father_name ?? this.father_name,
      mother_name: mother_name ?? this.mother_name,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      dob: dob ?? this.dob,
      pob: pob ?? this.pob,
      locality: locality ?? this.locality,
      national_id: national_id ?? this.national_id,
      nationality: nationality ?? this.nationality,
      phone_number: phone_number ?? this.phone_number,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      marital_status: marital_status ?? this.marital_status,
      number_of_children: number_of_children ?? this.number_of_children,
      smokes: smokes ?? this.smokes,
      military_service: military_service ?? this.military_service,
      employment_date: employment_date ?? this.employment_date,
      quitting_date: quitting_date ?? this.quitting_date,
      reason_of_leave: reason_of_leave ?? this.reason_of_leave,
      job_title: job_title ?? this.job_title,
      job_role: job_role ?? this.job_role,
      salary_type: salary_type ?? this.salary_type,
      local_email: local_email ?? this.local_email,
      ins_number: ins_number ?? this.ins_number,
      ins_registration_date:
          ins_registration_date ?? this.ins_registration_date,
      ins_cancellation_date:
          ins_cancellation_date ?? this.ins_cancellation_date,
      max_admin_leaves: max_admin_leaves ?? this.max_admin_leaves,
      base_salary: base_salary ?? this.base_salary,
      ID_number: ID_number ?? this.ID_number,
      ins_salary: ins_salary ?? this.ins_salary,
      details: details ?? this.details,
      id_image: id_image ?? this.id_image,
      photo: photo ?? this.photo,
      ins_reg_image: ins_reg_image ?? this.ins_reg_image,
      academic_level: academic_level ?? this.academic_level,
      academic_major: academic_major ?? this.academic_major,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'department_name': department_name,
      'finger_print_code': finger_print_code,
      'is_working': is_working,
      'father_name': father_name,
      'mother_name': mother_name,
      'first_name': first_name,
      'last_name': last_name,
      'dob': dob,
      'pob': pob,
      'locality': locality,
      'national_id': national_id,
      'nationality': nationality,
      'phone_number': phone_number,
      'address': address,
      'gender': gender,
      'marital_status': marital_status,
      'number_of_children': number_of_children,
      'smokes': smokes,
      'military_service': military_service,
      'employment_date': employment_date,
      'quitting_date': quitting_date,
      'reason_of_leave': reason_of_leave,
      'job_title': job_title,
      'job_role': job_role,
      'salary_type': salary_type,
      'local_email': local_email,
      'ins_number': ins_number,
      'ins_registration_date': ins_registration_date,
      'ins_cancellation_date': ins_cancellation_date,
      'max_admin_leaves': max_admin_leaves,
      'base_salary': base_salary,
      'ID_number': ID_number,
      'ins_salary': ins_salary,
      'details': details,
      'id_image': id_image,
      'photo': photo,
      'ins_reg_image': ins_reg_image,
      'academic_level': academic_level,
      'academic_major': academic_major,
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as int,
      department_name: map['department_name'] != null
          ? map['department_name'] as String
          : null,
      finger_print_code: map['finger_print_code'] != null
          ? map['finger_print_code'] as String
          : null,
      is_working: map['is_working'] != null ? map['is_working'] as bool : null,
      father_name:
          map['father_name'] != null ? map['father_name'] as String : null,
      mother_name:
          map['mother_name'] != null ? map['mother_name'] as String : null,
      first_name:
          map['first_name'] != null ? map['first_name'] as String : null,
      last_name: map['last_name'] != null ? map['last_name'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      pob: map['pob'] != null ? map['pob'] as String : null,
      locality: map['locality'] != null ? map['locality'] as String : null,
      national_id:
          map['national_id'] != null ? map['national_id'] as String : null,
      nationality:
          map['nationality'] != null ? map['nationality'] as String : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      marital_status: map['marital_status'] != null
          ? map['marital_status'] as String
          : null,
      number_of_children: map['number_of_children'] != null
          ? map['number_of_children'] as int
          : null,
      smokes: map['smokes'] != null ? map['smokes'] as bool : null,
      military_service: map['military_service'] != null
          ? map['military_service'] as String
          : null,
      employment_date: map['employment_date'] != null
          ? map['employment_date'] as String
          : null,
      quitting_date:
          map['quitting_date'] != null ? map['quitting_date'] as String : null,
      reason_of_leave: map['reason_of_leave'] != null
          ? map['reason_of_leave'] as String
          : null,
      job_title: map['job_title'] != null ? map['job_title'] as String : null,
      job_role: map['job_role'] != null ? map['job_role'] as String : null,
      salary_type:
          map['salary_type'] != null ? map['salary_type'] as String : null,
      local_email:
          map['local_email'] != null ? map['local_email'] as String : null,
      ins_number:
          map['ins_number'] != null ? map['ins_number'] as String : null,
      ins_registration_date: map['ins_registration_date'] != null
          ? map['ins_registration_date'] as String
          : null,
      ins_cancellation_date: map['ins_cancellation_date'] != null
          ? map['ins_cancellation_date'] as String
          : null,
      max_admin_leaves: map['max_admin_leaves'] != null
          ? map['max_admin_leaves'] as String
          : null,
      base_salary:
          map['base_salary'] != null ? map['base_salary'] as String : null,
      ID_number: map['ID_number'] != null ? map['ID_number'] as String : null,
      ins_salary:
          map['ins_salary'] != null ? map['ins_salary'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
      id_image: map['id_image'] != null ? map['id_image'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      ins_reg_image:
          map['ins_reg_image'] != null ? map['ins_reg_image'] as String : null,
      academic_level: map['academic_level'] != null
          ? map['academic_level'] as String
          : null,
      academic_major: map['academic_major'] != null
          ? map['academic_major'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EmployeeModel.fromJson(String source) =>
      EmployeeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EmployeeModel(id: $id, department_name: $department_name, finger_print_code: $finger_print_code, is_working: $is_working, father_name: $father_name, mother_name: $mother_name, first_name: $first_name, last_name: $last_name, dob: $dob, pob: $pob, locality: $locality, national_id: $national_id, nationality: $nationality, phone_number: $phone_number, address: $address, gender: $gender, marital_status: $marital_status, number_of_children: $number_of_children, smokes: $smokes, military_service: $military_service, employment_date: $employment_date, quitting_date: $quitting_date, reason_of_leave: $reason_of_leave, job_title: $job_title, job_role: $job_role, salary_type: $salary_type, local_email: $local_email, ins_number: $ins_number, ins_registration_date: $ins_registration_date, ins_cancellation_date: $ins_cancellation_date, max_admin_leaves: $max_admin_leaves, base_salary: $base_salary, ID_number: $ID_number, ins_salary: $ins_salary, details: $details, id_image: $id_image, photo: $photo, ins_reg_image: $ins_reg_image, academic_level: $academic_level, academic_major: $academic_major)';
  }

  @override
  bool operator ==(covariant EmployeeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.department_name == department_name &&
        other.finger_print_code == finger_print_code &&
        other.is_working == is_working &&
        other.father_name == father_name &&
        other.mother_name == mother_name &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.dob == dob &&
        other.pob == pob &&
        other.locality == locality &&
        other.national_id == national_id &&
        other.nationality == nationality &&
        other.phone_number == phone_number &&
        other.address == address &&
        other.gender == gender &&
        other.marital_status == marital_status &&
        other.number_of_children == number_of_children &&
        other.smokes == smokes &&
        other.military_service == military_service &&
        other.employment_date == employment_date &&
        other.quitting_date == quitting_date &&
        other.reason_of_leave == reason_of_leave &&
        other.job_title == job_title &&
        other.job_role == job_role &&
        other.salary_type == salary_type &&
        other.local_email == local_email &&
        other.ins_number == ins_number &&
        other.ins_registration_date == ins_registration_date &&
        other.ins_cancellation_date == ins_cancellation_date &&
        other.max_admin_leaves == max_admin_leaves &&
        other.base_salary == base_salary &&
        other.ID_number == ID_number &&
        other.ins_salary == ins_salary &&
        other.details == details &&
        other.id_image == id_image &&
        other.photo == photo &&
        other.ins_reg_image == ins_reg_image &&
        other.academic_level == academic_level &&
        other.academic_major == academic_major;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        department_name.hashCode ^
        finger_print_code.hashCode ^
        is_working.hashCode ^
        father_name.hashCode ^
        mother_name.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        dob.hashCode ^
        pob.hashCode ^
        locality.hashCode ^
        national_id.hashCode ^
        nationality.hashCode ^
        phone_number.hashCode ^
        address.hashCode ^
        gender.hashCode ^
        marital_status.hashCode ^
        number_of_children.hashCode ^
        smokes.hashCode ^
        military_service.hashCode ^
        employment_date.hashCode ^
        quitting_date.hashCode ^
        reason_of_leave.hashCode ^
        job_title.hashCode ^
        job_role.hashCode ^
        salary_type.hashCode ^
        local_email.hashCode ^
        ins_number.hashCode ^
        ins_registration_date.hashCode ^
        ins_cancellation_date.hashCode ^
        max_admin_leaves.hashCode ^
        base_salary.hashCode ^
        ID_number.hashCode ^
        ins_salary.hashCode ^
        details.hashCode ^
        id_image.hashCode ^
        photo.hashCode ^
        ins_reg_image.hashCode ^
        academic_level.hashCode ^
        academic_major.hashCode;
  }
}
