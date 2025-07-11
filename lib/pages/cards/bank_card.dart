import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kube/pages/cards/card.dart';
import 'package:kube/pages/cards/cards_state.dart';
import 'package:provider/provider.dart';

class BankCard extends StatefulWidget {
  final CardModel cardModel;
  final String mobileNumber = '6302535979';
  // final String mobileNumberString = '+91 $mobileNumber';

  BankCard({super.key, required this.cardModel});

  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController, secondAnimationController;
  late SequenceAnimation sequenceAnimation;
  late SequenceAnimation hideNotSelectedCardSequenceAnimation;

  late Animation rotateAnimation;

  late AnimationController flipAnimationController;

  late Animation flipAnimation;
  double horizontalDrag = 0;

  bool isFront = true;

  @override
  void dispose() {
    animationController.dispose();
    flipAnimationController.dispose();
    secondAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );

    flipAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    secondAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );

    // rotateAnimation = Tween<double>(
    //   begin: -80 / 360,
    //   end: 0,
    // ).animate(secondAnimationController);

    // secondAnimationController.forward();

    // secondAnimationController.addListener(() {
    //   setState(() {});
    // });

    hideNotSelectedCardSequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          from: const Duration(milliseconds: 0),
          to: const Duration(milliseconds: 0),
          animatable: Tween<double>(begin: 1, end: 0),
          tag: 'hide',
        )
        .animate(animationController);

    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          from: const Duration(milliseconds: 400),
          to: const Duration(milliseconds: 800),
          animatable: Tween<double>(begin: 1.07, end: 1.0),
          tag: 'scale',
        )
        .addAnimatable(
          from: const Duration(milliseconds: 600),
          to: const Duration(milliseconds: 800),
          animatable: Tween<double>(begin: 0, end: 90 / 360),
          tag: 'rotate',
        )
        .addAnimatable(
          from: const Duration(milliseconds: 800),
          to: const Duration(milliseconds: 1000),
          animatable: Tween<AlignmentGeometry>(
            begin: Alignment.center,
            end: Alignment.topCenter,
          ),
          tag: 'align',
        )
        .addAnimatable(
          from: const Duration(milliseconds: 800),
          to: const Duration(milliseconds: 1000),
          animatable: Tween<Offset>(
            begin: const Offset(0, 0),
            end: const Offset(0, 0),
          ),
          curve: Curves.easeIn,
          tag: 'slide',
        )
        .addAnimatable(
          from: const Duration(milliseconds: 100),
          to: const Duration(milliseconds: 100),
          animatable: Tween<double>(begin: .9, end: 1),
          curve: Curves.elasticOut,
          tag: 'bouncing',
        )
        .animate(animationController);

    animationController.addStatusListener((status) {
      if (kDebugMode) {
        print("BANK CARD CLICKED STATUS: $status");
      }
      setState(() {});
    });
  }

  void resetCardState() {
    setState(() {
      horizontalDrag = 0;
      isFront = true;
    });
  }

  void handleCardAnimation() {
    if (Provider.of<AppState>(context, listen: false).isViewingCardDetail) {
      resetCardState();
    }
    if (animationController.isCompleted) {
      Provider.of<AppState>(context, listen: false).currentCard = null;
      animationController.reverse();
      secondAnimationController.reset();
    } else {
      Provider.of<AppState>(context, listen: false).currentCard =
          widget.cardModel;

      if (kDebugMode) {
        print("CLICKED CARD: ${widget.cardModel.toString()}");
      }
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<AppState>(
      builder:
          (context, appState, _) => GestureDetector(
            onHorizontalDragStart: (_) {
              flipAnimationController.reset();
              setState(() {
                resetCardState();
              });
            },
            onHorizontalDragUpdate: (details) {
              if (appState.isViewingCardDetail) {
                setState(() {
                  horizontalDrag += details.delta.dx;
                  horizontalDrag %= 360;

                  if (kDebugMode) {
                    print("HORIZONTAL DRAG :$horizontalDrag");
                  }
                  setCardSide();
                });
              }
            },
            onHorizontalDragEnd: (details) {
              final double end = 360 - horizontalDrag >= 180 ? 0 : 360;

              flipAnimation = Tween<double>(
                begin: horizontalDrag,
                end: end,
              ).animate(flipAnimationController)..addListener(() {
                setState(() {
                  horizontalDrag = flipAnimation.value;
                  setCardSide();
                });
              });

              flipAnimationController.forward();
            },
            onTap: handleCardAnimation,
            child: Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, .001)
                    ..rotateY(-(horizontalDrag / 180) * pi),
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                offset: Offset(
                  appState.isViewingCardDetail ? (appState.dragRatio / 1.2) : 0,
                  0,
                ),
                child: AnimatedBuilder(
                  animation: animationController,
                  builder:
                      (context, child) => Transform(
                        transform: Matrix4.identity()..setEntry(3, 2, 0.008),
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          scale: appState.isViewingCardDetail ? 1 : 1,
                          child: ScaleTransition(
                            scale:
                                sequenceAnimation['scale'] as Animation<double>,
                            child: SlideTransition(
                              position:
                                  sequenceAnimation['slide']
                                      as Animation<Offset>,
                              child: ScaleTransition(
                                scale:
                                    sequenceAnimation['bouncing']
                                        as Animation<double>,
                                child: Transform.translate(
                                  offset: const Offset(0, -78),
                                  child: child,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  child:
                      isFront
                          ? cardFront
                          : Transform(
                            transform: Matrix4.identity()..rotateX(pi),
                            alignment: Alignment.center,
                            child: cardBack,
                          ),
                ),
              ),
            ),
          ),
    );
  }

  Widget get cardBack => LayoutBuilder(
    builder: (context, constraints) {
      final cardWidth = MediaQuery.of(context).size.width * 1.85;
      return Center(
        child: SizedBox(
          width: cardWidth,
          child: AspectRatio(
            aspectRatio: 1.586,
            child: Transform.rotate(
              angle: pi,
              child: Card(
                elevation: 12,
                shadowColor: Colors.black12.withOpacity(.002),
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.cardModel.colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      transform: const GradientRotation(1 / 16),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        offset: const Offset(0, 25),
                        blurRadius: 50,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'CUSTOMER SERVICE +91-6305259511',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'AUTHORIZED SIGNATURE',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              '123',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'This card is issued by [Your Bank Name], pursuant to a license from Visa.\nTerms apply.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 10,
                          height: 1.3,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget get cardFront => Card(
    elevation: 12,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.transparent,
    child: LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = MediaQuery.of(context).size.width - 52;
        return Center(
          child: SizedBox(
            width: cardWidth,
            child: AspectRatio(
              aspectRatio: .1,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.cardModel.colors,
                    transform: const GradientRotation(1 / 16),
                    end: Alignment.bottomCenter,
                    begin: Alignment.topLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        'Bank Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/chip.png',
                          width: 57,
                          height: 43,
                        ),
                        const SizedBox(width: 12),
                        Transform.rotate(
                          angle: pi / 2,
                          child: const Icon(
                            FontAwesomeIcons.wifi,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: Text(
                        '1234 5678 1234 5678',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'ShareTechMono',
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'CARD HOLDER',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'JOHN DOE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'EXPIRE DATE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 8,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '02/11',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Image.asset(
                            'assets/images/Visa_Brandmark_White_RGB_2021.png',
                            height: 18,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );

  setCardSide() {
    isFront = (horizontalDrag <= 90 || horizontalDrag >= 270);
  }

  @override
  bool get wantKeepAlive => true;
}
