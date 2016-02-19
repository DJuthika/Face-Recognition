
clear all;
close all;
clc;

picnumber=1;

if (exist('DATABASE.mat','file'))
    load DATABASE.mat;
end
while (1==1)
    choice=menu('Face Recognition',...
                'Generate Database',...
                'Calculate Recognition Rate',...
                'Recognize from Image',...
                'Capture from Camera',...
                'Display Image',...
                'Exit');
    if (choice ==1)
        if (~exist('DATABASE.mat','file'))
            [myDatabase,minmax] = gendata();        
        else
            pause(0.1);    
            choice2 = questdlg('Generating a new database will remove any previous trained database. Are you sure?', ...
                               'Warning...',...
                               'Yes', ...
                               'No','No');            
            switch choice2
                case 'Yes'
                    pause(0.1);
                    [myDatabase minmax] = gendata();        
                case 'No'
            end
        end        
    end
    if (choice == 2)
        if (~exist('myDatabase','var'))
            fprintf('Please generate database first!\n');
        else
            recognition_rate = testsys(myDatabase,minmax);                
        end                        
    end    
    if (choice == 3)
        if (~exist('myDatabase','var'))
            fprintf('Please generate database first!\n');
        else            
            pause(0.1);            
            [file_name file_path] = uigetfile ({'*.pgm';'*.jpg';'*.png'});
            if file_path ~= 0
                filename = [file_path,file_name];                
                facerec (filename,myDatabase,minmax);                        
            end
        end
    end
    if (choice == 4)
        
        vid = videoinput('winvideo', 1);
        preview(vid);
        choice=menu('Capture Frame',...
                    '   Capture   ',...
                    '   Train   ',...
                    'Display Set',...
                    '    Exit     ');
    I = [];
    
    if (choice == 1 || choice==2)
    
    if (choice==1)
        iters=1;
    else iters=10;
         picnumber=1;
    end
        
    for j=1:iters
    I = getsnapshot(vid);
    try
        I = rgb2gray(I);
    end
    
    faceDetector = vision.CascadeObjectDetector();

    bbox            = step(faceDetector, I);    
    
    videoOut = insertObjectAnnotation(I,'rectangle',bbox,'Face');
    
    if(j==iters)
    figure, imshow(videoOut), title('Detected face');
    end
    
    if(j==iters)
    closepreview(vid);
    end
    
    if(bbox(1) ~= 0)
    I=imcrop(I,[bbox(1) bbox(2) bbox(3) bbox(4)]);
 
    I = imresize(I,[112 92]);
            
            if (iters==1)
            filename = ['./captured/',num2str(picnumber),'.pgm'];
            else filename = ['./photoset/',num2str(picnumber),'.pgm'];
            end
            
            imwrite(I,filename);
            picnumber=picnumber+1;
                        pause(0.2);            
    
    else j = j-1;
    end
    end
    
    end
    
        if (choice == 3)
 
                for y=1:10
                subplot(2,5,y);
                selectphoto=['./photoset/',num2str(y),'.pgm'];
                img=imread(selectphoto,'pgm');
                imshow(img);
                end
               
        end
    
        if (choice == 4)
        closepreview(vid);
        return;
        end
    end
    if (choice == 5)
                  
            pause(0.1);            
            [file_name file_path] = uigetfile ({'*.pgm';'*.jpg';'*.png'});
            if file_path ~= 0
                showable = [file_path,file_name]; 
                imshow(showable);

        end
    end
    if (choice == 6)
        clear choice choice2
        return;
    end    
end