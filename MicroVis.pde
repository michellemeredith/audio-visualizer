import ddf.minim.*;
import ddf.minim.analysis.FFT;
import java.util.Random;

private Minim minim;
private AudioInput in;
private FFT fft;

private int rB = 255; // red value - background
private int gB = 255; // green value - background
private int bB = 255; // blue value - background

private int rL = 0; //  color for the Lines
private int gL = 0; 
private int bL = 0;

private int rC = 0; //  color for the circles
private int gC = 0; 
private int bC = 0;
private int t = 0;

private int rBurst = 0; //  color for the Bursts
private int gBurst = 0; 
private int bBurst = 0;

public void setup() {
  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());

  background(rB, gB, bB);
  fullScreen();
}

public void draw() {  
  noCursor();
  chooseTheme();
  waveforms();
  circles();
  //bursts();

  // String monitoringState = in.isMonitoring() ? "enabled" : "disabled";
  //text( "Input monitoring is currently " + monitoringState + ".", 5, 15 );
}

private void waveforms() {
  stroke(rL, gL, bL);

  // draw the waveforms so we can see what we are monitoring
  for (int i = 0; i < in.bufferSize() - 1; i++) {
    float x1 = map(i, 0, in.bufferSize(), 0, width);
    float x2 = map(i + 1, 0, in.bufferSize(), 0, width);

    // multiply by 80 since the actual wavelengths are relatively small
    line(x1, (height/2 - 40) + in.left.get(i) * 300, x2, (height/2 - 40) + in.left.get(i + 1) * 300); 
    line(x1, (height/2 + 40) + in.left.get(i) * 300, x2, (height/2 + 40) + in.left.get(i + 1) * 300);

    if (in.mix.level() > 0.03) { //BASS 
      stroke(rL, gL, bL, 50);
      line(x1, (height/2 - 60) + in.left.get(i) * 300, x2, (height/2 - 60) + in.left.get(i + 1) * 300); 
      line(x1, (height/2 + 60) + in.left.get(i) * 300, x2, (height/2 + 60) + in.left.get(i + 1) * 300);
    }
  }
}

private void circles() {
  //song.left.level()*width is the radius/means the circle gets bigger w/ level increase
  stroke(rC, gC, bC, t);
  fill(rC, gC, bC, 50);
  ellipse(width/2, height/2, in.left.level() * width + 180, in.left.level() * width + 180);
  noStroke();
  fill(rC, gC, bC, 50);
  ellipse(width/2, height/2, in.left.level() * width + 275, in.left.level() * width + 275);
  fill(rC, gC, bC, 30);
  ellipse(width/2, height/2, in.left.level() * width + 300, in.left.level() * width + 300);
}

private void bursts() {
  float angle;
  float ratio = fft.specSize()/PI;

  if (in.mix.level() > 0.04) { //BASS 
    //fill(255, 207, 226, 100);
    fft.forward(in.mix);
    float f = fft.specSize()/360.0f;
    angle = 0;
    ratio = fft.specSize()/PI;

    stroke(rBurst, gBurst, bBurst, 150);
    for (int i = 0; i < fft.specSize(); i ++) {
      angle += ratio;
      line((width/4) + cos(angle) * (in.left.level() * 10), 
        (height/4) + sin(angle) * (in.left.level() * 10), 
        (width/4) + cos(angle) * fft.getBand(i) * 2 * (in.left.level() * 10), 
        (height/4) + sin(angle) * fft.getBand(i) * 2* (in.left.level() * 10));
    }
    for (int i = 0; i < fft.specSize(); i ++) {
      angle += ratio;
      line((width/4) + cos(angle) * (in.left.level() * 10), 
        (height/4 + height/2) + sin(angle) * (in.left.level() * 10), 
        (width/4) + cos(angle) * fft.getBand(i) * 2 * (in.left.level() * 10), 
        (height/4 + height/2) + sin(angle) * fft.getBand(i) * 2* (in.left.level() * 10));
    }
    for (int i = 0; i < fft.specSize(); i ++) {
      angle += ratio;
      line((width/4 + width/2) + cos(angle) * (in.left.level() * 10), 
        (height/4) + sin(angle) * (in.left.level() * 10), 
        (width/4 + width/2) + cos(angle) * fft.getBand(i) * 2 * (in.left.level() * 10), 
        (height/4) + sin(angle) * fft.getBand(i) * 2* (in.left.level() * 10));
    }
    for (int i = 0; i < fft.specSize(); i ++) {
      angle += ratio;
      line((width/4 + width/2) + cos(angle) * (in.left.level() * 10), 
        (height/4 + height/2) + sin(angle) * (in.left.level() * 10), 
        (width/4 + width/2) + cos(angle) * fft.getBand(i) * 2 * (in.left.level() * 10), 
        (height/4 + height/2) + sin(angle) * fft.getBand(i) * 2* (in.left.level() * 10));
    }
  }
}

public void keyPressed() {
  if ( key == 'm' || key == 'M' ) {
    if ( in.isMonitoring() ) {
      in.disableMonitoring();
    } else {
      in.enableMonitoring();
    }
  }
}

// pre-selected color themes
private void chooseTheme() {    
  if (keyPressed && key == '0') { // ~ r a n d o m   e v e r y t h i n g ~ 
    Random rand = new Random();
    rB = rand.nextInt(255);
    gB = rand.nextInt(255);
    bB = rand.nextInt(255);

    rC = rand.nextInt(255);
    gC = rand.nextInt(255); 
    bC = rand.nextInt(255);

    rL = rand.nextInt(255);
    gL = rand.nextInt(255);
    bL = rand.nextInt(255);

    rBurst = rand.nextInt(255);
    gBurst = rand.nextInt(255);
    bBurst = rand.nextInt(255);
  } else if (keyPressed && key == '1') { // white & gold & blue
    rB = 255;
    gB = 255;
    bB = 255;

    rC = 245;
    gC = 214; 
    bC = 60;

    rL = 245;
    gL = 214;
    bL = 60;

    rBurst = 6;
    gBurst = 47;
    bBurst = 112;
  } else if (keyPressed && key == '2') { // black & light pink & gold
    rB = 0;
    gB = 0;
    bB = 0;

    rC = 255;
    gC = 207; 
    bC = 226;

    rL = 255;
    gL = 207;
    bL = 226;

    rBurst = 245;
    gBurst = 214;
    bBurst = 60;
  } else if (keyPressed && key == '3') { // salmon & white
    rB = 255;
    gB = 91;
    bB = 91;

    rC = 255;
    gC = 255; 
    bC = 255;

    rL = 255;
    gL = 255;
    bL = 255;

    rBurst = 255;
    gBurst = 255;
    bBurst = 255;
  } else if (keyPressed && key == '4') { // teal & white & salmon
    rB = 91;
    gB = 255;
    bB = 227;

    rC = 255;
    gC = 255; 
    bC = 255;

    rL = 255;
    gL = 131;
    bL = 122;

    rBurst = 255;
    gBurst = 131;
    bBurst = 122;
  } else if (keyPressed && key == '5') { // kanye season 2 (?)
    rB = 252;
    gB = 219;
    bB = 176;

    rC = 255;
    gC = 255; 
    bC = 255;

    rL = 255;
    gL = 255;
    bL = 255;

    rBurst = 255;
    gBurst = 255;
    bBurst = 255;
  } else if (keyPressed && key == '9') { // random background
    Random rand = new Random();
    rB = rand.nextInt(255);
    gB = rand.nextInt(255);
    bB = rand.nextInt(255);

    rC = 255;
    gC = 255; 
    bC = 255;

    rL = 255;
    gL = 255;
    bL = 255;

    rBurst = 255;
    gBurst = 255;
    bBurst = 255;
  }

  background(rB, gB, bB);
}
