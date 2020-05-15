import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

enum SoundEffect {
  FAILED,
  FIRE,
  LIGHTNING,
  SUCCESS,
  SWIPE,
  LOCK,
  BIP,
  LONG_CELEBRATION,
  MIDDLE_CELEBRATION,
  SHORT_CELEBRATION
}

class SoundController {
  static final SoundController instance = SoundController._internal();

  SoundController._internal();

  var _audios = new Map();

  AudioPlayer _music;

  AudioCache player = AudioCache(prefix: 'sounds/');

  double _getVolumen(int soundVolume, double volume) {
    double factor = soundVolume == 0 ? 0.0 : soundVolume == 1 ? 0.5 : 1.0;
    return volume * factor;
  }

  AudioPlayer getAudio(String name) =>
      _audios.containsKey(name) ? _audios[name] : null;

  void remove(String name) {
      if (_audios.containsKey(name)) _audios.remove(name);
  }

  void playMusic(int musicVolume, double volume) {    
    if (musicVolume > 0) {
      stopMusic();
      double vol = _getVolumen(musicVolume, volume);
      player.loop("music0.mp3", volume: vol).then((audio) => _music = audio);
    }
  }

  void stopMusic() {
    if (_music != null) {
      _music.stop();
    }
  }

  void play(SoundEffect effect, int soundVolume, double volume, {String name}) {
    void saveAudioOnMap(AudioPlayer audio) {
      if (name != null) _audios[name] = audio;
    }

    if (soundVolume > 0) {
      double vol = _getVolumen(soundVolume, volume);
      switch (effect) {
        case SoundEffect.FAILED:
          player.play("failed.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.FIRE:
          player.play("fire.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.LIGHTNING:
          player.play("lightning.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.SUCCESS:
          player.play("success.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.SWIPE:
          player.play("swipe.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.LOCK:
          player.play("lock.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.BIP:
          player.play("bip.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.LONG_CELEBRATION:
          player.play("long_celebration.mp3", volume: vol).then(saveAudioOnMap);
          break;
        case SoundEffect.MIDDLE_CELEBRATION:
          player
              .play("middle_celebration.mp3", volume: vol)
              .then(saveAudioOnMap);
          break;
        case SoundEffect.SHORT_CELEBRATION:
          player
              .play("short_celebration.mp3", volume: vol)
              .then(saveAudioOnMap);
          break;
      }
    }
  }
}
