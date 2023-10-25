library clisitef;

enum Modalidade {
  generic(0),
  debit(2),
  credit(3),
  voucher(5),
  test(6);

  const Modalidade(this.value);
  final int value;
}
