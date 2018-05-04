import ddf.minim.*;

class Waveform extends GUIElement {
    
  Minim minim; 
  AudioSample sound; 
  AudioPlayer soundbis;
  private FloatList sampleAverage; 
  private int border, leftLength, rightLength;
  private int sampleRate = 0;
  
  // Resolution of the display
  private int sizeOfAvg = 600;
  
  // width adjustment for audio display
  private int widthScale = 300;
  
  String soundfilePath = "data\\test-audio-file.wav";
  
  Waveform(GUIElement parent, int x, int y, int gridSize){
    super(parent, x, y, gridSize, gridSize);
    
    //loadSoundFile(soundfilePath);
  }
  
  public void loadSoundFile(String path){
    soundfilePath = path;
    minim = new Minim(this);
    sound = minim.loadSample(soundfilePath, 2048);
    soundbis = minim.loadFile(soundfilePath);
    println(soundbis.bufferSize());
    
    resizeDisplay();
  }
  
  public void resizeDisplay(){
    float[] leftSamples = sound.getChannel(AudioSample.LEFT);
    float[] rightSamples = sound.getChannel(AudioSample.RIGHT);
    float [] samplesVal = new float[rightSamples.length];
    for (int i=0; i <rightSamples.length; i++) {
      samplesVal[i] = leftSamples[i]+ rightSamples[i];
    }
    
    leftLength  = leftSamples.length;
    rightLength = rightSamples.length;
   
    //2. reduce quantity : get an average from those values each  16 348 samples
    sampleAverage = new FloatList();
    int average=0;
    for (int i = 0; i< samplesVal.length; i+=1) {
      average += abs(samplesVal[i] * widthScale) ; // sample are low value so we increase the size to see them
      
      if ( i % sizeOfAvg == 0 && i!=0) { 
        sampleAverage.append( average / sizeOfAvg);
        average = 0;
      }
    }
  }
  
  public void setSampleRate(int sampleRate){
    this.sampleRate = sampleRate;
  }
  
  public void display(){
    
    if(sampleRate != 0 && sound != null){
      fill(190);
      strokeWeight(1);
      
      // Draw the waveform display and the time. Time is currently showing each second
      float prevTime = -1;
      for ( int i=0; i < sampleAverage.size(); i++) {
        // Draw the sound file
        line(width - border*2, -i + height - border, (width - border*2) - sampleAverage.get(i), -i + height - border);
        
        // Draw the text (time in seconds)
        float time = floor((i * sizeOfAvg) / sampleRate);
        if(prevTime != time){
          prevTime = time;
          //text(round(time), i + border, height-border/2);
          text(round(time), width - border, height - i - border);
        }
      }
    }
  }
}