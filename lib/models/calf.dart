class Calf {
  final String id;
  final String tag;
  final String damId;
  final String sireId;
  final String dob;
  final String sex;
  final String status;

  Calf({required this.id, required this.tag, this.damId = '', this.sireId = '', this.dob = '', this.sex = '', this.status = ''});
}
