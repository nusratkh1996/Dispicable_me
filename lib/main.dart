import 'package:dispicable_me/model.dart';
import 'package:flutter/material.dart';
import 'description.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Dispicable Me",
              theme: ThemeData(
                primaryColor: Colors.amber,
              ),
              home: Home(),
            );
          },
        );
      },
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: currentPage, keepPage: false, viewportFraction: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {}),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {}),
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FractionallySizedBox(
              alignment: Alignment.topCenter,
              heightFactor: 0.3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Despicable Me",
                      style: TextStyle(
                          letterSpacing: 0.5,
                          fontSize: 35,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Characters",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ),
            PageView(
              physics: ClampingScrollPhysics(),
              controller: _pageController,
              children: <Widget>[
                for (int i = 0; i < characters.length; i++)
                  characterWidget(characters[i], _pageController, i),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add',
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () {}),
    );
  }

  Widget characterWidget(charaterData, _pageController, int currentPage) {
    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: 0.7,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: InkWell(
          onTap: () {
            print("clicked");
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 300),
                pageBuilder: (context, _, __) => Description(
                  characterData: charaterData,
                ),
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _pageController,
            builder: (BuildContext context, Widget child) {
              double value = 1;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page - currentPage;
                value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
              }
              // print(currentPage);
              return Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipPath(
                      clipper: CharacterCardBackgroundClipper(),
                      child: Hero(
                        tag: "background-${charaterData.name}",
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: charaterData.colors,
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft)),
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: "image-${charaterData.name}",
                    child: Align(
                      alignment: Alignment(1.0, -2.5),
                      child: Image.asset(
                        charaterData.imagePath,
                        height:
                            MediaQuery.of(context).size.height * 0.5 * value,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Hero(
                          tag: "name-${charaterData.name}",
                          child: Container(
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                charaterData.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Text("click to read more",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w300))
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CharacterCardBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path clippedPath = Path();
    double curveDistance = 40;

    clippedPath.moveTo(0, size.height * 0.4);
    clippedPath.lineTo(0, size.height - curveDistance);
    clippedPath.quadraticBezierTo(
        1, size.height - 1, 0 + curveDistance, size.height);
    clippedPath.lineTo(size.width - curveDistance, size.height);
    clippedPath.quadraticBezierTo(size.width + 1, size.height - 1, size.width,
        size.height - curveDistance);
    clippedPath.lineTo(size.width, 0 + curveDistance);
    clippedPath.quadraticBezierTo(size.width - 1, 0,
        size.width - curveDistance - 5, 0 + curveDistance / 3);
    clippedPath.lineTo(curveDistance, size.height * 0.29);
    clippedPath.quadraticBezierTo(
        1, (size.height * 0.30) + 10, 0, size.height * 0.4);
    return clippedPath;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

// class CharacterCardBackgroundClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path clippedPath = Path();
//     double curveDistance = (40/7.6) * SizeConfig.heightMultiplier;

//     clippedPath.moveTo(0, ((size.height * 0.4) / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.lineTo(0, ((size.height - curveDistance) / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.quadraticBezierTo(
//         (1 / 3.6) * SizeConfig.widthMultiplier, ((size.height - 1) / 7.6) * SizeConfig.heightMultiplier, ((0 + curveDistance) / 3.6) * SizeConfig.widthMultiplier, (size.height/7.6) * SizeConfig.heightMultiplier);
//     clippedPath.lineTo(((size.width - curveDistance) / 3.6) * SizeConfig.widthMultiplier, (size.height / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.quadraticBezierTo(((size.width + 1) / 3.6) * SizeConfig.widthMultiplier, ((size.height - 1) / 7.6) * SizeConfig.heightMultiplier, (size.width/3.6) * SizeConfig.widthMultiplier,
//         ((size.height - curveDistance) / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.lineTo((size.width/3.6) * SizeConfig.widthMultiplier, ((0 + curveDistance) / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.quadraticBezierTo(((size.width - 1) / 3.6) * SizeConfig.widthMultiplier, 0,
//         ((size.width - curveDistance - 5)/3.6) * SizeConfig.widthMultiplier, ((0 + curveDistance / 3) / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.lineTo((curveDistance/3.6) * SizeConfig.widthMultiplier, ((size.height * 0.29) / 7.6) * SizeConfig.heightMultiplier);
//     clippedPath.quadraticBezierTo(
//         (1/3.6) * SizeConfig.widthMultiplier, (((size.height * 0.30) + 10)/7.6) * SizeConfig.heightMultiplier, 0, ((size.height * 0.4) / 7.6) * SizeConfig.heightMultiplier);
//     return clippedPath;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return true;
//   }
// }
