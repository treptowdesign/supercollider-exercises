(
var scale = Scale.major.degrees;
var baseFreq = 261.63; // Middle C
var piDigits = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3, 2, 3, 8, 4, 6, 2, 6, 4, 3, 3, 8, 3, 2, 7, 9, 5]; // First 32 digits of π
var frequencies;

frequencies = piDigits.collect { |digit|
    var degree = digit % scale.size; // Ensure the digit maps to a scale degree
    var note = baseFreq * (2 ** (scale[degree] / 12.0));
    note.midicps; // Convert MIDI note to frequency
};
)