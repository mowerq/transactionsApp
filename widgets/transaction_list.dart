import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList(this.transactions, this.deleteTransaction, {super.key});
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: constraints.maxHeight * 0.9,
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 40),
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                  child: const Text(
                    "Henüz hiç gider kaydetmediniz!",
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              /*return Card(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.purple),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          "₺${transactions[index].amount.toStringAsFixed(2)} TL",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transactions[index].title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            DateFormat().format(transactions[index].date),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                );*/
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                          child: Text(
                              "₺${transactions[index].amount.toStringAsFixed(2)} TL")),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd('tr')
                        .add_jms()
                        .format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? TextButton.icon(
                          onPressed: () {
                            deleteTransaction(transactions[index]);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Sil"),
                        )
                      : IconButton(
                          onPressed: () {
                            deleteTransaction(transactions[index]);
                          },
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).primaryColor,
                        ),
                ),
              );
            },
          );
  }
}
