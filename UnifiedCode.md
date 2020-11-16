#Combined codes
 >Changes are marked in blockquotes, including notes
#Processing:

//Processing Code

//Angelina, Sisi, and Thomas
//Saturday Nov 14, 2020

//GameOfLife Base-Code by Joan Soler-Adillon (https://processing.org/examples/gameoflife.html)

//TODO: In adding sound, the thing to look at is the 'state' of each cell in the cells array. Basically, you can do if cells[x][y] = 0, then play this sound or modulate the sound in this way.
        //There's 4 states: 0 (air), 1 (water), 2 (earth), and 3 (fire). 
        //I also recommend to  mess around with maxN & minN to see different patterns.
            //A few interesting combinations:
            /*
              max4 min2 - this one seems to make natural-feeling if a bit bland patterns
              max3 min2 - creates a crazy labrinth, but the fires tend to all burn out very rapidly.
              max5 min1 - tends to very quickly reach a stagnant but interesting state. 
            */
>import oscP5.*;
>import netP5.*;


// Size of cells
int cellSize = 5;

//Size of cell area
int gridW = 640;
int gridH = 360;
int gridShift = 22; //1/2 the difference between gridW & canvas width

//Minimum and maximum number of neighbours to cause a change - adjust to try different patterns
int maxN = 3; //must always be larger than minN
int minN = 2;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Colors for active/inactive cells //TODO: Have 4 states. Adjust colors.
color earth = color(21, 122, 110); //earth/plants
color air = color(255, 252, 242); //air
color water = color(44, 54, 94); //water
color fire = color(235, 94, 40); //fire

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

<span style="color:purple">OscP5 osc; //tool used to send messages</span>.
<span style="color:purple">NetAddress supercollider; //adress of where to send messages</span>.


void setup() {
  size (760, 360);

  // Instantiate arrays //TODO, set to width of grid, not of full program.
  cells = new int[gridW+gridShift/cellSize][gridH/cellSize];
  cellsBuffer = new int[gridW+gridShift/cellSize][gridH/cellSize];

 
  <span style="color:purple">//Initialize osdc and supercollider</span>
  <span style="color:purple">osc = new OscP5(this , 12000);</span>
  <span style="color:purple">supercollider = new NetAddress();// ***The number here will vary on different laptops!!!! Run the “NetAddr.localAddr” in SC and it will show your address in the post window. For example, in my sc post window it shows 
</span>
  
  // This stroke will draw the background grid
  stroke(48);
  noSmooth();

  // Initialization of cells
  for (int x=gridShift; x<gridW/cellSize; x++) {
    for (int y=0; y<gridH/cellSize; y++) {
      float state = random (100);
      if (state > 75) {  //Adust to work with 4 states.
        state = 3; //fire
      } else if (state > 50) {
        state = 2; //earth
      } else if (state > 25) {
        state = 1; //water
      } else {
        state = 0; //air
      }
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  background(0); // Fill in black in case cells don't cover all the windows, and to simulate phone/tablet bars
}


void draw() {

  //Draw grid
  for (int x=gridShift; x<gridW/cellSize; x++) {
    for (int y=0; y<gridH/cellSize; y++) {
      if (cells[x][y]==3) {
        >OscMessage msg = new OscMessage("/firemsg");<
        >msg.add();<
        >osc.send(msg, supercollider);<
        fill(fire); // If alive 
      } else if (cells[x][y]==2) {
        >OscMessage msg = new OscMessage("/earthmsg");<
        >msg.add();<
        >osc.send(msg, supercollider);<
        fill(earth);
      } else if (cells[x][y]==1) {
        >OscMessage msg = new OscMessage("/watermsg");<
        >msg.add();<
        >osc.send(msg, supercollider);<
        fill(water);
      } else {
        >OscMessage msg = new OscMessage("/airmsg");<
        >msg.add();<
        >osc.send(msg, supercollider);<
         fill(air); // If air

      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }
}

void iteration() { // When the clock ticks //TP - this is swapping between the two arrays for more efficient memory usage.
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=gridShift; x<gridW/cellSize; x++) {
    for (int y=0; y<gridH/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell: 
  for (int x=gridShift; x<gridW/cellSize; x++) {
    for (int y=0; y<gridH/cellSize; y++) {
      // And visit all the neighbours of each cell
      int fires = 0; // We'll count the neighbouring elements
      int earths = 0;
      int waters = 0;
      int airs = 0;

      for (int xx=x-1; xx<=x+1; xx++) {
        for (int yy=y-1; yy<=y+1; yy++) {  
          if (((xx>=gridShift)&&(xx<gridW/cellSize))&&((yy>=0)&&(yy<gridH/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]==3) {
                fires ++; // Check elemental neighbours and count them
              } else if ((cellsBuffer[xx][yy]==2)) {
                earths ++;
              } else if ((cellsBuffer[xx][yy]==1)) {
                waters ++;
              } else {
                airs ++;
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      int neighbours = 0;
      // We've checked the neigbours: apply rules!
      if (cellsBuffer[x][y]== 3) { // The cell is fire: change it if necessary
        //Now check which neighbour, if any, is in majority, and act accordingly.
        neighbours = waters+earths+airs;
        if (neighbours < minN || neighbours > maxN) {
          if (waters > earths && waters > airs) {
            cells[x][y] = 1;
          } else if (earths > waters && earths > airs) {
            cells[x][y] = 2;
          } else if (airs > waters && airs > earths) {
            cells[x][y] = 0;
          }
        }
      } 
      if (cellsBuffer[x][y]== 2) { // The cell is earth: change it if necessary
        //Now check which neighbour, if any, is in majority, and act accordingly.
        neighbours = waters+fires+airs;
        if (neighbours < minN || neighbours > maxN) {
          if (waters > fires && waters > airs) {
            cells[x][y] = 1;
          } else if (fires > waters && fires > airs) {
            cells[x][y] = 3;
          } else if (airs > waters && airs > fires) {
            cells[x][y] = 0;
          }
        }
      } 
      if (cellsBuffer[x][y]== 1) { // The cell is water: change it if necessary
        //Now check which neighbour, if any, is in majority, and act accordingly.
        neighbours = fires+earths+airs;
        if (neighbours < minN || neighbours > maxN) {
          if (fires > earths && fires > airs) {
            cells[x][y] = 3;
          } else if (earths > fires && earths > airs) {
            cells[x][y] = 2;
          } else if (airs > fires && airs > earths) {
            cells[x][y] = 0;
          }
        }
      } 
      if (cellsBuffer[x][y]== 0) { // The cell is air: change it if necessary
        //Now check which neighbour, if any, is in majority, and act accordingly.
        neighbours = waters+earths+fires;
        if (neighbours < minN || neighbours > maxN) {
          if (waters > earths && waters > fires) {
            cells[x][y] = 1;
          } else if (earths > waters && earths > fires) {
            cells[x][y] = 2;
          } else if (fires > waters && fires > earths) {
            cells[x][y] = 0;
          }
        }
      } 
    } // End of y loop
  } // End of x loop
} // End of function










SuperCollider:


//use headphones
s.boot;
b = Buffer.alloc(s, s.sampleRate*1); //allocated one-second buffer
(
SynthDef.new(\rec, {
arg buf=0, in=0, enable=1;
var sig;
sig = SoundIn.ar(in);
RecordBuf.ar(sig, buf, run:enable);
}).add;
SynthDef.new(\loop, {
arg buf=0;
var sig;
sig = PlayBuf.ar(1!2, buf, loop:1);
Out.ar(0, sig);
}).add;
)


(
r = Synth(\rec, [\buf, b]);
l = Synth(\loop, [\buf, b]);
)
r.set(\enable, 0); //stop recording, loop continues
r.set(\enable, 1); //start recording, overwrite loop
(
l.free;
r.free;
)


>//*** Must boot this line FIRST!! And it will show your laptop’s address in post window. Remember to change the address in Processing to your own address
>NetAddr.localAddr


>//The Synth(***) should be the recorded voice but it doesn’t work on my laptop so I guess we need to work it together
>(
>OSCdef('firesound',{
>	arg msg;
>	Synth(***,[pitch:msg[1]]*400 + 60) },"/firemsg");
>OSCdef('watersound',{
>	arg msg;
>	Synth(***,[frequency:msg[2]]) },"/watermsg");
>OSCdef('earthsound',{
>	arg msg;
>	Synth(***),[] },"/earthmsg");
>OSCdef('airsound',{
>	arg msg;
>	Synth(***),[]  },"/airmsg");
>)



