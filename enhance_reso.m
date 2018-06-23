function RGB2 = enhance_reso(arg,size,fname)
a = imread(arg);
RGB = a;
GS = a;
if ndims(a) == 1 
    %reading grey image
    gsImage = imresize(GS, size, 'bicubic');
    %fltr=fspecial('average',3);
    %rgbImage = imfilter(RGB2,fltr);
    v = [5 5];
    MF = medfilt2(gsImage, v);

    % Iblur1 = imgaussfilt(I,2);
    v=2;
    MF =  imgaussfilt(MF, v);

    MF =  imadjust(MF);


    noiseImage = (gsImage == 0 | gsImage == 255);
    % Get rid of the noise in the red by replacing with median.
    noiseFreeGS = gsImage;
    noiseFreeGS(noiseImage) = MF(noiseImage);
    
    RGB2 = noiseFreeGS;
    imwrite(RGB2,fname);
end
if ndims(a) == 3 || ndims(a) == 2
    rgbImage = imresize(RGB, size, 'bicubic');
    %fltr=fspecial('average',3);
    %rgbImage = imfilter(RGB2,fltr);
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);
    v = [5 5];
    redMF = medfilt2(redChannel, v);
    greenMF = medfilt2(greenChannel, v);
    blueMF = medfilt2(blueChannel, v);


    % Iblur1 = imgaussfilt(I,2);
    v=1;
    redMF =  imgaussfilt(redMF, v);
    greenMF =  imgaussfilt(greenMF, v);
    blueMF =  imgaussfilt(blueMF, v);


    redMF =  imadjust(redMF);
    greenMF =  imadjust(greenMF);
    blueMF =  imadjust(blueMF);


    noiseImage = (redChannel == 0 | redChannel == 255);
    % Get rid of the noise in the red by replacing with median.
    noiseFreeRed = redChannel;
    noiseFreeRed(noiseImage) = redMF(noiseImage);
    % Find the noise in the green.
    noiseImage = (greenChannel == 0 | greenChannel == 255);
    % Get rid of the noise in the green by replacing with median.
    noiseFreeGreen = greenChannel;
    noiseFreeGreen(noiseImage) = greenMF(noiseImage);
    % Find the noise in the blue.
    noiseImage = (blueChannel == 0 | blueChannel == 255);
    % Get rid of the noise in the blue by replacing with median.
    noiseFreeBlue = blueChannel;
    noiseFreeBlue(noiseImage) = blueMF(noiseImage);
    % Reconstruct the noise free RGB image
    RGB2 = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);
    %fltr=fspecial('laplacian',1);
    %RGB2 = imfilter(RGB2,fltr);
    imwrite(RGB2,fname);
end

