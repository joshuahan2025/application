function speed(hObject)

handles=guidata(hObject);


handles=guidata(hObject);


start=round((handles.postpro.analfirstimg- handles.jobvalues.firstimage)/handles.jobvalues.increment)+1
if start < 1
    start = 1;
end

stop = floor((handles.postpro.anallastimg - handles.jobvalues.firstimage)/handles.jobvalues.increment+0.00001)+1 

if stop > handles.jobvalues.lastimage
    stop = handles.jobvalues.lastimage;
end

saveallpath=handles.postpro.saveallpath;


bins=[0:1:60];

% [numrows,numcols]=size(handles.MPM);

%dist=zeros(numrows,1);


numberPics = stop-start+1;


    
whatcells=[];

if ~isempty(handles.selectedcells)
    whatcells = zeros(size(handles.selectedcells,1));
    dist = zeros(size(handles.selectedcells,1));
    
else
    whatcells = zeros(size(handles.MPM,1),2);
    dist = zeros(size(handles.MPM,1),2);
    
end

    
for pic=start:(stop-1)

    
    
    if ~isempty(handles.selectedcells) 
        whatcells = handles.selectedcells;
    else  
        whatcells = [1:length(handles.MPM(:,(2*pic-1)))]' ;
    end




        
        vec=handles.MPM( whatcells,(2*pic-1):(2*pic+2));
        [zerRows,cols]=find(vec==0);
        zerRows=unique(zerRows);
        vec(zerRows,:)=0;
        
        numbercells(pic,1) = (length(whatcells)-length(zerRows));
        dist(:,pic) = sqrt((vec(:,1)-vec(:,3)).^2 + (vec(:,2)-vec(:,4)).^2);
        avardist(pic,1) = sum(dist(1:length(whatcells),pic))/(length(whatcells)-length(zerRows));
        
        realdist = dist(find(dist(:,pic)),pic);
        speedvar(pic) = var(realdist);
         
        velHist(:,pic) = hist(realdist,bins)';
        velHist(:,pic) = velHist(:,pic)./(length(whatcells)-length(zerRows));
        
        
end
       
    
        h_fig=figure
        surf(velHist)
        hgsave(h_fig,[saveallpath filesep '3dSpeedHistBar.fig']);
		print(h_fig, [saveallpath filesep '3dSpeedHistBar.eps'],'-depsc2','-tiff');
		print(h_fig, [saveallpath filesep '3dSpeedHistBar.tif'],'-dtiff');
		
       
        h_fig=figure
        bar3(bins,velHist)
		hgsave(h_fig,[saveallpath filesep '3dSpeedHistBar.fig']);
		print(h_fig, [saveallpath filesep '3dSpeedHistBar.eps'],'-depsc2','-tiff');
		print(h_fig, [saveallpath filesep '3dSpeedHistBar.tif'],'-dtiff');
		
        
        
        
		h_fig=figure,plot(numbercells),title('number of cells')
		xlabel('Frames')
		ylabel('# cells')
		ymax=max(numbercells);
		axis([start stop 0 ymax])
		
		
		hgsave(h_fig,[saveallpath filesep 'numbercells.fig']);
		print(h_fig, [saveallpath filesep 'numbercells.eps'],'-depsc2','-tiff');
		print(h_fig, [saveallpath filesep 'numbercells.tif'],'-dtiff');
		
		
		h_fig=figure
		subplot(2,1,1); plot(avardist),title('avarage velocity of cells')
		xlabel('Frames')
		ylabel('distance per frame (in pixel)')
		ymax=max(avardist);
		axis([start stop 0 ymax])
		
	
		subplot(2,1,2); plot(speedvar),title('variance of avarage velocity of cells')
		xlabel('Frames')
		ylabel('variance')
		ymax=max(speedvar);
		axis([start stop 0 ymax])
		
        
		hgsave(h_fig,[saveallpath filesep 'velocity.fig']);
		print(h_fig, [saveallpath filesep 'velocity.eps'],'-depsc2','-tiff');
		print(h_fig, [saveallpath filesep 'velocity.tif'],'-dtiff');
		
    
   
    
   
cd(saveallpath)
save('distances', 'dist')
save('speedvariances','speedvar')
save('avardist','avardist')
    
   guidata(hObject, handles);