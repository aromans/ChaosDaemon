class Delegate implements Function {
  Map<int, Function> addedFunctions = {};

  Delegate();

  call() {
    addedFunctions.forEach((key, value) {
      value();
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