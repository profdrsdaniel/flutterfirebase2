import 'package:flutter/material.dart';

import '../models/character.dart';
import '../services/characters_api.dart';

class CharactersList extends StatefulWidget {
  final String filter;

  const CharactersList({super.key, required this.filter});

  @override
  State<CharactersList> createState() => _CharactersListState();
}

class _CharactersListState extends State<CharactersList> {
  CharactersApi api = CharactersApi();

  late List<Character> _characters;
  late List<Character> _charactersFiltered;

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<List<Character>> _fetchCharacters() async {
    _characters = await api.fetchCharacters();
    _charactersFiltered = _characters;

    return _characters;
  }

  @override
  void didUpdateWidget(covariant CharactersList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.filter != widget.filter) {
      _filterCharacters(widget.filter);
    }
  }

  _filterCharacters(String filter) {
    setState(() {
      _charactersFiltered = _characters
          .where(
              (item) => item.name.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: api.fetchCharacters(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Text(_charactersFiltered[index].name),
                      leading: Image.network(_charactersFiltered[index].image),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return const Divider();
                  },
                  itemCount: _charactersFiltered.length),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
