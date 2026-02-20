import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(const CineTrackApp());

class CineTrackApp extends StatelessWidget {
  const CineTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // The different "Pages" of your app
  final List<Widget> _pages = [
    const TrackerListScreen(title: "My Movies"),
    const TrackerListScreen(title: "TV Shows"),
    const Center(child: Text("Settings & Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Movies'),
          NavigationDestination(icon: Icon(Icons.tv), label: 'TV Shows'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TrackerListScreen extends StatefulWidget {
  final String title;
  const TrackerListScreen({super.key, required this.title});

  @override
  State<TrackerListScreen> createState() => _TrackerListScreenState();
}

class _TrackerListScreenState extends State<TrackerListScreen> {
  int currentTab = 0;

  List<String> watching = [];
  List<String> plan = [];
  List<String> finished = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ---------------- LOAD ----------------
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      watching = List<String>.from(
          jsonDecode(prefs.getString("${widget.title}_watching") ?? "[]"));

      plan = List<String>.from(
          jsonDecode(prefs.getString("${widget.title}_plan") ?? "[]"));

      finished = List<String>.from(
          jsonDecode(prefs.getString("${widget.title}_finished") ?? "[]"));
    });
  }

  // ---------------- SAVE ----------------
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        "${widget.title}_watching", jsonEncode(watching));
    await prefs.setString(
        "${widget.title}_plan", jsonEncode(plan));
    await prefs.setString(
        "${widget.title}_finished", jsonEncode(finished));

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Saved successfully ✅")),
    );
  }

  // ---------------- ADD ----------------
  void addItem(String name) {
    setState(() {
      if (currentTab == 0) watching.add(name);
      if (currentTab == 1) plan.add(name);
      if (currentTab == 2) finished.add(name);
    });
  }

  void showAddDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add to ${widget.title}"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                addItem(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  List<String> getCurrentList() {
    if (currentTab == 0) return watching;
    if (currentTab == 1) return plan;
    return finished;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveData,
            )
          ],
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                currentTab = index;
              });
            },
            tabs: const [
              Tab(text: "Watching"),
              Tab(text: "Plan to Watch"),
              Tab(text: "Finished"),
            ],
          ),
        ),
        body: getCurrentList().isEmpty
            ? Center(
                child: Text(
                  "Nothing here yet.\nTap + to add something!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
            : ListView.builder(
                itemCount: getCurrentList().length,
                itemBuilder: (context, index) {
                  final item = getCurrentList()[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            getCurrentList().removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
