import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kube/pages/cards/bank_card.dart';
import 'package:kube/pages/cards/card.dart';
import 'package:kube/pages/cards/cards_state.dart';
import 'package:provider/provider.dart';

class CardsList extends StatefulWidget {
  const CardsList({super.key});

  @override
  State<CardsList> createState() => _CardsListState();
}

class _CardsListState extends State<CardsList>
    with SingleTickerProviderStateMixin {
  CardModel tappedCard = cards.first;
  int currentPage = 0;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 20),
      vsync: this,
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<AppState>(
    builder:
        (context, appState, _) => PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: appState.pageController,
          itemCount: cards.length,
          physics:
              !appState.isViewingCardDetail
                  ? const BouncingScrollPhysics()
                  : const BouncingScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              if (kDebugMode) {
                print("CURRENT PAGE :$index");
              }
              currentPage = index;
              animationController.forward();
              if (currentPage == cards.length - 1) {
                animationController.forward();
              } else {
                animationController.reset();
              }
            });
          },
          itemBuilder:
              (context, i) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 240,
                  // width: 440,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 400),
                    scale: cards.isSelectedCard(appState, i) ? 1 : 1,
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (context, _) {
                        Animation animation = Tween(
                          begin: 12.0,
                          end: 0.0,
                        ).animate(
                          CurvedAnimation(
                            parent: animationController,
                            curve: Curves.easeInOut,
                          ),
                        );

                        return buildCard(
                          index: i,
                          angle:
                              (i == currentPage || i == currentPage - 1)
                                  ? 0
                                  : animation.value,
                        );
                      },
                    ),
                  ),
                ),
              ),
        ),
  );

  Widget buildCard({required int index, double angle = 0}) => Transform(
    alignment: Alignment.center,
    transform:
        Matrix4.identity()
          ..setEntry(3, 2, .002)
          ..rotateY(angle / 2)
          ..translate(angle / 4),
    child: BankCard(cardModel: cards[index]),
  );
}
