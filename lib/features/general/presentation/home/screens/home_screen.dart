import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: SvgPicture.asset(
                          //     "assets/icons/svg/menu-drawer.svg"),
                        ),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child:
                        Image.asset("assets/images/wise-logo-small.png"),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, AppRoutes.notificationApp);
                },
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      shape: BoxShape.circle,
                    ),
                    // child:
                        // SvgPicture.asset("assets/icons/svg/notifications.svg"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
