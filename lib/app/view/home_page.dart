import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/app/controller/home_controller.dart';
import 'package:lista_de_tarefas/app/model/to_do_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController homeController = HomeController();

  @override
  void initState() {
    super.initState();
    homeController.readData().then(
      (data) {
        homeController.toDoList = json.decode(data!);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Lista de Tarefas | Made by Siilar"),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        body: homeController.isLoading ? Center(child: CircularProgressIndicator()) : ToDoList(controller: homeController));
  }
}
