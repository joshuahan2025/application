function plot_differnce_map_wrapper(difference_map,outdir,iFrame,radius,show_save_everything_flag)
% wrapper function for plotting out the network comparison details


if(show_save_everything_flag==1)    
    h3=figure(3);
    imagesc_nan_neg(difference_map.distance_map_1_2,radius*1);axis equal;axis off;
    flip_colormap;
    title('Distance Measure 1->2');
    saveas(h3,[outdir,filesep,'Dis12_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'Dis12_frame_',num2str(iFrame),'.fig']);


h3=figure(3);
imagesc_nan_neg(difference_map.distance_map_2_1,radius*1);axis equal;axis off;
flip_colormap;
title('Distance Measure 2->1');

    saveas(h3,[outdir,filesep,'Dis21_frame_',num2str(iFrame),'.tif']);  
    saveas(h3,[outdir,filesep,'Dis21_frame_',num2str(iFrame),'.fig']);  


h3=figure(3);
imagesc_nan_neg(difference_map.angle_map_2_1,-pi/(3));axis equal;axis off;
flip_colormap;
title('Orientaion Measure 1->2');

    saveas(h3,[outdir,filesep,'Ang12_frame_',num2str(iFrame),'.tif']); 
    saveas(h3,[outdir,filesep,'Ang12_frame_',num2str(iFrame),'.fig']); 

h3=figure(3);
imagesc_nan_neg(difference_map.angle_map_1_2,-pi/(3));axis equal;axis off;
flip_colormap;
title('Orientaion Measure 2->1');

    saveas(h3,[outdir,filesep,'Ang21_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'Ang21_frame_',num2str(iFrame),'.fig']);
end


show_angle12 = difference_map.angle_map_1_2;
show_angle12(isnan(show_angle12)) = 30;
show_angle21 = difference_map.angle_map_2_1;
show_angle21(isnan(show_angle21)) = 30;
show_dis12 = difference_map.distance_map_1_2;
show_dis12(isnan(show_dis12)) = radius*1;
show_dis21 = difference_map.distance_map_2_1;
show_dis21(isnan(show_dis21)) = radius*1;

if(show_save_everything_flag==1)
    h3=figure(3);    
    imagesc(show_angle12+show_angle21+show_dis12+show_dis21);axis equal;axis off;
    flip_colormap;
    title('Sum of all Measures');
    saveas(h3,[outdir,filesep,'AngDisSum_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'AngDisSum_frame_',num2str(iFrame),'.fig']);
end


% display the local supported distance and angle different matrix
if(show_save_everything_flag==1)
    h3=figure(3);
    imagesc_nan_neg(difference_map.score_maps_distance_1_2,0);axis equal;axis off;
    flip_colormap;
    title('Distance Measure 1->2 with Local Support');
    
    saveas(h3,[outdir,filesep,'LVDis12_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'LVDis12_frame_',num2str(iFrame),'.fig']);
    
    h3=figure(3);
    imagesc_nan_neg(difference_map.score_maps_distance_2_1,0);axis equal;axis off;
    title('Distance Measure 2->1 with Local Support');
    flip_colormap;
    saveas(h3,[outdir,filesep,'LVDis21_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'LVDis21_frame_',num2str(iFrame),'.fig']);
    
    h3=figure(3);
    imagesc_nan_neg(difference_map.score_maps_angle_1_2,0);axis equal;axis off;
    flip_colormap;
    title('Orientation Measure 1->2 with Local Support');
    saveas(h3,[outdir,filesep,'LVAng12_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'LVAng12_frame_',num2str(iFrame),'.fig']);
    
    h3=figure(3);
    imagesc_nan_neg(difference_map.score_maps_angle_2_1,0);axis equal;axis off;
    flip_colormap;
    title('Orientation Measure 2->1 with Local Support');
    saveas(h3,[outdir,filesep,'LVAng21_frame_',num2str(iFrame),'.tif']);
    saveas(h3,[outdir,filesep,'LVAng21_frame_',num2str(iFrame),'.fig']);
    
        
    h4=figure(4); imagesc_nan_neg(difference_map.score_maps_distance_2_1+difference_map.score_maps_distance_1_2,0);axis equal;axis off;
    flip_colormap;
    title('Distance Measure 1->2 + 2->1 with Local Support');
    saveas(h4,[outdir,filesep,'VIFMT_dis_frame_',num2str(iFrame),'.tif']);
    saveas(h4,[outdir,filesep,'VIFMT_dis_frame_',num2str(iFrame),'.fig']);
       
    
    h5=figure(5); imagesc_nan_neg(abs(difference_map.score_maps_angle_2_1/2)+abs(difference_map.score_maps_angle_1_2/2),0);axis equal;axis off;
    flip_colormap;
    title('Orientation Measure 1->2 + 2->1 with Local Support');
    saveas(h5,[outdir,filesep,'VIFMT_ang_frame_',num2str(iFrame),'.tif']);
    saveas(h5,[outdir,filesep,'VIFMT_ang_frame_',num2str(iFrame),'.fig']);
end



if(show_save_everything_flag==1)
    % similarity_scoremap(similarity_scoremap<0.2)=0.2;
    h6=figure(6); imagesc_nan_neg(difference_map.similarity_scoremap,0);
    axis equal;axis off;
    title(['Similarity Score for frame ',num2str(iFrame)]);
    saveas(h6,[outdir,filesep,'VIFMT_sm_score_frame_',num2str(iFrame),'.tif']);
    saveas(h6,[outdir,filesep,'VIFMT_sm_score_frame_',num2str(iFrame),'.fig']);
    
    % similarity_scoremap(similarity_scoremap<0.2)=0.2;
    h6=figure(7); imagesc_nan_neg(difference_map.similarity_scoremap_1to2,0);
    axis equal;axis off;
    title(['Similarity Score 1to2 for frame ',num2str(iFrame)]);
    saveas(h6,[outdir,filesep,'VIFMT_1to2_sm_score_frame_',num2str(iFrame),'.tif']);
    saveas(h6,[outdir,filesep,'VIFMT_1to2_sm_score_frame_',num2str(iFrame),'.fig']);
    
    % similarity_scoremap(similarity_scoremap<0.2)=0.2;
    h6=figure(8); imagesc_nan_neg(difference_map.similarity_scoremap_2to1,0);
    axis equal;axis off;
    title(['Similarity Score 2to1 for frame ',num2str(iFrame)]);
    saveas(h6,[outdir,filesep,'VIFMT_2to1_sm_score_frame_',num2str(iFrame),'.tif']);
    saveas(h6,[outdir,filesep,'VIFMT_2to1_sm_score_frame_',num2str(iFrame),'.fig']);
end
