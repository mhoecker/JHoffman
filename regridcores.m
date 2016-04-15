%Set number of random data points
Ndata	=	8192;
%make random locations for "cores"
xyz	=	2*rand(3,Ndata)-1	;
xyz	=	xyz./sqrt(sum(xyz.*xyz,1));
%Core location latitude
lat	=	(180/pi)*acos(1-2*rand(1,Ndata))-90;
%Core location longitude
lon	=	360*rand(1,Ndata);
%Value at eat sample location
dat	=	sin(2*pi*lat/180).*cos(2*pi*lon/180)+.2*rand(1,Ndata);
%Plot the location of the points
subplot(2,2,1)
plot(lon,lat,"o;;")
xlim([-360,360])
ylim([-90,90])
title("Sample locations")
% Make grid to put averages in
dlat	=	3;
dlon	=	5;
glat	=	-90:dlat:(90-dlat);
glon	=	-180:dlon:(180-dlon);
Nlon	=	length(glon);
Nlat	=	length(glat);
datgrid	=	zeros(Nlon,Nlat);
ingrid	=	zeros(Nlon,Nlat);
gridcell=	zeros(2,Ndata);
incell	=	cell(Nlon,Nlat);
% take average of values in each grid
for k=1:Ndata
	i		=	round((lon(k)-glon(1))/dlon);
	i		=	mod(i,Nlon)+1;
	j		=	round((lat(k)-glat(1))/dlat);
	j		=	mod(j,Nlat)+1;
	incell{i,j}	=	[incell{i,j},k];
	gridcell(:,k)	=	[i,j];
	ingrid(i,j)	=	ingrid(i,j)+1;
	datgrid(i,j)	=	datgrid(i,j)+dat(k);
end%for
datgrid	=	datgrid./ingrid;
subplot(2,2,2)
pcolor(glon,glat,datgrid')
shading flat
title("Gridded Data")
subplot(2,2,3)
pcolor(glon,glat,ingrid')
title("# of data points in cell")
shading flat
subplot(2,2,4)
plot(1:Ndata,glat(gridcell(2,:)),"x;lat;",1:Ndata,glon(gridcell(1,:)),"+;lon;")
