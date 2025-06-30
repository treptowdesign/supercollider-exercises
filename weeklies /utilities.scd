///////////////////////////////////////////////////////////////
// Utilities
///////////////////////////////////////////////////////////////
s.plotTree;
s.scope;
s.meter;
FreqScope.new(500);
ServerOptions.outDevices;
Server.default.options.outDevice_("External Headphones");
Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.reboot;

// Bussing
s.options.numAudioBusChannels; // total audio channels
s.options.numOutputBusChannels; // num outputs (2 = Left & Right)
s.options.numInputBusChannels; // num inputs (2 = Left & Right)
// 2x channels reserved for hardware input/output (speakers & mic)
// remaining channels safe for private bussing

// Memory Server Stuff
s.options.memSize;
s.options.memSize = 1048576; // 2.pow(20); (original 8192)
s.options.numWireBufs;
s.options.numWireBufs = 128; // (original 64)

s.boot;

//////////////////////////////////////////////////////
// Start Up
//////////////////////////////////////////////////////

( // Start Up for MacBook Speakers
Server.default.options.outDevice_("MacBook Pro Speakers");
s.options.memSize = 1048576;
s.options.numWireBufs = 128;
s.boot;
)

( // Start Up for Headphones
Server.default.options.outDevice_("External Headphones");
s.options.memSize = 1048576;
s.options.numWireBufs = 128;
s.boot;
)


//////////////////////////////////////////////////////
// End...
//////////////////////////////////////////////////////

