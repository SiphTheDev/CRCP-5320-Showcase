

//Code 1




//We’ll put our SuperCollider Code here, so we can all work on it.

//please use headphone/earphones!


ServerOptions.devices;

(s.options.device ="";
s.options.numOutputBusChannels = 2;
s.options.numInputBusChannels = 2;
s.reboot;
)

(
SynthDef.new(\mic, {
	arg in = 0, out = 0, amp=1;
	var sig;
	sig = SoundIn.ar(in!2)*amp;
	Out.ar(out, sig);
}).add;

SynthDef.new(\delay, {
	arg in=0, out = 0, mix = (-0.8), decay = 3, amp = 1, delHz = 0.85, delMin = 0.1, delMax = 0.6;
	var sig, delay;
	sig = In.ar(in, 2);
	delay = CombL.ar(
		sig,
		0.6,
		SinOsc.kr([delHz, delHz*0.9]).exprange(delMin,delMax),
		decay
	);
	sig= XFade2.ar(sig, delay, mix)*amp;
	Out.ar(out, sig);
}).add;
)

~delBus = Bus.audio(s, 2);

(
~micGrp = Group.new;
~delGrp = Group.after(~micGrp);
~micSynth = Synth(\mic, [\in, 0, \out, ~delBus], ~micGrp);
~delSynth = Synth(\delay, [\in, ~delBus, \out, 0], ~delGrp);
)

s.makeWindow;
s.meter;
s.record;
s.stopRecording;


s.freeAll;



Code 2

--------------
Watch the demo video here
https://drive.google.com/file/d/1mivnWMF2ACzK_VinCmKQ-ds1tJG2CnWz/view

-------------



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

s.makeWindow;
s.meter;
s.record;
s.stopRecording;


(
l.free;
r.free;
)


)

