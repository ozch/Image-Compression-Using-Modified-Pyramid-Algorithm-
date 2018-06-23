function [out,im] = pyramid (infile,outfile)

%frequency response of the low pass can be changed by the ver_freq variable

if (exist(infile)==2)
   a = imread(infile);
   figure('Name','Input image');
   imshow(a);
else
   warndlg('The file does not exist.',' Warning ');
   im=[];
   out=[];
   return
end


% The low-pass filter ---------------

% Gaussian Low Pass Filter ----------

x=[-16:1:16];
y=[-16:1:16];

dimx=size(x,2); %33 length of x
dimy=size(y,2); %33 length of y

ver_freq=2.3;

filtro=zeros(dimx,dimy); % filtr structure for dimx X dimy containg zero as each element

%creating low pass filter
for ii=1:dimx
    for jj=1:dimy
        esponente=exp(-(x(ii)^2+y(jj)^2)/(ver_freq));
        filtro(ii,jj)=esponente;
    end
end


% normalization
%dividing the whole filter with the sum of all filtro array to normalize
%the filter
filtro=filtro/sum(sum(filtro)); 
%End of Creating Gaussiang Filter-------------------

% if the image array is grayscale meaning depth == 1
if ndims(a) == 1     
    dvalue = double(a);
    dx     = size(dvalue,1);%number of pixels in x-axis
    dy     = size(dvalue,2);%number of pixels in y-axis
    dmin   = min(dx,dy); %which number is minimum
    
    red_p  = floor(log2(dmin));%log of dmin and cutting off
    red    = min(red_p,1);

    im=cell(red+1,1);

    % Image compression
    im{1}=dvalue;

         % low-pass filter the image
         filtered        = conv2d(dvalue,filtro,'same');
         % downsampling the image
         downsampled = dyaddown(filtered,1,'m');
         % save image
         im{ii+1}        = downsampled;
         % next step
         dvalue          = downsampled;         
    
    % Image reconstruction
         % upsampling the image
         upsampled = dyadup(dvalue,0,'m');
         % low-pass filter the image (there is a scaling factor)
         filtered        = 4*conv2d(upsampled,filtro,'same');
         % next step
         dvalue          = filtered;         

    
    
    
    
    if isa(a,'uint8')
        figure('Name','Reconstrunction');
        imshow(uint8(dvalue));
        pause(0.6);
        out=uint8(dvalue);     
    end
    
    if isa(a,'uint16')
        figure('Name','Reconstrunction');
        imshow(uint16(dvalue));
        pause(0.6);
        out=uint16(dvalue);
    end
    
    if isa(a,'double')
        figure('Name','Reconstrunction');
        imshow((dvalue));
        pause(0.6);
        out=uint32(dvalue);
   end
    
    imwrite(out, outfile);
    return;    
end

%------------------------------------------------------
% if the image array is color RGB meaning depth == 3 (Red,Green,Blue)
if ndims(a) == 3 
    dvalue = double(a);
    dx     = size(dvalue,1);
    dy     = size(dvalue,2);
    dmin   = min(dx,dy);
    
    red_p  = floor(log2(dmin));
    red    = min(red_p,1);

    im=cell(red+1,1);

    % Image compression
    im{1}=dvalue;

         % low-pass filter the image
         filtered_r        = conv2d(dvalue(:,:,1),filtro,'same');
         filtered_g        = conv2d(dvalue(:,:,2),filtro,'same');
         filtered_b        = conv2d(dvalue(:,:,3),filtro,'same');
         % downsampling the image
         downsampled_r = dyaddown(filtered_r,1,'m');
         downsampled_g = dyaddown(filtered_g,1,'m');
         downsampled_b = dyaddown(filtered_b,1,'m');
         % save image
         clear downsampled;
         downsampled(:,:,1)=downsampled_r;
         downsampled(:,:,2)=downsampled_g;
         downsampled(:,:,3)=downsampled_b;
         im{ii+1}        = downsampled;
         % next step
         dvalue          = downsampled;         

    imwrite(dvalue, 'compress.jpg');

    
    % Image reconstruction
 
         % upsampling the image
         upsampled_r = dyadup(dvalue(:,:,1),0,'m');
         upsampled_g = dyadup(dvalue(:,:,2),0,'m');
         upsampled_b = dyadup(dvalue(:,:,3),0,'m');
         % low-pass filter the image (there is a scaling factor)
         filtered_r        = 4*conv2d(upsampled_r,filtro,'same');
         filtered_g        = 4*conv2d(upsampled_g,filtro,'same');
         filtered_b        = 4*conv2d(upsampled_b,filtro,'same');
         % next step
         clear dvalue;
         dvalue(:,:,1)          = filtered_r;
         dvalue(:,:,2)          = filtered_g;
         dvalue(:,:,3)          = filtered_b;             
    
    if isa(a,'uint8')
        figure('Name','Reconstrunction');
        imshow(uint8(dvalue));
        pause(0.6);
        out=uint8(dvalue);
    end
    
    if isa(a,'uint16')
        figure('Name','Reconstrunction');
        imshow(uint16(dvalue));
        pause(0.6);
        out=uint16(dvalue);
    end
    
    if isa(a,'double')
        figure('Name','Reconstrunction');
        imshow((dvalue));
        pause(0.6);
        out=uint32(dvalue);
    end
    imwrite(out, outfile);
    return;    
    
end



