import 'package:bank_cards_ui/data/card.dart';
import 'package:bank_cards_ui/state.dart';
import 'package:bank_cards_ui/utils/colors.dart';
import 'package:bank_cards_ui/widgets/cards_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tinycolor2/tinycolor2.dart';

import 'data/transaction.dart';
import 'utils/text_styles.dart';
import 'widgets/transaction_widget.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  PageController? pageController;

  late Animation<Offset> slideTransition;

  late DraggableScrollableController scrollableController;

  int currentPage = 0;

  double sheetMaxSize = .85;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      scrollableController =
          Provider.of<AppState>(context, listen: false).scrollableController;

      scrollableController.addListener(() {
        Provider.of<AppState>(context, listen: false).dragRatio =
            scrollableController.size / sheetMaxSize;
      });

      pageController =
          Provider.of<AppState>(context, listen: false).pageController;

      pageController?.addListener(() {
        setState(() {
          currentPage = pageController?.page!.floor() ?? 0;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(
          FontAwesomeIcons.longArrowLeft,
          color: Colors.white,
          size: 24,
        ),
      ),
      body: Consumer<AppState>(builder: (context, appState, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedCrossFade(
                      alignment: Alignment.center,
                      secondCurve: Curves.easeIn,
                      firstCurve: Curves.easeOut,
                      crossFadeState: appState.isViewingCardDetail
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 500),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Full Card',
                            style: TextStyles.mainTextStyle.apply(
                              fontSizeDelta: 2,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Rotate the card to view the security code',
                            style: TextStyles.mainTextStyle.apply(
                              fontSizeDelta: -4,
                              color: TextStyles.mainTextStyle.color?.darken(),
                            ),
                          ),
                        ],
                      ),
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bank Cards',
                                style: TextStyles.mainTextStyle.apply(
                                  fontSizeDelta: 15,
                                  fontWeightDelta: 5,
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/avatar.png',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 36,
                          ),
                          Text(
                            'Balance',
                            style: TextStyles.mainTextStyle.apply(
                              fontSizeDelta: -2,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 800),
                            child: Text(
                              "\$${cards[currentPage].balance}",
                              style: TextStyles.mainTextStyle.apply(
                                fontSizeDelta: 8,
                                fontWeightDelta: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Expanded(
                    child: CardsList(),
                  )
                ],
              ),
            ),
            draggableSheet(),
          ],
        );
      }),
    );
  }

  Widget draggableSheet() =>
      Consumer<AppState>(builder: (context, appState, _) {
        return DraggableScrollableSheet(
          snap: true,
          // controller: scrollableController,
          controller: appState.scrollableController,
          expand: true,
          initialChildSize: .18,
          minChildSize: .18,
          maxChildSize: sheetMaxSize,
          builder: (context, controller) => AnimatedSlide(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
            offset: appState.isViewingCardDetail
                ? const Offset(0, 0)
                : const Offset(0, 2),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bottomSheetColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  controller: controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "Today",
                        style: TextStyles.mainTextStyle.apply(
                          fontWeightDelta: 5,
                          fontSizeDelta: 2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.all(8),
                      physics: const ClampingScrollPhysics(),
                      separatorBuilder: (context, i) => Divider(
                        color: Colors.grey.withOpacity(.2),
                      ),
                      itemCount: transactions.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) => TransactionWidget(
                        transaction: transactions[i],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
