load('regridfun.m')
%Set number of random data points
Ndata	=	1024;
%make random locations for "cores"
%Core location latitude
lat	=	(180/pi)*acos(1-2*rand(1,Ndata))-90;
%Core location longitude
lon	=	360*rand(1,Ndata);
%Value at eat sample location
dat	=	sin(4*pi*lat/180).*cos(4*pi*lon/180)+.2*rand(1,Ndata);
%Plot the location of the points
subplot(2,2,1)
plot(lon,lat,"o;;")
xlim([0,360])
ylim([-90,90])
title("Sample locations")
% Make grid to put averages in
dlat	=	9;
dlon	=	10;
[datgrid,glon,glat,gridcell,incell,ingrid] = regridfun(dat,lat,lon,dlat,dlon);
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
xlim([1,Ndata])

