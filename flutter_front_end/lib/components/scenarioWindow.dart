import 'package:flutter/material.dart';

class scenarioWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/scenarioCreator'),
        child: const Icon(Icons.add),
        tooltip: 'Create a scenario',
        backgroundColor: Colors.deepPurple[200],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.deepPurple[200],
        child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.ac_unit),
                  tooltip: 'Have some AC',
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                  tooltip: 'Love Me',
                )
              ],
            )),
      ),
    );
  }
}
