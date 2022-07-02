import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:great_place/provider/great_places.dart';
import 'package:great_place/screen/add_place_screen.dart';
import 'package:great_place/screen/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<GreatPlaces>(
              child: const Center(
                child: Text('Got no Place yet, start adding some!'),
              ),
              builder: (ctx, greatPlaces, ch) => greatPlaces.items.isEmpty
                  ? ch!
                  : ListView.builder(
                      itemCount: greatPlaces.items.length,
                      itemBuilder: (ctx, index) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: Image.file(
                            fit: BoxFit.cover,
                            io.File(
                              greatPlaces.items[index].image.path,
                            ),
                          ).image,
                        ),
                        title: Text(greatPlaces.items[index].title),
                        subtitle:
                            Text(greatPlaces.items[index].location.address!),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            PlaceDetailScreen.routeName,
                            arguments: greatPlaces.items[index].id,
                          );
                        },
                      ),
                    ),
            );
          }),
    );
  }
}
