import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class GetTsxBetween extends StatefulWidget {
  const GetTsxBetween(this.transactions, {super.key});
  final List<Transaction> transactions;

  @override
  State<GetTsxBetween> createState() => _GetTsxBetweenState();
}

class _GetTsxBetweenState extends State<GetTsxBetween> {
  DateTime _firstDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _secondDate = DateTime.now();

  void _selectFirstDate() {
    showDatePicker(
            locale: const Locale('tr', 'TR'),
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _firstDate = DateTime(value.year, value.month, value.day);
      });
    });
  }

  void _selectSecondDate() {
    showDatePicker(
            locale: const Locale('tr', 'TR'),
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _secondDate = value;
      });
    });
  }

  List<Transaction> get _transactions {
    return widget.transactions.where((transaction) {
      return transaction.date.isAfter(_firstDate) &&
          transaction.date.isBefore(_secondDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double amountTsx = 0;
    for (var element in _transactions) {
      amountTsx += element.amount;
    }
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 30, bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(50, 20, 50, 20))),
                      onPressed: _selectFirstDate,
                      child: const Text("Tarih Seç")),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                        "Başlangıç: ${DateFormat.yMMMd('tr').format(_firstDate)}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  )
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.fromLTRB(50, 20, 50, 20))),
                      onPressed: _selectSecondDate,
                      child: const Text("Tarih Seç")),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Başlangıç: ${DateFormat.yMMMd('tr').format(_secondDate)}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.fromLTRB(50, 20, 50, 20))),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Text(
                            "${DateFormat.yMMMd('tr').format(_firstDate)} günü ile ${DateFormat.yMMMd('tr').format(_secondDate)} günü arasında yaptığınız toplam harcama: ₺$amountTsx",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Card(
                            margin: const EdgeInsets.only(top: 15),
                            child: ListView.builder(
                              itemCount: _transactions.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 8,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: FittedBox(
                                          child: Text(
                                              "₺${_transactions[index].amount.toStringAsFixed(2)} TL"),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _transactions[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    subtitle: Text(
                                      DateFormat.yMMMd('tr')
                                          .add_jms()
                                          .format(_transactions[index].date),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: const Text("Göster")),
      ],
    );
  }
}
