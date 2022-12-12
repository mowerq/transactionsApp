import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  Function addNewTransaction;
  NewTransaction(this.addNewTransaction, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void addTransaction() {
    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text;
    if (enteredAmount != "" && enteredTitle != "") {
      widget.addNewTransaction(enteredTitle, enteredAmount, _selectedDate);
    }
  }

  void _selectDate() {
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
        _selectedDate = value;
        _selectedDate = _selectedDate.add(const Duration(hours: 12));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 7,
        child: Container(
          padding: EdgeInsets.fromLTRB(
              15, 15, 15, MediaQuery.of(context).viewInsets.bottom),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              decoration: const InputDecoration(labelText: "Ne aldın: "),
              controller: _titleController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Kaç TL: "),
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onSubmitted: (value) => addTransaction(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        "Seçtiğiniz tarih: ${DateFormat.yMMMd('tr').format(_selectedDate)}"),
                  ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text("Tarih seç"),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: addTransaction,
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(
                  EdgeInsets.all(25),
                ),
              ),
              child: const Text(
                "Kaydet",
                style: TextStyle(fontSize: 16, color: Colors.purple),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
