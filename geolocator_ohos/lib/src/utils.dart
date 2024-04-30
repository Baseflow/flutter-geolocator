T? asT<T>(
  dynamic value, {
  T? defaultValue,
  bool tryToFixType = true,
}) {
  if (value is T) {
    return value;
  }

  if (defaultValue != null) {
    return defaultValue;
  }

  if (tryToFixType && value != null) {
    final String valueS = value.toString();
    if (0 is T) {
      return (int.tryParse(valueS) ?? double.tryParse(valueS)?.toInt()) as T?;
    } else if (0.0 is T) {
      return double.tryParse(valueS) as T?;
    } else if ('' is T) {
      return valueS as T;
    } else if (false is T) {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    } else if (DateTime.now() is T) {
      return DateTime.tryParse(valueS) as T?;
    }
  }
  return defaultValue;
}
