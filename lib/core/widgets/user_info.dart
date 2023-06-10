import 'package:colon_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utlis/assets.dart';
import '../utlis/styles.dart';

final supabase = Supabase.instance.client;

class DetailsUser extends StatefulWidget {
  const DetailsUser({
    super.key,
    // required this.username
  });

  // final String? username;

  @override
  State<DetailsUser> createState() => _DetailsUserState();
}

class _DetailsUserState extends State<DetailsUser> {
  String name = supabase.auth.currentUser!.email!.split("@")[0];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Image.network(
                          fit: BoxFit.fill,
                          'https://cdn.iconscout.com/icon/free/png-256/user-1772944-1508886.png?f=webp&w=256',
                        ),
                      );
                    },
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 32,
                  backgroundImage: NetworkImage(
                    // auth.currentUser.photoURL ??
                    'https://cdn.iconscout.com/icon/free/png-256/user-1772944-1508886.png?f=webp&w=256',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Hi , ', style: Styles.textStyle18),
              Text(
                name.toString(),
                style: Styles.textStyle18.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Colors.black,
          thickness: 0.5,
        ),
      ],
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsData.logo,
              height: 50,
              color: kButtonColor,
            ),
            Text(
              'COLON CANCER-APP',
              style: Styles.textStyle15
                  .copyWith(color: Colors.black, fontSize: 13),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
