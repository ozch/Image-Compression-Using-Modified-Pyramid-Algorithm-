%[a b c] = size('abc (1).jpg');

%[out] = btcode('abc (1).jpg',a,b,'abco (1).jpg');
%[out,im] = pyramid('abc.jpg','abco (1).jpg');

[f p] = uigetfile({'*.jpg';'*.jpeg';'*.bmp';'*.png'});
handles.myImage = strcat(p, f);
[f2 p2] = uigetfile({'*.jpg';'*.jpeg';'*.bmp';'*.png'});
handles.myImage2 = strcat(p2, f2);
im1 = imread(handles.myImage2);
im2 = imread(handles.myImage);


% imshow('abc.png');
% title('Original');
% figure,
% imshow('abco.png');
% title('Resized Image');