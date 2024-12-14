import 'package:flutter/material.dart';
class AdvocadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advocad',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Advocad',
          style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),

        ),
        backgroundColor:Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search Action
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Icon(Icons.person_4_rounded),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('About',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.gavel),
              title: Text('Know Your Right',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Find Lawyer',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text('Contact Us',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 350,
                        child: Image.asset('assets/image/about-1.jpg'),
                        //color: Colors.lightGreen,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 350,
                        child: Image.asset('assets/image/about-2.jpg'),
                        //color: Colors.orange,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 350,
                        child: Image.asset('assets/image/about-2.png'),
                        //color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 350,
                        child: Image.asset('assets/image/about-1.png'),
                        // color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text(
                'Categerious',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/category-1.jpg'),
                        //color: Colors.lightGreen,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/category-2.jpg'),
                        // color: Colors.orange,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/category-3.jpg'),
                        //color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/category-4.jpg'),
                        //color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text(
                'Lawyers',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/sahayak-1.jpg'),
                        // color: Colors.lightGreen,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/sahayak-2.jpg'),
                        // color: Colors.orange,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/sahayak-3.jpeg'),
                        //color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/sahayak-4.jpg'),
                        //color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text(
                'Bloges',
                style: TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.orange,),
              ),
              SizedBox(width: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/img-1.jpg'),
                        //color: Colors.lightGreen,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/img-2.jpg'),
                        //color: Colors.orange,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/img-3.jpg'),
                        // color: Colors.white,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 11),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/img-4.jpg'),
                        //color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(

            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.article),
            label: 'Blogs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.orange,
        onTap: (index) {
          // Handle tap
        },
      ),
    );
  }
}
