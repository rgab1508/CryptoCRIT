List<String> hexValues = [
  "0",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z"
];
List<String> words = [
  "zebra",
  "orange",
  "today",
  "tool",
  "face",
  "fake",
  "sand",
  "strong",
  "earth",
  "night",
  "air",
  "board",
  "court",
  "door",
  "empty",
  "floor",
  "ground",
  "height",
  "ice",
  "jar",
  "king",
  "libro",
  "middle",
  "net",
  "over",
  "pass",
  "quick",
  "root",
  "spike",
  "tip",
  "under",
  "voilet",
  "wall",
  "xerox",
  "yellow",
  "zip",
  "ace",
  "ball",
  "call",
  "dig",
  "energy",
  "feet",
  "game",
  "hall",
  "ill",
  "jump",
  "kite",
  "line",
  "match",
  "not",
  "open",
  "pan",
  "question",
  "rally",
  "serve",
  "tight",
  "until",
  "video",
  "white",
  "xerus",
  "yolk",
  "zoo"
];

String entropyToMnemonic(String entropy) {
  String mne = "";
  for (var i = 0; i < entropy.length; i++) {
    var ind = hexValues.indexOf(entropy[i]);
    if (ind == -1) {
      throw ArgumentError("Invalid Entropy.");
    }

    mne += words[ind] + " ";
  }

  return mne.trim();
}

String mnemonicToEntropy(String mne) {
  String entropy = "";
  var mneWords = mne.split(' ');
  for (var i = 0; i < mneWords.length; i++) {
    var ind = words.indexOf(mneWords[i]);
    if (ind == -1) {
      throw ArgumentError("Invalid Mnemonics.");
    }

    entropy += hexValues[ind];
  }

  return entropy.trim();
}
