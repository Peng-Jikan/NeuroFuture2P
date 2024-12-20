function [Target_Signal] = SomaFlr6(Potential_Location,i,numFrames,RAWdata,Soma_ID)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[x,~]=find(Soma_ID(:,i)==1);
Location=Potential_Location(x,1:2);

Target_signal=[];Target_signal=gpuArray(Target_signal);
Pixel_label=[];Pixel_label=gpuArray(Pixel_label);
h=waitbar(0,'please wait');
for j=1:size(Location,1)
    data=gpuArray(RAWdata(Location(j,1):Location(j,1),Location(j,2):Location(j,2),1:numFrames));
    data = reshape(data, 1, numFrames);
    data(isnan(data))=0;
    Target_signal=[Target_signal double(data)'];
    if j==1
        Pixel_label=data;
    end
    if j>1
        Pixel_label=Pixel_label.*data;
    end
    str=['信号提取……',num2str(j/size(Location,1)*100),'%'];
    waitbar(j/size(Location,1),h,str);
end

Target_Signal=[];Target_Signal=gpuArray(Target_Signal);
Target_Signal(:,1) = mean(Target_signal, 2);
Target_Signal(:,2) = std(Target_signal, 0, 2);

[Position,~]=find(Pixel_label(:,1)==0);
if ~isempty(Position)
    for j=1:size(Position,1)
        target=Target_signal(Position(j,1),:);target=target(:);
        [Indices_nonzero,~]=find(target(:,1)>0);
        if ~isempty(Indices_nonzero)
            target=target(Indices_nonzero,1);
            Target_Signal(Position(j,1),1)=mean(target);
            Target_Signal(Position(j,1),2)=std(target);
        end
        if isempty(Indices_nonzero)
            Target_Signal(Position(j,1),1)=Target_Signal(Position(j,1)-1,1);
            Target_Signal(Position(j,1),2)=Target_Signal(Position(j,1)-1,2);
        end
    end
end
delete(h);
end