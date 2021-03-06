import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// following this youtube video for basic app: https://youtu.be/X8B-UzqEaWc
// following this article for firebase: https://medium.com/shift-studio/flutter-redux-and-firebase-cloud-firestore-in-sync-2c1accabdac4


void main() => runApp(new MyApp());

@immutable
class AppState {
  final counter;
  AppState(this.counter);
}

// actions
enum Actions { 
  increment,
  requestCounterDataEvents,
  cancelCounterDataEvents 
}

// pure function
AppState reducer(AppState previousState, action) {
  if(action == Actions.increment) {
    return new AppState(previousState.counter+1);
  }
  return previousState;
}

class MyApp extends StatelessWidget {
  
  final store = new Store(reducer, initialState: new AppState(0));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData.dark(),
        home: new MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {  

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder(
      builder: (context, Store<AppState> store) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Flutter Redux"),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'You have pushed the button this many times:',
                ),
                new StoreConnector(
                  converter: (store) => store.state.counter,
                  builder: (context, counter) => new Text(
                    '$counter',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: new StoreConnector<int, VoidCallback>(
            converter: (store) {
              return () => store.dispatch(Actions.increment);},
            builder: (context, callback) =>  new FloatingActionButton(
              onPressed: callback,
              tooltip: 'Increment',
              child: new Icon(Icons.add),
          ),
          ), 
        );
      },
    );
  }
}
