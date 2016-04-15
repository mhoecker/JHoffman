%Set number of random data points
Ndata=16;
%make random locations for "cores"
xyz=2*rand(3,Ndata)-1	;
xyz=xyz./sqrt(sum(xyz.*xyz,1));
%Core location latitude
lat=(180/pi)*asin(-xyz(3,:));
%Core location longitude
lon=(180/pi)*atan2(xyz(1,:),xyz(2,:));
%Value at eat sample location
dat=rand(Ndata,1);
%Plot the location of the points
subplot(2,1,1)
plot(lon,lat,"o;;")
xlim([-180,180])
ylim([-90,90])
% Make grid to put averages in
dlat=5;
dlon=5;
glat=-90:dlat:90;
glon=-180:dlon:180;
datgrid=zeros(length(glat),length(glon));
gridcell=zeros(2,length(lon));
incell=cell(length(glat),length(glon));
% take average of values in each grid
for i=1:length(glat)
	for j=1:length(glon)
		datsingrid=0;
		val=0;
		for k=1:length(dat)
			inbox= (glat(i)-dlat/2 <= lat(k));
			inbox=inbox&(lat(k) < glat(i)+dlat/2);
			inbox=inbox&(glon(j)-dlon/2<=lon(k));
			inbox=inbox&(lon(k)<glon(j)+dlon/2);
			if(inbox)
				incell{i,j}=[incell{i,j},k];
				gridcell(:,k)=[j,i];
				datsingrid=datsingrid+1;
				val=val+dat(k);
			end%if
		end%for
		if(datsingrid==0)
			% if no data exists set to NaN
			datgrid(i,j)=NaN;
		else
			datgrid(i,j)=val/datsingrid;
		end%if
	end%for
end%for
subplot(2,1,2)
pcolor(glon,glat,datgrid)
shading flat
