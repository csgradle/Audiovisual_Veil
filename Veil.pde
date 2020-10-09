import ddf.minim.*;
Minim minim;
AudioPlayer song;
int buffer;
int step = 3;
int radius = 200;
int bumpSize = 100;
float offset = 0;
float lastTotal = 0;
float lerpTotal = 0;
void setup() {
  size(800,800);
  minim = new Minim(this);
  song = minim.loadFile("Viel.mp3");
  buffer = song.bufferSize();
  song.play();
  
}

void draw() {
  if(!song.isPlaying()) {
    return;
  }
  background(0);
  for(int y = 0; y < height; y+=height/10) {
    drawLines(-150, y+150, y+50, -50);
    drawLines(y-150, height+150, width+50, y-50);
  }
  push();
  translate(width/2, height/2);
  float total = 0;
  for(int i = 0; i < buffer/4; i+=step) {
    float dir = radians(map(i, 0, buffer/4, 0, 360));
    float bump = song.right.get(i) * bumpSize;
    float bumpL = song.left.get(i) * bumpSize;
    float x = (radius+bump)*cos(dir);
    float y = (radius+bump)*sin(dir);
    float x2 = (radius-bumpL)*cos(dir);
    float y2 = (radius-bumpL)*sin(dir);
    float r = map(bump/bumpSize, -0.8, 0.1, 0, 255);
    //color c = color(r);
    float w = 14;
    
    stroke(255);
    strokeWeight(w);
    line(x2,y2, x, y);
    
    total += abs(bump/bumpSize);
  }
  lerpTotal += (total - lerpTotal)/5;

  noStroke();
  for(int i = 5; i > 0; i--) {
    fill(i*(255/5));
    float percent = float(i)/5;
    float rr = radius/2.8+lerpTotal*3.5;
    ellipse(0,0,rr*percent,rr*percent);
  }
  
  pop();
  offset += lerpTotal/10+1;
  
  lastTotal = total;
  if(frameCount % 60 ==0) {
    println(frameRate);
  }
}
void drawLines(float x, float y, float x2, float y2) {
  float speed = abs(0.1*x + 0.1*y + 0.05*x2 + 0.2*y2) % 10*0.5 +1;
  Vector2 l = new Vector2(x2-x, y2-y);
  Vector2 norm = l.norm();
  float n = 0;
  for(float i = 0; i < l.mag();) {
    n++;
    float len = int(abs((2*x+30+y+i + 5*n)))%60 + 150;
    i += len;
    float c = int(abs((2*x+30+y+i + 5*n)))%100 + 55;
    stroke(c + (speed - 1.5) * 40,0,0);
    strokeWeight(40);
    float ii = (l.mag()*(ceil(abs(offset*speed)/l.mag())) + i - offset*speed) % l.mag();
    line(x+ norm.x*(ii + len-50) , y+ norm.y*(ii + len-50),  x+ norm.x*(ii), y+ norm.y*(ii));
  }
}
void keyPressed()
{
  if ( song.isPlaying() ) {
    song.pause();
  } else {
    song.play();
  }
}
class Vector2 {
  float x, y;
  Vector2(float x, float y) {
    this.x = x;
    this.y = y;
  }
  float mag() {
    return dist(0,0,x,y);
  }
  Vector2 norm() {
    return new Vector2(x/mag(), y/mag());
  }
}
