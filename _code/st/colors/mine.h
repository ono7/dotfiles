static const char *colorname[] = {
  /* 8 normal colors */
  "#2A3441",  /* 0: black */
  "#C47B7B",  /* 1: red */
  "#7BA05B",  /* 2: green */
  "#D4B171",  /* 3: yellow */
  "#7B9FC4",  /* 4: blue */
  "#A67BC4",  /* 5: magenta */
  "#7BC4B5",  /* 6: cyan */
  "#D6CFC7",  /* 7: white */

  /* 8 bright colors */
  "#4A5563",  /* 8: bright black */
  "#E8A3A3",  /* 9: bright red */
  "#9BC278",  /* 10: bright green */
  "#F0D195",  /* 11: bright yellow */
  "#A3C7E8",  /* 12: bright blue */
  "#C7A3E8",  /* 13: bright magenta */
  "#A3E8D4",  /* 14: bright cyan */
  "#F2EDE7",  /* 15: bright white */

  [255] = 0,

  /* more colors can be added after 255 to use with DefaultXX */
  "#D6CFC7",  /* 256: default foreground colour */
  "#171F2C",  /* 257: default background colour */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor, reverse cursor
 */
unsigned int defaultfg = 256; /* foreground */
unsigned int defaultbg = 257; /* background */
unsigned int defaultcs = 256; /* cursor */
unsigned int defaultrcs = 8;  /* reverse cursor */
