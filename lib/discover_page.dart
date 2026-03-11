import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 120,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("TORONTO GUIDES", 
                style: TextStyle(letterSpacing: 4, fontWeight: FontWeight.w900, fontSize: 14, color: Colors.orangeAccent)),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildFeaturedCard("CN Tower", "Downtown Toronto", "https://images.unsplash.com/photo-1517090504586-fde19ea6066f?q=80&w=1000"),
              _buildFeaturedCard("Distillery District", "Old Town Toronto", "https://images.unsplash.com/photo-1559511260-66a654ae982a?q=80&w=1000"),
              _buildFeaturedCard("Casa Loma", "Midtown Toronto", "https://images.unsplash.com/photo-1516912403145-636ad7551b4c?q=80&w=1000"),
              const SizedBox(height: 100), // Space so the last card isn't hidden by the nav bar
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(String title, String location, String imageUrl) {
  return Container(
    height: 350,
    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          // The actual image with a loading state
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            // While the image loads from the web:
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[900],
                child: const Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
              );
            },
            // If the link breaks or internet fails:
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[900],
              child: const Center(child: Icon(Icons.broken_image, color: Colors.orangeAccent, size: 40)),
            ),
          ),
          
          // The Dark Gradient Overlay (makes text readable)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              ),
            ),
          ),

          // The Text Content
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.toUpperCase(), 
                  style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text(title, 
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}