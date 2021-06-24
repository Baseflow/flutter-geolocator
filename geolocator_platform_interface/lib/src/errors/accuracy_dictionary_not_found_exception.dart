 /// An exception thrown when the Temporary Accuracy request key is missing in
 /// the Info.plist. The exception is only thrown on iOS.
 class AccuracyDictionaryNotFoundException implements Exception {
   /// Constructs the [AccuracyDictionaryNotFoundException]
   const AccuracyDictionaryNotFoundException(this.message);

   /// A [message] describing more details about the missing Dictionary key.
   final String? message;

   @override
   String toString() {
     if (message == null || message == '') {
       return 'Temporary Full accuracy key or description: '
           '\'NSLocationTemporaryUsageDescriptionDictionary\' is missing in the'
           ' Info.plist dictionary.'
       ;
     }
     return message!;
   }
 }