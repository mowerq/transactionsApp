import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/transaction.dart';
import 'package:flutter_application_2/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;
  Chart(this._recentTransactions, {super.key});

  List<Map<String, Object>> get groupDailyTransactions {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        double totalAmount = 0.0;
        List<Transaction> dailyTransactions = [];
        for (var i = 0; i < _recentTransactions.length; i++) {
          if (_recentTransactions[i].date.day == weekDay.day &&
              _recentTransactions[i].date.month == weekDay.month &&
              _recentTransactions[i].date.year == weekDay.year) {
            dailyTransactions.add(_recentTransactions[i]);
            totalAmount += _recentTransactions[i].amount;
          }
        }
        return {
          "day": DateFormat.E('tr').format(weekDay),
          "amount": totalAmount,
          "transactions": dailyTransactions
        };
      },
    ).reversed.toList();
  }

  double get sumTotal {
    return groupDailyTransactions.fold(0.0, (sum, element) {
      return sum += (element["amount"] as double);
    });
  }

  final _daysLong = {
    "Pzt": "Pazartesi",
    "Sal": "Salı",
    "Çar": "Çarşamba",
    "Per": "Perşembe",
    "Cum": "Cuma",
    "Cmt": "Cumartesi",
    "Paz": "Pazar"
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupDailyTransactions.map((data) {
            return Expanded(
              child: TextButton(
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      List<Transaction> tsx =
                          data["transactions"] as List<Transaction>;
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                            child: Text(
                              "${_daysLong[data["day"]]} günü yaptığınız toplam harcama: ₺${data["amount"]}",
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
                                itemCount: tsx.length,
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
                                                "₺${tsx[index].amount.toStringAsFixed(2)} TL"),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        tsx[index].title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      subtitle: Text(
                                        DateFormat.yMMMd('tr')
                                            .add_jms()
                                            .format(tsx[index].date),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                child: ChartBar(
                    data["day"].toString(),
                    (data["amount"] as double),
                    (sumTotal == 0.0)
                        ? 0.0
                        : (data["amount"] as double) / sumTotal),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
