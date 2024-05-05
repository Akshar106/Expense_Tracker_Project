import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExpenseTrackerHomePage(),
    );
  }
}

class ExpenseTrackerHomePage extends StatefulWidget {
  @override
  _ExpenseTrackerHomePageState createState() => _ExpenseTrackerHomePageState();
}

class _ExpenseTrackerHomePageState extends State<ExpenseTrackerHomePage> {
  List<Map<String, dynamic>> expenses = [];
  double totalMoney = 0;

  void _addExpense(String title, double amount) {
    setState(() {
      expenses.add({'title': title, 'amount': amount, 'time': DateTime.now()});
      totalMoney -= amount;
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      totalMoney += expenses[index]['amount'];
      expenses.removeAt(index);
    });
  }

  void _startAddNewExpense(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewExpense(_addExpense);
      },
    );
  }

  void _startDeleteExpense(BuildContext ctx, int index) {
    showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: Text('Delete Expense'),
          content: Text('Are you sure you want to delete this expense?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteExpense(index);
                Navigator.of(ctx).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _startAddTotalMoney(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: Text('Add Total Money'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                totalMoney = double.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _startAddNewExpense(ctx);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _startAddMoreMoney(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) {
        return AlertDialog(
          title: Text('Add More Money'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                totalMoney += double.tryParse(value) ?? 0;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.blue,
            child: Text(
              'Total Money: \$${totalMoney.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            '\$${expenses[index]['amount']}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      expenses[index]['title'],
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'Added on: ${expenses[index]['time'].toString()}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        _startDeleteExpense(context, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _startAddTotalMoney(context);
            },
            tooltip: 'Add Total Money',
            label: Text('Add Total Money'),
            icon: Icon(Icons.attach_money),
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: () {
              _startAddNewExpense(context);
            },
            tooltip: 'Add Expense',
            label: Text('Add Expense'),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class NewExpense extends StatelessWidget {
  final Function addExpense;

  NewExpense(this.addExpense);

  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void submitData(BuildContext context) {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    addExpense(enteredTitle, enteredAmount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(context),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(context),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => submitData(context),
                child: Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
