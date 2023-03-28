import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 0);
final str = StateProvider((ref) => "2");

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Counter Page'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => CounterPage()),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CounterPage extends ConsumerWidget {
  // const CounterPage({Key? key}) : super(key: key);key
  var _formKey = GlobalKey<FormState>();
  var isLoading = false;

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Using the WidgetRef to get the counter int from the counterProvider.
    // The watch method makes the widget rebuild whenever the int changes value.
    //   - something like setState() but automatic

    TextEditingController mycontroller = TextEditingController();
    final int counter = ref.watch(counterProvider);
    final String validation = ref.watch(str);
    final controller = ref.watch(str);
    // ref.listen<String>(str, (previous, next) {
    //   if (next == "4") {
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           title: Text('Warning'),
    //           content: Text('its null'),
    //           actions: [
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: Text('OK'),
    //             )
    //           ],
    //         );
    //       },
    //     );
    //   }
    // });
    ref.listen<int>(
      counterProvider,
      // "next" is referring to the new state.
      // The "previous" state is sometimes useful for logic in the callback.
      (previous, next) {
        if (next >= 5) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Warning'),
                content:
                    Text('Counter dangerously high. Consider resetting it.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ],
              );
            },
          );
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(counterProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(str);
            },
            icon: const Icon(Icons.ac_unit_outlined),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: mycontroller,
                  onChanged: (text) {
                    // mycontroller.text= text;

                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter Your Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter a valid name';
                    }
                    return null;
                  },
                ),
              ),
              Text(
                counter.toString(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                validation.toString(),
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ])),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final isValid = _formKey.currentState?.validate();
          if (!isValid!) {
            return;
          } else {
            ref.read(str.state).state = mycontroller.text;
            // Using the WidgetRef to read() the counterProvider just one time.
            //   - unlike watch(), this will never rebuild the widget automatically
            // We doxn't want to get the int but the actual StateNotifier, hence we access it.
            // StateNotifier exposes the int which we can then mutate (in our case increment).

            // ref
            //     .read(str.notifier)
            //     .state++;
            ref.read(counterProvider.notifier).state++;
          }
        },
      ),
    );
  }
}
