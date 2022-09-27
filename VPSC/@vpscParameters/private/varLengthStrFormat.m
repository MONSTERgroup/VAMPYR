% baby function to make a variable length %f format spec with a str at the end

function [strFormat] = varLengthStrFormat(nNumber)

strFormat = repmat(['%g '],[1 nNumber]);
strFormat = [strFormat '%*s'];

