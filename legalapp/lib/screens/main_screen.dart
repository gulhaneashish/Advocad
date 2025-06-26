import 'package:flutter/material.dart';
import 'package:legalapp/auth/initial_screen.dart';
import 'package:legalapp/screens/contact_page.dart';
import 'package:legalapp/screens/edit_profile.dart';
import 'package:legalapp/screens/response_screen.dart';
import 'package:legalapp/screens/view_jobs_screen.dart';
import 'package:legalapp/session_manager/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:legalapp/screens/chat_screen.dart';
import 'package:legalapp/home_screen.dart';
import 'package:legalapp/screens/job_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic>? userData;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ChatScreen(),
    const JobScreen(),
  ];

  final List<String> _titles = ["Home", "Chat", "Lawyer"];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('email', SessionManager.userId.toString())
          .single(); // Fetch single user record

      setState(() {
        userData = response;
      });
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade700,
        selectedItemColor: Colors.teal.shade200,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Lawyer"),
        ],
      ),
    );
  }

  // Common App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
      centerTitle: true,
      backgroundColor: Colors.teal[700],
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
    );
  }

  // Drawer with User Details
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData?['name'] ?? "Loading..."),
            accountEmail: Text(userData?['email'] ?? "Loading..."),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: userData?['profile_image'] != null
                  ? NetworkImage(userData!['profile_image'])
                  : null,
              child: userData?['profile_image'] == null
                  ? const Icon(Icons.person, size: 50, color: Colors.teal)
                  : null,
            ),
            decoration: BoxDecoration(color: Colors.teal[700]),
          ),
          ListTile(
            leading: const Icon(Icons.person,color: Colors.orange,),
            title: const Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfilePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.description,color: Colors.orange,),
            title: const Text("View Cases",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ViewJobsForYouPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.description,color: Colors.orange,),
            title: const Text("View Responses",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ResponsePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_page,color: Colors.orange,),
            title: const Text("Contact Us",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.orange),),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AboutUsPage()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
             SessionManager.logout();
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>MainPage()), (route)=> false);
            },
          ),
        ],
      ),
    );
  }
}
