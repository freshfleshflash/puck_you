class Insult {
  
  int recordId;
  String words;
  AudioPlayer audio;

  Insult(int recordId, String words, AudioPlayer audio) {
    this.recordId = recordId;
    this.words = words;
    this.audio = audio;
  }
}