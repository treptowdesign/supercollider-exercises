// scopes/plots
s.plotTree;
s.scope;
s.meter;
FreqScope.new(250);

// Devices
ServerOptions.devices; // all devices
ServerOptions.inDevices; // input devices
ServerOptions.outDevices; // output devices
// Server.default.options.inDevice_("MacBook Pro Microphone");
Server.default.options.outDevice_("MacBook Pro Speakers");
Server.default.options.outDevice_("External Headphones");
Server.default.reboot;