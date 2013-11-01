function iriex



 [filename, pathname]=  uigetfile('*.xlsx');
 
    dataStructex = importdata([pathname,filename]);
    
    
    
    thresh = dataStructex.data(:,11);
    thresh(isnan(thresh))=0;
    thresh2 = thresh>.7;
    thresh3 = thresh(thresh2);
    
    theindex = 1:length(thresh);
    
    vals = dataStructex.data(:,9);
    
    tracks = dataStructex.data(:,2);
   
    
    trackinds = find(diff(tracks));
    results = zeros(length(trackinds),1);
    
    vals2 = vals([trackinds ; length(vals)] );
    
    
    dataout = dataStructex.data;
    
    trackinds(end+1)=length(thresh2);
    trackinds=[1; trackinds];
    
    for ctr = 1:sum(diff(tracks))
       
        inds = trackinds(ctr):trackinds(ctr+1);
        
        results(ctr) =   vals2(ctr)/...
        sum(thresh2(inds).*thresh(inds));
        

    dataout(trackinds(ctr+1),15)= results(ctr);
        
    end
    
    xlswrite([filename(1:end-4) 'OUT'],dataout)
    
    disp(results)
    