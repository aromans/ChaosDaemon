import 'package:flutter/material.dart';
import 'dart:convert';


class Delegate implements Function {
  Map<int, Function> addedFunctions = {};

  Delegate();

  call({bool remove: true}) {
    List<Function> removeItems = [];
    addedFunctions.forEach((key, value) {
      value();
      
      if (remove)
        removeItems.add(value);
    });

    removeItems.forEach((element) {
      addedFunctions.remove(hash(element));
    });
  }

  void clear() {
    addedFunctions.clear();
  }

  int hash(Function fn) => fn.hashCode;

  operator +(Function fn) => addedFunctions[hash(fn)] = fn;
  operator -(Function fn) { 
    if (addedFunctions.containsKey(hash(fn)))
      addedFunctions.remove(hash(fn));
  } 
}

// Dart
// public static delegate<void> myDelegate;

// C#
// public delegate void OnButtonClickDelegate();
// public static OnButtonClickDelegate myDelegate;

// C# Add Functions
// myDelegate += someFunc;
// myDelegate += someFunc2;

// C# Call delegate
// myDelegate(); (Calls someFunc and someFunc2)

// C# Remove Functions
// myDelegate -= someFunc;
// myDelegate -= someFunc2;
//  -- or --
// myDelegate.clear()