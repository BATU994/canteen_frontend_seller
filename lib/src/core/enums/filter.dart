enum Filter {
  all('Все'),
  drinks('Напитки'),
  foods('Еда'),
  deserts('Десерты'),
  others('Другие');

  final String label;
  const Filter(this.label);
}
