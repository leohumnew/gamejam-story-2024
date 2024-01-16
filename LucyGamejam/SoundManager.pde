class SoundManager {
    private SoundFile[] music;
    private Sound globalSoundManager;
    private int startTime, duration;
    private byte currentTrack = 0, fadeState = 0, fadeDestination = 0;

    SoundManager(SoundFile[] music, PApplet sketch) {
        this.music = music;
        globalSoundManager = new Sound(sketch);
    }

    void play(byte track) {
        music[track].loop();
    }

    void fadeTo(byte destination, int duration) {
        fadeDestination = destination;
        startTime = millis();
        this.duration = duration;
        fadeState = 1;
    }

    void update() {
        if (fadeState == 1) {
            globalSoundManager.volume(constrain(map(millis(), startTime, startTime + duration/2, 1, 0), 0, 1));
            if(millis() > startTime + duration) {
                fadeState = 2;
                music[currentTrack].stop();
                currentTrack = fadeDestination;
                music[currentTrack].loop();
            }
        } else if (fadeState == 2) {
            globalSoundManager.volume(constrain(map(millis(), startTime + duration/2, startTime + duration, 0, 1), 0, 1));
            if(millis() > startTime + duration * 2) {
                fadeState = 0;
            }
        }
    }
}