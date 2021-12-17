% Example taken from: https://www.mathworks.com/help/parallel-computing/gpuarray.html
% To transfer data from the CPU to the GPU, use the gpuArray function:
X = [1,2,3];
% Transfer X to the GPU:
G = gpuArray(X);
% Check that the data is on the GPU:
isgpuarray(G)
% Calculate the element-wise square of the array G:
GSq = G.^2;
% Transfer the result GSq back to the CPU:
XSq = gather(GSq)

%% NOTE - To operate with gpuArray objects, use any gpuArray-enabled MATLAB function. MATLAB automatically runs calculations on the GPU. 

%% You can create data directly on the GPU directly by using some MATLAB functions and specifying the option "gpuArray":
G = rand(1,3,"gpuArray")

%% Use MATLAB Functions with the GPU:
% use gpuArray-enabled MATLAB functions to operate with gpuArray objects:
% check the properties of your GPU using the gpuDevice function:
gpuDevice

% Create a row vector that repeats values from -15 to 15. To transfer it to the GPU and create a gpuArray object, use the gpuArray function:
X = [-15:15 0 -15:15 0 -15:15];
gpuX = gpuArray(X);
whos gpuX

% Operate using GPU-enabled functions:
gpuE = expm(diag(gpuX,-1)) * expm(diag(gpuX,1));
gpuM = mod(round(abs(gpuE)),2);
gpuF = gpuM + fliplr(gpuM);
% Plot the results:
imagesc(gpuF);
colormap(flip(gray));

% If you need to transfer the data back from the GPU, use gather. NOTE - Transferring data back to the CPU can be costly, and is generally not necessary unless you need to use your result with functions that do not support gpuArray.

result = gather(gpuF);
whos result

