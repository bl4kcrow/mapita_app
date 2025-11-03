import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapita_app/domain/entities/entities.dart';
import 'package:mapita_app/presentation/providers/providers.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  SearchDestinationDelegate(this.ref) : super(searchFieldLabel: 'Search...');

  WidgetRef ref;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final proximity = ref.read(locationProvider).lastKnownLocation!;
    ref.read(searchProvider.notifier).getPlacesByQuery(proximity, query);

    return Consumer(
      builder: (context, ref, child) {
        final places = ref.watch(searchProvider).places;

        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: (context, _) => const Divider(),
          itemBuilder: (context, index) {
            final place = places[index];
            return ListTile(
              title: Text(place.displayName.text),
              subtitle: Text(
                place.formattedAddress,
                overflow: TextOverflow.ellipsis,
              ),
              leading: const Icon(Icons.place_outlined, color: Colors.black),
              onTap: () {
                final result = SearchResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(
                    place.location.latitude,
                    place.location.longitude,
                  ),
                  name: place.displayName.text,
                  address: place.formattedAddress,
                );

                ref.read(searchProvider.notifier).addPlaceToHistory(place);

                close(context, result);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final historyPlaces = ref.read(searchProvider).history;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black),
          title: const Text(
            'Set location manually',
            style: TextStyle(color: Colors.black38),
          ),
          onTap: () {
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),
        Expanded(
          child: ListView.separated(
            itemCount: historyPlaces.length,
            separatorBuilder: (context, _) => const Divider(),
            itemBuilder: (context, index) {
              final place = historyPlaces[index];
              return ListTile(
                title: Text(place.displayName.text),
                subtitle: Text(
                  place.formattedAddress,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: const Icon(Icons.history, color: Colors.black),
                onTap: () {
                  final result = SearchResult(
                    cancel: false,
                    manual: false,
                    position: LatLng(
                      place.location.latitude,
                      place.location.longitude,
                    ),
                    name: place.displayName.text,
                    address: place.formattedAddress,
                  );

                  close(context, result);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
