function [datgrid,glon,glat,gridcell,incell,ingrid] = regridfun(dat,lat,lon,dlat,dlon)
	if(nargin<3)
		%Set number of random data points
		Ndata	=	1024;
		%make random locations for "cores"
		%Core location latitude
		lat	=	(180/pi)*acos(1-2*rand(1,Ndata))-90;
		%Core location longitude
		lon	=	360*rand(1,Ndata);
		%Value at eat sample location
		dat	=	sin(4*pi*lat/180).*cos(4*pi*lon/180)+.2*rand(1,Ndata);
	else
		Ndata=length(lon);
	end%if
	% Make grid to put averages in
	if(nargin<4)
		dlat	=	9;
	end%if
	if(nargin<5)
		dlon	=	10;
	end%if
	glat	=	-90:dlat:(90-dlat);
	glon	=	-180:dlon:(180-dlon);
	Nlon	=	length(glon);
	Nlat	=	length(glat);
	% Gridded data
	datgrid	=	zeros(Nlon,Nlat);
	% How many data points are in that grid point
	ingrid	=	zeros(Nlon,Nlat);
	% indecies of the  grid cell is a particular data point in
	gridcell=	zeros(2,Ndata);
	% list of which data points are in a particular grid point
	incell	=	cell(Nlon,Nlat);
	% Put each data point into a grid point
	for k=1:Ndata
		%Find the nearest longitude
		i		=	round((lon(k)-glon(1))/dlon);
		i		=	mod(i,Nlon)+1;
		%Find the nearest latitude
		j		=	round((lat(k)-glat(1))/dlat);
		j		=	mod(j,Nlat)+1;
		% add the data index to that cells listing
		incell{i,j}	=	[incell{i,j},k];
		% add the grid cell index to that data points listing
		gridcell(:,k)	=	[i,j];
		% increase the count of data points in that grid cell
		ingrid(i,j)	=	ingrid(i,j)+1;
		% add the value to that cells running average
		datgrid(i,j)	=	datgrid(i,j)+dat(k);
	end%for
	% take the average
	% Note: this will give NaNs for unoccupied cells
	datgrid	=	datgrid./ingrid;
end%function
