function [Target_Signal,Location_Baackground] = NeuropilIdentify4(Potential_Location,numFrames,memMap,i,Soma_ID,Background,Diff_Projection)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
[x,~]=find(Soma_ID(:,i)>=1);
Location_neuron=Potential_Location(x,1:2);
Location_neuron_mean=mean(Location_neuron,1);

Distance=pdist2(Background(:,1:2),Location_neuron_mean);
Distance(:,2)=(1:1:size(Distance,1))';

Distance=sortrows(Distance,1);

Background_ID=Distance(1:size(Location_neuron,1),2);
Location_Baackground=Background(Background_ID,1:2);

Region=Diff_Projection.*0;
for i=1:size(Location_Baackground,1)
    Region(Location_Baackground(i,1),Location_Baackground(i,2))=1;
end

Target_Signal=[];Target_Signal=gpuArray(Target_Signal);
h=waitbar(0,'please wait');
for j=1:numFrames
    data=gpuArray(memMap.Data.Denoise(:,:,j));
    target=Region.*data;
    target=double(target);target=target(:);
    [Indices_nonzero,~]=find(target(:,1)>0);
    if ~isempty(Indices_nonzero)
        target=target(Indices_nonzero,1);
        Target_Signal(j,1)=mean(target);
        Target_Signal(j,2)=std(target);
    end
    if isempty(Indices_nonzero)
        Target_Signal(j,1)=Target_Signal(j-1,1);
        Target_Signal(j,2)=Target_Signal(j-1,2);
    end
    str=['信号提取……',num2str(j/numFrames*100),'%'];
    waitbar(j/numFrames,h,str);
end
delete(h);

end