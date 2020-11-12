import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockmanagement/onboard&login/onboarding_model.dart';

class OnBoardingWidget extends StatefulWidget {
  final List<OnBoardingModel> pages;
  final Color bgColor;
  final Color themeColor;
  final ValueChanged<String> skipClicked;
  final Function loginClicked;

  const OnBoardingWidget(
      {Key key,
      @required this.pages,
      @required this.bgColor,
      @required this.themeColor,
      @required this.skipClicked,
      @required this.loginClicked})
      : super(key: key);

  @override
  _OnBoardingWidgetState createState() => _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends State<OnBoardingWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.pages.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  List<Widget> buildOnBoardingPages() {
    final children = <Widget>[];
    for (int i = 0; i < widget.pages.length; i++) {
      children.add(_showPageData(widget.pages[i]));
    }
    return children;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
          color: isActive ? widget.themeColor : Color(0xFF929794),
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.bgColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        widget.skipClicked("Skip Tapped");
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                      height: 500,
                      color: Colors.transparent,
                      child: PageView(
                        physics: ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: buildOnBoardingPages(),
                      )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator()),
                  _currentPage != widget.pages.length - 1
                      ? Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20, bottom: 10),
                              child: FloatingActionButton(
                                backgroundColor: widget.bgColor,
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                              ),
                            ),
                          ),
                        )
                      : Text('')
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == widget.pages.length - 1
          ? _showLoginButton()
          : Text(''),
    );
  }

  Widget _showPageData(OnBoardingModel page) {
    return Padding(
      padding: EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage(page.imgPath),
              height: 300,
              width: 300,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            page.title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: page.titleColor,
                fontSize: 20),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            page.desc,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: page.descColor,
                fontSize: 16),
          )
        ],
      ),
    );
  }

// You can custom login in this part
  Widget _showLoginButton() {
    final GestureDetector loginButtonWithGesture = new GestureDetector(
      onTap: widget.loginClicked,
      child: new Container(
        height: 50,
        decoration: new BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: new BorderRadius.all(Radius.circular(6.0))),
        child: new Center(
          child: new Text(
            'Login with Google',
            style: new TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
    return new Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 30.0),
      child: loginButtonWithGesture,
    );
  }
}
