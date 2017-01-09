class Insult {

  int recordId;
  String words;
  AudioPlayer audio;
  TTS tts;

  Insult(int recordId, String words, AudioPlayer audio) {
    this.recordId = recordId;
    this.words = words;
    this.audio = audio;
  }

  Insult(int recordId, String words, TTS tts) {
    this.recordId = recordId;
    this.words = words;
    this.tts = tts;
  }
}