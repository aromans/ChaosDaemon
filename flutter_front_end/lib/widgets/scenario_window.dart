import 'package:flutter/material.dart';
import 'package:flutter_front_end/models/dark_mode_status.dart';
import 'package:provider/provider.dart';

class ActorFilterEntry {
  const ActorFilterEntry(this.name, this.initials);
  final String name;
  final Icon initials;
}

class ScenarioWindow extends StatefulWidget {
  const ScenarioWindow({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScenarioWindowState();
}

class ScenarioWindowState extends State<ScenarioWindow> {
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
          backgroundColor: Colors.white,
          avatar: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 88, 176, 156),
          ),
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
    DarkModeStatus status = Provider.of<DarkModeStatus>(context);
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/scenarioCreator'),
                      child: const Icon(Icons.add),
                      tooltip: 'Create a scenario',
                      backgroundColor: Color.fromARGB(255, 88, 176, 156),
                    )),
              ),
              BottomAppBar(
                color: Color.fromARGB(255, 45, 46, 46),
                child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary),
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
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                children: actorWidgets.toList(),
              ),
              Text("Look for stuff: ${_filters.join(', ')}"),
            ],
          ),
        ),
      ],
    );
  }
}
