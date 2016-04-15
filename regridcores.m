%Set number of random data points
Ndata=256;
%make random locations for "cores"
xyz=2*rand(3,Ndata)-1	;
xyz=xyz./sqrt(sum(xyz.*xyz,1));
%Core location latitude
lat=(180/pi)*asin(-xyz(3,:));
%Core location longitude
lon=(180/pi)*atan2(xyz(1,:),xyz(2,:));
%Value at eat sample location
dat=cos(2*pi*lat/180).*cos(2*pi*lon/180)+.1*rand(1,Ndata);
%Plot the location of the points
subplot(2,2,1)
plot(lon,lat,"o;;")
xlim([-180,180])
ylim([-90,90])
% Make grid to put averages in
dlat=15;
dlon=30;
glat=-90:dlat:90;
glon=-180:dlon:180;
datgrid=zeros(length(glat),length(glon));
ingrid=zeros(length(glat),length(glon));
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
				ingrid(i,j)=ingrid(i,j)+1;
				val=val+dat(k);
			end%if
		end%for
		if(ingrid(i,j)==0)
			% if no data exists set to NaN
			datgrid(i,j)=NaN;
		else
			datgrid(i,j)=val;
		end%if
	end%for
end%for
datgrid=datgrid./ingrid;
subplot(2,2,2)
pcolor(glon,glat,datgrid)
shading flat
subplot(2,2,3)
pcolor(glon,glat,ingrid)
shading flat
subplot(2,2,4)
plot(1:Ndata,glat(gridcell(2,:)),"x;lat;",1:Ndata,glon(gridcell(1,:)),"+;lon;")
