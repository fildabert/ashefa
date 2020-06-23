import 'package:ashefa/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'custom_avatar.dart';

class ChipField extends StatefulWidget {
  List<User> userList;
  String labelText;
  String type;
  Function onChanged;
  List<User> initialValue;
  String errorText;

  ChipField(
      {this.userList,
      this.type,
      this.labelText,
      this.onChanged,
      this.initialValue,
      this.errorText});
  @override
  _ChipFieldState createState() => _ChipFieldState();
}

class _ChipFieldState extends State<ChipField> {
  GlobalKey<ChipsInputState> _chipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChipsInput(
      key: _chipKey,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
          errorText: widget.errorText),
      maxChips: 15,
      findSuggestions: (String query) {
        if (query.length != 0) {
          var lowercaseQuery = query.toLowerCase();
          return widget.userList.where((profile) {
            return profile.firstName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                profile.lastName.toLowerCase().contains(query.toLowerCase()) ||
                profile.email.toLowerCase().contains(query.toLowerCase());
          }).toList(growable: false)
            ..sort((a, b) => a.firstName
                .toLowerCase()
                .indexOf(lowercaseQuery)
                .compareTo(b.firstName.toLowerCase().indexOf(lowercaseQuery)));
        } else {
          return const <User>[];
        }
      },
      onChanged: (data) {
        widget.onChanged(data);
      },
      chipBuilder: (context, state, profile) {
        return InputChip(
          key: ObjectKey(profile),
          label: Text('${profile.firstName} ${profile.lastName}'),
          avatar: CustomAvatar(
            picture: profile.picture,
            height: 25,
            width: 25,
          ),
          onDeleted: () => state.deleteChip(profile),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
      suggestionBuilder: (context, state, profile) {
        return ListTile(
          key: ObjectKey(profile),
          leading: CustomAvatar(
            picture: profile.picture,
            height: 45,
            width: 45,
          ),
          title: Text('${profile.firstName} ${profile.lastName}'),
          subtitle: Text(profile.email),
          onTap: () {
            return state.selectSuggestion(profile);
          },
        );
      },
    );
  }
}
