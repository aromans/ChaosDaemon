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
    if (addedFunctions.containsKey(hash(fn))) addedFunctions.remove(hash(fn));
  }
}

class TypeDelegate<T> implements Function {
  Map<int, T? Function()> addedFunctions = {};

  TypeDelegate();

  List<T?> call() {
    List<T?> returned_values = [];
    addedFunctions.forEach((key, value) {
      returned_values.add(value());
    });

    return returned_values;
  }

  void clear() {
    addedFunctions.clear();
  }

  int hash(T? Function() fn) => fn.hashCode;

  operator +(T? Function() fn) => addedFunctions[hash(fn)] = fn;
  operator -(T? Function() fn) {
    if (addedFunctions.containsKey(hash(fn))) addedFunctions.remove(hash(fn));
  }
}
