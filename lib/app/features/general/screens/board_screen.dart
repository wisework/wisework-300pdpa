import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';


class BoradScreen extends StatefulWidget {
  @override
  _BoradScreenState createState() => _BoradScreenState();
}

class _BoradScreenState extends State<BoradScreen> {
  int _currentIndex = 0;
  final controller = CarouselController();

  @override

  
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkResponse(
          onTap: () {
            // Navigate back
          },
          child: Ink(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Navigate back
              },
            ),
          ),
        ),
        actions: [
          InkResponse(
            onTap: () {},
            child: Ink(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Skip',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
        ],
      ),
      body: board_screen(context),
    );
  }

  Widget board_screen(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            items: [
              buildBoard1(context),
              buildBoard2(context),
            ],
            carouselController: controller,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        Stack(
          children: [
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2, // Change this to the number of screens
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: _currentIndex == index
                          ? Colors.blue
                          : Colors.grey, // Change these colors as needed
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


Column buildBoard1(BuildContext context) {
  return Column(
    children: [
      Image.asset(
        'assets/images/1.png',
        width: 700,
        height: 500,
        fit: BoxFit.cover,
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Consent Management',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'You can easily craft consent forms, and automatically generate them from specified master data. Tailor them to your needs, experiment with themes, and have the world at your fingertips with real-time previews. Then, share your creations effortlessly via QR codes or URLs.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      height: 40.0,
                      width: 120,
                      onPressed: next,
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Column buildBoard2(BuildContext context) {
  return Column(
    children: [
      Image.asset(
        'assets/images/2.png',
        width: 700,
        height: 500,
        fit: BoxFit.cover,
      ),
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Master Data',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Control over consent-related parameters, including purpose, purpose categories, and mandatory fields, ensuring data integrity and accuracy in the system.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      height: 40.0,
                      width: 120,
                      onPressed: () {},
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
void next() => controller.nextPage();
}