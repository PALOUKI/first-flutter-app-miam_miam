import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import '../models/database.dart';



class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {

  final _formKey= GlobalKey<FormState>();
  String foodName= "";
  String imageUrl= "";
  String? selectedcategory= "dessert";
  String? selectedImageUrl= "fruits";
  double foodPrice= 0;
  //Controllers
  final foodNameController= TextEditingController();
  final foodPriceController= TextEditingController();



  String? _foodNameValidator(String? value){
    if(value == null || value.isEmpty){
      return "Le nom du menu est obligatoire";
    }
    return null;
  }
  String? _foodPriceValidator(String? value){
    if(value == null || value.isEmpty){
      return "Veuillez enter un prix";
    }
    if (double.tryParse(value) == null) {
      return 'Veuillez entrer un nombre valide';
    }
    return null;
  }

  @override
  void dispose() {
    foodNameController.dispose();
    foodPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text("Ajouter une recette",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Veuillez remplir le formulaire",
                  style:  TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
               SizedBox(height: 10),
               SizedBox(
                 height: 60,
                 child:  Container(
                   margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                   child:  TextFormField(
                     decoration:  InputDecoration(
                       labelStyle: const TextStyle(
                         color: Colors.black,
                         fontSize: 17,
                         fontWeight: FontWeight.w600,
                       ),
                       prefixIcon: const Icon(Icons.restaurant_menu),
                       labelText: "Entrez le nom de la nourriture",
                       hintText: "nom de la nourriture",
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                       fillColor: Colors.grey[200],
                       filled: true,
                     ),
                     validator: _foodNameValidator,
                     controller: foodNameController,
                   ),
                 ),
               ),
                SizedBox(height: 10,),
                SizedBox(
                  height: 60,
                  child:   Container(
                    margin:const EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: DropdownButtonFormField(
                        items: const[
                          DropdownMenuItem(
                              value: "fruits",
                              child: Text("fruits")
                          ),
                          DropdownMenuItem(
                              value: "legumes",
                              child: Text("legumes")
                          ),
                          DropdownMenuItem(
                              value: "steck",
                              child: Text("steck")
                          )
                        ],
                        decoration:  InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(Icons.image_outlined),
                          labelText: "ajouter une image",
                          hintText: "image",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                        value: selectedImageUrl,
                        onChanged: (value){
                          setState(() {
                            selectedImageUrl= value;
                          });
                        }
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              SizedBox(
                height: 60,
                child: Container(
                  margin:const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: DropdownButtonFormField(
                      items: const[
                        DropdownMenuItem(
                            value: "dessert",
                            child: Text("Déssert")
                        ),
                        DropdownMenuItem(
                            value: "entree",
                            child: Text("Entrée")
                        ),
                        DropdownMenuItem(
                            value: "boisson",
                            child: Text("Boisson")
                        )
                      ],
                      decoration:  InputDecoration(
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: const Icon(Icons.category),
                        labelText: "Entrez la cathégorie",
                        hintText: "cathégorie",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      value: selectedcategory,
                      onChanged: (value){
                        setState(() {
                          selectedcategory= value;
                        });
                      }
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 60,
                child:   Container(
                  margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration:  InputDecoration(
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                      labelText: "Entrez le prix de la recette",
                      hintText: "Prix de la recette",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    validator: _foodPriceValidator,
                    controller: foodPriceController,
                  ),
                ),
              ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: 53,
                  width: double.infinity,
                  child:
                  ElevatedButton(
                    onPressed:() async {
                      if(_formKey.currentState!.validate()){

                        foodName= foodNameController.text;
                        foodPrice = double.tryParse(foodPriceController.text)!;
                        print("food name: $foodName");
                        print("cathégorie: $selectedcategory");
                        print("image: $selectedImageUrl");
                        print("food price: $foodPrice");

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Ajout en cours ...."))
                        );
                            String Id= randomAlphaNumeric(10);
                        Map<String, dynamic> foodInfoMap={
                          "Id": Id,
                          "name": foodName,
                          "imageUrl": selectedImageUrl,
                          "category": selectedcategory,
                          "price": foodPrice
                        };
                        await DatabaseMethods().addFoodDetails(foodInfoMap, Id).then((value){
                          Fluttertoast.showToast(
                              msg: "food details are been upload successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        });

                          Navigator.pop(context);

                      }
                    },
                    style: ButtonStyle(
                        iconColor: WidgetStatePropertyAll(Colors.white),
                        backgroundColor: const WidgetStatePropertyAll(Colors.blue),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                    ),
                    child: const Text("Ajouter",
                      style:  TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
