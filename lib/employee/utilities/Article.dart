class Article {
  String? Title;
  String? Subtitle;
  String? Genre;
  String? isFeatured;
  String? Author;
  Article(
      {title = null,
      subtitle = null,
      genre = null,
      featured = null,
      author = null}) {
    this.Title = title;
    this.Subtitle = subtitle;
    this.Genre = genre;
    this.isFeatured = featured;
    this.Author = author;
  }
  void setTitle(title) {
    this.Title = title;
  }

  void setSubtitle(subtitle) {
    this.Subtitle = subtitle;
  }

  void setGenre(genre) {
    this.Genre = genre;
  }

  void setIsFeatured(featured) {
    this.isFeatured = featured;
  }

  void setAuthor(author) {
    this.Author = author;
  }

  Map<String, dynamic> getAsMap() {
    return {
      "title": this.Title,
      "subtitle": this.Subtitle,
      "genre": this.Genre,
      "isFeatured": this.isFeatured,
      "author": this.Author
    };
  }
}
