function iriex2

%min_segment_length = 3.5;%3.5
%max_theta = pi/2;



min_segment_length = 5;%3.5
max_theta = pi/2;


[filename, pathname]=  uigetfile('*.xlsx');
 
    dataStructex = importdata([pathname,filename]);
    
    
   % pos = myRwalk;
    
       tracks = dataStructex.data(:,2);
       %tracks=ones(length(pos),1);
       
       trackinds = find(diff(tracks));
       
    
    xy = dataStructex.data(:,4:5);
    %xy=pos;
    dxy = diff(xy);
    
    dxy2 = dxy(~logical(diff(tracks)),:);
    
    xy2 = cumsum(dxy2,1);
    
    nomove =  (logical(sum(dxy~=0,2)));
    %nomove = repmat(nomove,[1,2])
    
    dirs = atan2(dxy(:,1),dxy(:,2));
    dirs2= dirs(find(diff(tracks)));
    
    lengths = sum(dxy.^2,2).^.5;
    lengths2 = lengths(find(diff(tracks))-1);
    
    two_step_speed = (sum((dxy(:,1:end-1)+dxy(:,2:end)).^2,2).^.5)/2;%per 2 steps
    
    maxspeed = max(lengths(nomove));
    minspeed = min(lengths(nomove));
    
    
    
    trackinds = trackinds;
    
        trackinds(end+1)=length(tracks)-1;
    trackinds=[0; trackinds];
    
    figure;
    title(filename);
    hold on
           dirs = mod(dirs+pi,2*pi);
    lasttrackend = [0,0];
           stepStructs=[];
           
           
           
           %separate tracks!!!!!!!
           
           
           
           
        for ctr = 1:sum(diff(tracks))%for each track
       
        inds = trackinds(ctr)+1:trackinds(ctr+1);
      
        
        %remove steps w/o movement
       inds(lengths( inds)==0)=[];
        
        
        %trackStruct{ctr} = xy(inds,:);
        trackRuns{ctr,1} = [];
        
    
        
 
        
       ctr2 = 0;

       while ctr2<length(inds)-1
    
    
           ctr2=1+ctr2;
           ctr3 = ctr2+1;
           %1st step
           dTheta  =  pi - abs(abs(dirs(inds(ctr2)) - dirs(inds(ctr3))) - pi);
   
    
           
           
            while abs(dTheta) <= max_theta &&  ctr3<length(inds)-1%%%AND NOT B/W SECTIONS
                
            ctr3=1+ctr3;
            
            
            %delta direction b/w init and current vector
            
            dTheta  =  pi - abs(abs(dirs(inds(ctr2)) - dirs(inds(ctr3))) - pi);
            
        %conditions - angle size and  nonzero movement
           end
           
           
           
          segmentLength =...
              ((xy(inds(ctr2),1)-xy(inds(ctr3-1),1))^2 + (xy(inds(ctr2),2)-xy(inds(ctr3-1),2))^2)^.5;
           
           
          if segmentLength>min_segment_length 
           stepStructs(end+1,:) = [ctr inds(ctr2) inds(ctr3) segmentLength];
           %stepCtr =  stepCtr+1;
       end
            
       end
      
       
       
       if(length(stepStructs)~=0)
       
       %got all potential runs from one track - take out in order of length
       
      
       
       [~, stepStructsSortedIs] = sort(stepStructs(:,4),'descend');
       stepStructs = stepStructs(stepStructsSortedIs,:);
       stepStructsTmp=[];
       while size(stepStructs,1)~=0
           
           stepStructsTmp(end+1,:) = stepStructs(1,:);
           
           %plot([xy(stepStructs(1,2),1) xy(stepStructs(1,3),1)],[xy(stepStructs(1,2),2) xy(stepStructs(1,3),2)],'r','LineWidth',2.0);
           plot([xy(stepStructs(1,2):stepStructs(1,3),1)],[xy(stepStructs(1,2):stepStructs(1,3),2)],'r','LineWidth',2.0);
           
           Sctr = 1;
           while Sctr<=size(stepStructs,1)
               
               if isempty( intersect(...
                            stepStructs(Sctr,2):stepStructs(Sctr,3),...
                            stepStructsTmp(end,2):stepStructsTmp(end,3)))%runs intersect
                   Sctr = Sctr+1;
               else
                stepStructs(Sctr,:)=[];
               end
           end
           
           
       end
       
       
       end
       
       
       
       disp('end');
        
      %  dirs(inds(2:end))
        
    %    dxy
        
        
       
%         trackTmp = xy(inds,:)+   repmat(lasttrackend-xy(inds(2),:),[length(inds),1]);
%         
%       %  plot(xy(inds(1:2),1),xy(inds(1:2),2),'r');
%       
%       plot([lasttrackend(1);trackTmp(1,1)],[lasttrackend(2);trackTmp(1,2)],'r');
%         plot(trackTmp(2:end,1),trackTmp(2:end,2));
%        
%         lasttrackend = trackTmp(end,:);
%   %  dataout(trackinds(ctr+1),15)= results(ctr);
%         
    end
    
    
    
    
    
    
    
       
    xlswrite([filename(1:end-4) 'OUT'],dataout)
    
    disp(results)
    
    
    function pos = myRwalk
   
        pos = [0 0];
        
        for stepctr = 1:10000
        
        %xy = randi(3,1,2)-2;
        
        xy=rand(1,2)*2-1;
        xy=xy/norm(xy);
        
        pos(end+1,:) = pos(end,:) + xy;
        
        end

        figure;
       plot(pos(:,1),pos(:,2));
       hold on
        