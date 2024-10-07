import 'package:aa_travel_planner/features/favorites/repositories/favorites_repository.dart';
import 'package:aa_travel_planner/main_screen.dart';
import 'package:aa_travel_planner/features/trips/repositories/trip_repository.dart';
import 'package:aa_travel_planner/features/trips/screens/trip_details_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AA Travel Planner',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class Destination {
  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;

  Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
  });

  // Damit zwei Objekte mit den selben Daten als gleich angesehen werden.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Destination) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Trip {
  final String id;
  final Destination destination;
  final String dateRange;
  final String itinerary;

  Trip({
    required this.id,
    required this.destination,
    required this.dateRange,
    required this.itinerary,
  });

  // Damit zwei Objekte mit den selben Daten als gleich angesehen werden.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Trip) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class DestinationRepository {
  final List<Destination> _destinations = [
    Destination(
      id: '1',
      name: 'Paris',
      country: 'France',
      description:
          'The City of Lights, famous for its culture and architecture.',
      imageUrl: 'paris.jpeg',
    ),
    Destination(
      id: '2',
      name: 'Tokyo',
      country: 'Japan',
      description:
          'A city blending tradition with modern technology, and full of vibrant districts.',
      imageUrl: 'tokyo.jpeg',
    ),
    Destination(
      id: '3',
      name: 'New York',
      country: 'USA',
      description:
          'The city that never sleeps, known for its iconic skyline and landmarks.',
      imageUrl: 'new_york.jpeg',
    ),
    Destination(
      id: '4',
      name: 'Rome',
      country: 'Italy',
      description:
          'A city steeped in history, with ancient ruins and Renaissance art.',
      imageUrl: 'rome.jpeg',
    ),
    Destination(
      id: '5',
      name: 'Sydney',
      country: 'Australia',
      description:
          'Known for its Sydney Opera House, Harbour Bridge, and beautiful beaches.',
      imageUrl: 'sydney.jpeg',
    ),
    Destination(
      id: '6',
      name: 'Rio de Janeiro',
      country: 'Brazil',
      description:
          'Famous for its Carnival, Christ the Redeemer, and breathtaking beaches.',
      imageUrl: 'rio_de_janeiro.jpeg',
    ),
    Destination(
      id: '7',
      name: 'Cape Town',
      country: 'South Africa',
      description:
          'A port city beneath Table Mountain, known for its stunning landscapes.',
      imageUrl: 'cape_town.jpeg',
    ),
  ];

  List<Destination> getAllDestinations() {
    return _destinations;
  }
}

class HomeScreen extends StatefulWidget {
  final DestinationRepository destinationRepository;
  final TripRepository tripRepository;
  final FavoritesRepository favoritesRepository;

  const HomeScreen({
    super.key,
    required this.tripRepository,
    required this.favoritesRepository,
    required this.destinationRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final trips = widget.tripRepository.getAllTrips();
    final favoriteDestinations = widget.favoritesRepository.getFavorites();
    final secretTip = trips.isNotEmpty ? trips[0] : null;
    final destinations = widget.destinationRepository.getAllDestinations();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recommended Trips',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Carousel(
            favoritesRepository: widget.favoritesRepository,
            trips: trips,
            secretTip: secretTip,
            favoriteDestination: favoriteDestinations.isNotEmpty
                ? favoriteDestinations[0]
                : null,
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Explore Popular Destinations',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: destinations.length > 3 ? 3 : destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];

              return PopularDestinationCard(
                destination: destination,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DestinationDetailsScreen(
                        favoritesRepository: widget.favoritesRepository,
                        destination: destination,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Upcoming Trips',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: trips.length > 5 ? 5 : trips.length,
            itemBuilder: (context, index) {
              final Trip trip = trips[index];

              return ListTile(
                title: Text(trip.destination.name),
                subtitle: Text(trip.dateRange),
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/${trip.destination.imageUrl}"),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TripDetailsScreen(trip: trip)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class Carousel extends StatelessWidget {
  final FavoritesRepository favoritesRepository;
  final List<Trip> trips;
  final Trip? secretTip;
  final Destination? favoriteDestination;

  const Carousel({
    super.key,
    required this.favoritesRepository,
    required this.trips,
    this.secretTip,
    this.favoriteDestination,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView(
        controller: PageController(viewportFraction: 0.8),
        children: [
          if (secretTip != null)
            CarouselItem(trip: secretTip!, label: 'Secret Tip!'),
          if (favoriteDestination != null)
            CarouselItem(
                favoritesRepository: favoritesRepository,
                destination: favoriteDestination!,
                label: 'From Your Favorites'),
          ...trips.map((trip) => CarouselItem(trip: trip)),
        ],
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final FavoritesRepository? favoritesRepository;
  final Trip? trip;
  final Destination? destination;
  final String? label;

  const CarouselItem({
    super.key,
    this.trip,
    this.destination,
    this.label,
    this.favoritesRepository,
  });

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        trip != null ? trip!.destination.imageUrl : destination!.imageUrl;
    final String title =
        trip != null ? trip!.destination.name : destination!.name;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => trip == null
            ? DestinationDetailsScreen(
                destination: destination!,
                favoritesRepository: favoritesRepository!,
              )
            : TripDetailsScreen(trip: trip!),
      )),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage("assets/images/$imageUrl"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (label != null)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreDestinationsScreen extends StatelessWidget {
  final DestinationRepository destinationRepository;
  final FavoritesRepository favoritesRepository;

  const ExploreDestinationsScreen({
    super.key,
    required this.destinationRepository,
    required this.favoritesRepository,
  });

  @override
  Widget build(BuildContext context) {
    final destinations = destinationRepository.getAllDestinations();

    return ListView.builder(
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
        return DestinationCard(
          destination: destination,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationDetailsScreen(
                  destination: destination,
                  favoritesRepository: favoritesRepository,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DestinationDetailsScreen extends StatelessWidget {
  final Destination destination;
  final FavoritesRepository favoritesRepository;

  const DestinationDetailsScreen({
    super.key,
    required this.destination,
    required this.favoritesRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name),
        backgroundColor: Colors.teal[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "assets/images/${destination.imageUrl}",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text('Country: ${destination.country}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              const Text('Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(destination.description,
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600]),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      favoritesRepository.addFavorite(destination);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600]),
                    child: const Text(
                      'Add to favorites',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PopularDestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const PopularDestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: Colors.blueGrey[50],
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/images/${destination.imageUrl}",
                    width: 80, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      destination.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.teal.shade300, width: 2),
      ),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/images/${destination.imageUrl}",
                    width: 80, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(destination.country,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
