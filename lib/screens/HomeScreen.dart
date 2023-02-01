import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Custom/TodoCard.dart';
import 'package:todoapp/Service/Auth_Service.dart';
import 'package:todoapp/screens/AddTodo.dart';
import 'package:todoapp/screens/SignUp.dart';
import 'package:todoapp/screens/ViewData.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  List<Select> selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
            "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.jpg"),
          ),
          SizedBox(
            width: 25,
          ),
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 22,
                bottom:10,
              ),
              child: Text(
                "Monday 21",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(35),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade900,
          items: [
            BottomNavigationBarItem(
              label: "",
                icon: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(
                      Icons.home,
                      size: 32,
                      color: Colors.white,
                  ),
                ),
            ),

            BottomNavigationBarItem(
              label: "",
              icon: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (builder)=>AddTodoScreen()));
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors:[
                        Colors.indigoAccent,
                        Colors.purple,
                      ]
                    )
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            BottomNavigationBarItem(
              label: "",
              icon: Icon(
                Icons.settings,
                size: 32,
                color: Colors.white,
              ),
            ),
          ]
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            {
              return Center(
                  child: CircularProgressIndicator(),
              );
            }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                IconData iconData = Icons.android;
                Color iconColor = Colors.green;
                Color iconBgColor = Colors.white;
                Map<String,dynamic> document =
                snapshot.data?.docs[index].data() as Map<String,dynamic>;
                switch(document["category"])
                {
                  case "Food":
                    iconData = Icons.restaurant;
                    iconColor = Colors.grey.shade800;
                    break;
                  case "Workout":
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.green;
                    break;
                  case "Work":
                    iconData = Icons.work;
                    iconColor = Colors.brown;
                    break;
                  case "Design":
                    iconData = Icons.design_services_outlined;
                    iconColor = Colors.pink;
                    iconBgColor = Colors.black;
                    break;
                  case "Run":
                    iconData = Icons.run_circle_outlined;
                    iconColor = Colors.green;
                    break;
                  default:
                    iconData = Icons.android;
                    Color iconColor = Colors.black;
                }
                selected.add(
                    Select(
                      id: snapshot.data!.docs[index].id,
                      checkValue: false,
                    ));
                return InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder)=>ViewData(
                              document: document,
                              id:snapshot.data?.docs[index].id,
                            ),
                        ),
                    );
                  },
                  child: TodoCard(
                    title: document["title"]==null
                            ? "Hey there!"
                            : document["title"],
                    iconData: iconData,
                    iconColor: iconColor,
                    //time: "",
                    check: selected[index].checkValue,
                    iconBgColor: iconBgColor,
                    index: index,
                    onChange: onChange,
                  ),
                );
          }
          );
        }
      ),
    );
  }
  void onChange(int index)
  {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select{
  String id;
  bool checkValue = false;
  Select({
    required this.id,
    required this.checkValue
  });
}
