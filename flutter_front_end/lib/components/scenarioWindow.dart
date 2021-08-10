import 'package:flutter/material.dart';

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final Icon initials;
}

class scenarioWindow extends StatefulWidget {
  const scenarioWindow({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => scenarioWindowState();
}

class scenarioWindowState extends State<scenarioWindow> {
  final List<ActorFilterEntry> _cast = <ActorFilterEntry>[
    const ActorFilterEntry('Aaron Burr', Icon(Icons.check)),
    const ActorFilterEntry('Alexander Hamilton', Icon(Icons.check)),
    const ActorFilterEntry('Eliza Hamilton', Icon(Icons.check)),
    const ActorFilterEntry('James Madison', Icon(Icons.check)),
  ];
  final List<String> _filters = <String>[];

  Iterable<Widget> get actorWidgets sync* {
    for (final ActorFilterEntry actor in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          avatar: CircleAvatar(),
          label: Text(actor.name),
          selected: _filters.contains(actor.name),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _filters.add(actor.name);
              } else {
                _filters.removeWhere((String name) {
                  return name == actor.name;
                });
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            children: actorWidgets.toList(),
          ),
          Text("Look for stuff: ${_filters.join(', ')}"),
        ],
      ),
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
