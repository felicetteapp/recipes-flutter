extension FRStringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String normalizeForSearch() {
    const accents =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const withoutAccents =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    var result = this;
    for (var i = 0; i < accents.length; i++) {
      result = result.replaceAll(accents[i], withoutAccents[i]);
    }

    return result.toLowerCase();
  }
}
