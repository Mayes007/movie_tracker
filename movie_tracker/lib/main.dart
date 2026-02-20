import 'package:flutter/material.dart';

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

class TrackerListScreen extends StatelessWidget {
  final String title;
  const TrackerListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Watching"),
              Tab(text: "Plan to Watch"),
              Tab(text: "Finished"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGrid("Currently Tracking"),
            _buildGrid("On the Wishlist"),
            _buildGrid("History"),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildGrid(String emptyMessage) {
    // This is a placeholder. Later, this will pull from your Database.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter, size: 64, color: Colors.grey[700]),
          const SizedBox(height: 16),
          Text(emptyMessage, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}