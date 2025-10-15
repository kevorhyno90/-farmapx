class Poultry {
  final String id;
  final String tag;
  final String species;
  final String breed;
  final String dob;
  final String sex;
  final String purpose;

  Poultry({required this.id, required this.tag, this.species = '', this.breed = '', this.dob = '', this.sex = '', this.purpose = ''});
}
