# Codes in Nature: Sound Lens
### CRCP 2020 Showcase

#### How to Use the Instrument:

1) Voice Recording
  -- Open the program titled “Voice Recorder.”
  -- First, make sure you are wearing headphones so that there will not be any feedback. Make sure the supercollider server is running. 
You may boot the server either by clicking Command+B or run the s.boot line.
  -- Then, run line by line starting with the one second buffer line. We will first run the SynthDef section, and then enable recording for looping the sound recording and even rewriting the current recording. 
  -- To stop the sound, users can choose the l.free or r.free section to stop the recording. 
  -- Another option for a better user interaction is to choose the s.makeWindow. There will be a GUI like a control panel for the user to boot the server, record the sound or even manipulate the volume. After the recording is done, it will be saved in the default super collider folder on the computer. 	
2) Running the Instrument
  -- Open CodesInNature_Processing and CodesInNature_SC in their respective programs.
  -- In supercollider, run the line “NetAddr.localAddr.” It will output a string of numbers in the console. Copy that string of numbers, and paste it into processing where it says: supercollider = new NetAddress("127.0.0.1",57120 );
  --  Now run the supercollider program, then run the processing. The instrument will begin playing!
3)If you want to add your own recordings:
  -- Find the file that the voice recording software created, and copy the file name.
  -- Go into CodesInNature_SC, and paste the file name where it says:
m = MP3("/Users/songName.mp3");
  -- Now run the instrument as normal, and you will hear your recording as it is altered by the cellular automata.


#### Artists' Statement:

As we read in  Ghosts & Monsters, we humans often only realize the importance of and connection between things through extinction and loss. Thus, we really need to pay attention to the connections between things in nature. In this project, we are going to create an instrument that shows how natural, independent systems can affect even human understanding. The purpose of this is to provoke audiences’ thoughts on the relationship between humans and nature. We will do this through a ‘cellular automata,’ created in Processing, which simulates interactions between cells of four elements: water, fire, earth and air. These cells will alter each other to create different visual effects and change which element is in majority. In this we want to show the ecological principle that the four kinds of substances have a relationship of generation and restriction. (This is also referring to the Chinese Wu-xing theory.) For example, if the ‘water’ cells have greater amounts than ‘fire’ cells, the ‘fire’ cells will be diminishing. In SuperCollider, we are creating four different sounds modulations that are triggered by the movements of the four elements in Processing. So that when the visual changes in Processing, the sound would also change. These modulations will affect a voice recording created by the user, altering their speech based on the underlying independent natural systems. This will allow both composition and live performance, with the cellular automata altering the vocals live. However, it could be used by anyone to modulate their speech or song. Our interface is designed to look like a cell phone or tablet, one reason is that it represents how we view nature more and more only through the lens of technology; the other reason is that it has a meaning of when our future generation see this with higher-tech devices, they could also see nature through the lens as we did today.
