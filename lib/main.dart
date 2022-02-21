import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xff222747),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.grey.shade800,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: EdgeInsets.symmetric(horizontal: 56, vertical: 16),
          ),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        cardColor: Color(0xff444968),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var assetAmount = 0;
  var liabilitiesAmount = 0;

  void setAssetAmount(int asset) {
    setState(() {
      assetAmount = asset;
    });
  }

  void setLiabilitiesAmount(int liabilities) {
    setState(() {
      liabilitiesAmount = liabilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 48,
                ),
                Text(
                  "Add your assets and liabilities",
                  style: theme.textTheme.headline5,
                ),
                const SizedBox(height: 102),
                AmountCard(
                  title: "Assets",
                  amount: assetAmount,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return NumberInputDialog(
                        onTap: setAssetAmount,
                        title: 'Assets',
                        amount: assetAmount,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                AmountCard(
                  title: "Liabilities",
                  amount: liabilitiesAmount,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return NumberInputDialog(
                        onTap: setLiabilitiesAmount,
                        title: 'Liabialities',
                        amount: liabilitiesAmount,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 102),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          NetworthPage(amount: assetAmount - liabilitiesAmount),
                      fullscreenDialog: true,
                    ),
                  ),
                  child: Text(
                    'Calculate',
                    style: theme.textTheme.button!.copyWith(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AmountCard extends StatelessWidget {
  const AmountCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final int amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 148,
      width: size.width * 0.8,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 4),
              Text(
                amount.toString(),
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NumberInputDialog extends StatefulWidget {
  const NumberInputDialog({
    Key? key,
    required this.onTap,
    required this.title,
    required this.amount,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final int amount;

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.amount == 0 ? '' : widget.amount.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.shade600,
        width: 1,
      ),
    );

    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: screenSize.width * 0.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .accentTextTheme
                  .headline6
                  ?.copyWith(color: Colors.grey.shade800),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.grey.shade900),
              autofocus: true,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                labelStyle: TextStyle(color: Colors.grey.shade600),
                focusedBorder: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                labelText: 'Amount',
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).cardColor,
                padding: EdgeInsets.symmetric(horizontal: 56),
              ),
              onPressed: () {
                widget.onTap(int.parse(_controller.text));
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworthPage extends StatefulWidget {
  const NetworthPage({
    Key? key,
    required this.amount,
  }) : super(key: key);

  final int amount;

  @override
  _NetworthPageState createState() => _NetworthPageState();
}

class _NetworthPageState extends State<NetworthPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500));

  late final Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _animation = IntTween(begin: 0, end: widget.amount).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _animation,
              builder: (context, value, child) {
                return Text(
                  'Your total net worth is: $value',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
