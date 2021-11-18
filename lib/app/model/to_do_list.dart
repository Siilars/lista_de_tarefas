import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/app/controller/home_controller.dart';

class ToDoList extends StatefulWidget {
  final HomeController controller;

  const ToDoList({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  void addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = widget.controller.toDoController.text;
      widget.controller.toDoController.text = "";
      newToDo["ok"] = false;
      widget.controller.toDoList.add(newToDo);
      widget.controller.saveData(toDoList: widget.controller.toDoList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: widget.controller.toDoController,
                  decoration: InputDecoration(
                    labelText: "NovaTarefa",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: widget.controller.toDoController.text == "" ? null : addToDo,
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await widget.controller.refresh();
              setState(() {});
            },
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: widget.controller.toDoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment(-0.9, 0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  direction: DismissDirection.startToEnd,
                  key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                  child: CheckboxListTile(
                    title: Text(widget.controller.toDoList[index]["title"]),
                    value: widget.controller.toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(widget.controller.toDoList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                    onChanged: (check) {
                      setState(
                        () {
                          widget.controller.toDoList[index]["ok"] = check;
                          widget.controller.saveData(toDoList: widget.controller.toDoList);
                        },
                      ); // SetState
                    }, // Onchanged
                  ),
                  onDismissed: (direction) {
                    setState(
                      () {
                        widget.controller.lastRemoved = Map.from(widget.controller.toDoList[index]);
                        widget.controller.lastRemovedPos = index;
                        widget.controller.toDoList.removeAt(index);
                        widget.controller.saveData(toDoList: widget.controller.toDoList);
                        final snack = SnackBar(
                          content: Text(
                            "Tarefa ${widget.controller.lastRemoved["title"]} removida",
                          ),
                          action: SnackBarAction(
                            label: "Desfazer",
                            onPressed: () {
                              setState(() {
                                widget.controller.toDoList.insert(widget.controller.lastRemovedPos, widget.controller.lastRemoved);
                                widget.controller.saveData(toDoList: widget.controller.toDoList);
                              });
                            },
                          ),
                          duration: Duration(seconds: 3),
                        );
                        Scaffold.of(context).showSnackBar(snack);
                      },
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
