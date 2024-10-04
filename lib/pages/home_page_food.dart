import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miam_miam/models/database.dart';
import 'package:miam_miam/pages/add_food_page.dart';

class HomePageFood extends StatefulWidget {
  const HomePageFood({super.key});

  @override
  State<HomePageFood> createState() => _HomePageFoodState();
}

class _HomePageFoodState extends State<HomePageFood> {

/* ****DEBUT de recupération ou de redéclaration des données pour permettre la modification d'une recette*/

  String foodName= "";
  String? selectedImageUrl= "fruits";
  String? selectedcategory= "dessert";
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

/***************************************FIN*********************************************/
  Stream? foodStream;

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Future getontheload()async{
    foodStream= await DatabaseMethods().getFoodDetails();
    setState(() {

    });
    /*setState pour notifier Flutter que l'état du widget a changé.
    Donc on peut reconstruire le widget avec le nouvel état.*/
  }


  Widget allFoodDetails() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        // Vérification de l'état de la connexion
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  "Chargement en cours...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // Gérer les erreurs lors de la récupération des données
          return Center(child: Text("Erreur lors de la récupération des données"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Aucun plat trouvé
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/no-food.png", width: 80,),
                SizedBox(height: 20),
                Text("Enregistrer vos recettes"),
              ],
            ),
          );
        }

        // Si des données sont disponibles
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];

            return Card(
              elevation: 5.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Image.asset(
                  "assets/images/${ds["imageUrl"]}.jpeg",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Plat: ${ds["name"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.edit, color: Colors.orange),
                      onTap: () {
                        foodNameController.text = ds["name"];
                        selectedImageUrl = ds["imageUrl"];
                        selectedcategory = ds["category"];
                        foodPriceController.text = ds["price"]!.toString();
                        editFoodDetails(ds["Id"]);
                      },
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Catégorie:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(" ${ds["category"]}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          "Prix:",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(" ${ds["price"]?.toString()} FCFA"),
                        Spacer(),
                        GestureDetector(
                          child: Icon(Icons.delete, color: Colors.orange),
                          onTap: ()  {
                            deleteFoodDetails(ds["Id"]);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            );
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content of the screen
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
                Expanded(
                    child: allFoodDetails(),
                )
            ],
          ),
        ),
        // Positioned FloatingActionButton
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => AddFoodPage(),
                ),
              );
            },
            child: Icon(Icons.add),
            tooltip: 'Add',
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }


  Future editFoodDetails(String id)=> showDialog(context: context, builder: (context)=>AlertDialog(
    content: Container(
      height: 500,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("modifier",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w800,
                    fontSize: 25,
                ),
              ),
              const Text("Recettes",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 25,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 40,),
          Container(
            margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
            child:  TextFormField(
              decoration:  InputDecoration(
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: const Icon(Icons.restaurant_menu),
                labelText: "Recette",
                hintText: "Recette",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              validator: _foodNameValidator,
              controller: foodNameController,
            ),
          ),

          Container(
            margin:const EdgeInsets.only(top: 10, right: 10, left: 10),
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
          Container(
            margin:const EdgeInsets.only(top: 10, right: 10, left: 10),
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
                  prefixIcon: Icon(Icons.category),
                  labelText: "cathégorie",
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
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: TextFormField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration:  InputDecoration(
                labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: const Icon(Icons.attach_money),
                labelText: "Prix",
                hintText: "Prix",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.grey[200],
                filled: true,
              ),
              validator: _foodPriceValidator,
              controller: foodPriceController,
            ),
          ),
          const SizedBox(height: 30,),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async{
                  Map<String, dynamic> updateinfo={
                    "Id": id,
                    "name": foodNameController.text,
                    "imageUrl": selectedImageUrl,
                    "category": selectedcategory,
                    "price": foodPriceController.text
                  };
                  await DatabaseMethods().updateFoodDetail(id, updateinfo)
                      .then((value){
                    Navigator.pop(context);
                  });
                },
                child:  Text("modifier", style: TextStyle(
                    color: Colors.white,
                ),
                ),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                backgroundColor: const WidgetStatePropertyAll(Colors.orange),
              ),
            ),
          )
        ],
      ),
    ),
  ));


   deleteFoodDetails(String id)  => showDialog(context: context, builder: (context)=>AlertDialog(
     title: const Text("Voulez vous supprimer la recette ?"),
     actions: [
       TextButton(
           onPressed: ()=> Navigator.pop(context),
           child: const Text("annuler",
             style: TextStyle(
               fontSize: 16,
               color: Colors.black,
               fontWeight: FontWeight.w400,
             ),
           ),
       ),
     TextButton(
       style: ButtonStyle(
         padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
         backgroundColor: WidgetStatePropertyAll(Colors.red),
       ),
         onPressed: ()async{
            await DatabaseMethods().deleteFoodDetail(id);
            Navigator.pop(context);
          },
         child: const Text("ok",
           style: TextStyle(
             fontSize: 16,
             color: Colors.white,
             fontWeight: FontWeight.w400,
           ),
         ),
     )
     ]

   ) );
}
