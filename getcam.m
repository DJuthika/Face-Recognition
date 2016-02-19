function I = getcam()
vid = videoinput('winvideo', 1);
preview(vid);
choice=menu('Capture Frame',...
            '     Exit    ');
I = [];        
if (choice == 1)
    I = getsnapshot(vid);
    try
        I = rgb2gray(I);
    end
    
faceDetector = vision.CascadeObjectDetector();

bbox            = step(faceDetector, I);

videoOut = insertObjectAnnotation(I,'rectangle',bbox,'Face');
figure, imshow(videoOut), title('Detected face');

    I = I(8:231,68:251);
    I = imresize(I,[112 92]);
end
closepreview(vid);



