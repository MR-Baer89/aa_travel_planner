import 'package:aa_travel_planner/features/favorites/models/favorite_card.dart';
import 'package:aa_travel_planner/main.dart';
import 'package:aa_travel_planner/features/favorites/widgets/favorites_screen.dart';
import 'package:flutter/material.dart';

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    List<Destination> favorites = widget.favoritesRepository.getFavorites();

    return ListView.builder(
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final destination = favorites[index];
        return FavoriteCard(
          destination: destination,
          favoritesRepository: widget.favoritesRepository,
          onRemove: () {
            setState(() {});
          },
        );
      },
    );
  }
}
