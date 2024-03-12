import 'package:flutter/material.dart';
import 'package:logsy_app/3_Record_Part/provider/food.dart';
import 'package:logsy_app/3_Record_Part/provider/foodRecord.dart';
import 'package:logsy_app/3_Record_Part/provider/waterRecord.dart';
import 'package:logsy_app/3_Record_Part/screen/personal_meal_screen.dart';
import 'package:logsy_app/3_Record_Part/widget/meal_list_item.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  static const routeName = '/record';

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  var _isInit = true;
  var _isLoading = false;
  List<Food> meal;
  List<Food> presentMeal;
  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final food = Provider.of<FoodProvider>(context, listen: false);

      await food.getAllFood();
      setState(() {
        meal = food.food;
        presentMeal = meal;
        presentMeal.sort((a,b) => a.name.compareTo(b.name));
      });
    }
    _isInit = false;
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  Future<void> _refreshFood(BuildContext context) async {
    final food = Provider.of<FoodProvider>(context, listen: false);
    await food.getAllFood();
    setState(() {
      meal = food.food;
      presentMeal = meal;

      presentMeal.sort((a,b) => a.name.compareTo(b.name));
      
    });
  }

  void fetchAndSetData() async {
    final food = Provider.of<FoodProvider>(context, listen: false);
    await food.getAllFood();
    setState(() {
      meal = food.food;
      presentMeal = meal;
      presentMeal.sort((a,b) => a.name.compareTo(b.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18,
              color: Colors.teal[500],
              fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
        actions: [
          IconButton(
              icon: Icon(
                Icons.add,
                size: 30,
                color: Colors.teal,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(PersonalMealScreen.routeName)
                    .then((_) {
                  fetchAndSetData();
                });
              })
        ],
      ),
      body: _isLoading
          ? LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.white,
            )
          : RefreshIndicator(
              onRefresh: () => _refreshFood(context),
              child: Form(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.teal[100],
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: TextFormField(
                          onChanged: (text) {
                            if (text == "") {
                              setState(() {
                                presentMeal = meal;
                                 presentMeal.sort((a,b) => a.name.compareTo(b.name));
                              });
                            } else {
                              List<Food> searchMeal = meal
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                                  .toList();
                              setState(() {
                                presentMeal = searchMeal;
                                presentMeal.sort((a,b) => a.name.compareTo(b.name));
                              });
                            }
                          },
                          style: TextStyle(color: Colors.teal),
                          cursorColor: Colors.teal,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              border: InputBorder.none,
                              focusColor: Colors.teal),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (ctx, i) =>
                              MealListItem(presentMeal[i], title),
                          itemCount: presentMeal.length),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
