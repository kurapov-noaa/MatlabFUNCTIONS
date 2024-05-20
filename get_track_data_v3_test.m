function [LON,LAT,TIME,SSH,TRACKS,CYCLES]=get_track_data_v3_test(pdir,fhead,jd1,jd2,...
                                                            lonlims,latlims);

% A. Kurapov, 9/24/2009: get info on all tracks that pass area (lonlims, latlims)
% during time interval (jd1,jd2)

% find files:
a=evalc(['!ls -l ' pdir fhead '*.nc']);

in1=findstr(a,[pdir fhead]);
in2=findstr(a,'.nc')+2;
nf=length(in1);

Date1=zeros(nf,1);
Date2=zeros(nf,1);
flist=[];

if strcmp(pdir,'/home/europe/kurapov/AVISO/NRT/ADT/Jason1/') |...
   strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/nrt/adt/j1/') |...
   strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/nrt/adt/j2/') 

 error('REVISE, no fhead');
    
%
% for k=1:nf
%  flist=[flist;...
%         [fhead a(in(k)-11:in(k)+2)]];
%
%  Date1(k)=str2num(a(in(k)-11:in(k)-7));
%  Date2(k)=str2num(a(in(k)-5 :in(k)-1));
% end

elseif strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/dt/upd/adt/j1/') |...
       strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/dt/upd/adt/tpn/') |...
       strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/dt/upd/adt/en/')
 % example, filename: 
 % dt_upd_global_tpn_adt_vxxc_20051005_20051008_20080109.nc

 jd0=datenum('1-Jan-1950');
 
 for k=1:nf
  i1=in1(k);
  i2=in2(k);
  flist=[flist;...
         [a(i1:i2)]];

  dstr1=a(i2-28:i2-21);
  dstr2=a(i2-19:i2-12);
  dstr1=[dstr1(5:6) '/' dstr1(7:8) '/' dstr1(1:4)];
  dstr2=[dstr2(5:6) '/' dstr2(7:8) '/' dstr2(1:4)];
  Date1(k)=datenum(dstr1)-jd0;
  Date2(k)=datenum(dstr2)-jd0;
 end
 
end

in=find( (Date1>=jd1 & Date1<=jd2) | (Date2>=jd1 & Date2<=jd2));
Date1=Date1(in);
Date2=Date2(in);
flist=flist(in,:);

[Date1,isor]=sort(Date1);
Date2=Date2(isor);
flist=flist(isor,:);

nf=length(Date1);

% read file by file:
rec=0;

for k=1:nf

 fname=flist(k,:);
 disp(fname);
 
 [dt,Tracks,NbPoints,Cycles,lon,lat,BeginDates,ind,ssh]=read_along_track_file(fname);

 in=find(lon>180);
 lon(in)=lon(in)-360;

 [ncycles,ndata]=size(ssh);
 ntr=length(Tracks);

 % End points, start points of each track
 I2=cumsum(NbPoints);
 I1=[1;I2(1:end-1)+1];

 % all arrays - same size at ssh(ncycles,ndata)
 lon=repmat(lon',[ncycles 1]);
 lat=repmat(lat',[ncycles 1]);
 ptrack=zeros(ncycles,ndata);
 pcycle=zeros(ncycles,ndata);
 t=zeros(ncycles,ndata);

 for icycle=1:ncycles
 for itr=1:ntr
  ii=[I1(itr):I2(itr)]';
  ptrack(icycle,ii)=Tracks(itr);
  pcycle(icycle,ii)=Cycles(icycle,itr);
  t(icycle,ii)=BeginDates(icycle,itr)+ind(ii)*dt/(24*3600); 
 end
 end

 % reshape
 nn=ncycles*ndata;
 lon=reshape(lon,[nn 1]);
 lat=reshape(lat,[nn 1]);
 ptrack=reshape(ptrack,[nn 1]);
 pcycle=reshape(pcycle,[nn 1]);
 t=reshape(t,[nn 1]);
 ssh=reshape(ssh,[nn 1]);

 in=find(lon>=lonlims(1) & lon<=lonlims(2) & ...
         lat>=latlims(1) & lat<=latlims(2) & ...
         ssh<30);

 if ~isempty(in)
  lon=lon(in);
  lat=lat(in);
  ptrack=ptrack(in);
  pcycle=pcycle(in);
  ssh=ssh(in);
  t=t(in);

  track_subset=unique(ptrack);
  cycle_subset=unique(pcycle);
  ntrs=length(track_subset);
  ncyc=length(cycle_subset);

  for itr=1:ntrs
  for icy=1:ncyc
   tr=track_subset(itr);
   cy=cycle_subset(icy);
   in=find(ptrack==tr & pcycle==cy);
   
   tmean=mean(t(in));
   if tmean>=jd1 & tmean<=jd2
    rec=rec+1;
    LON{rec}=lon(in);
    LAT{rec}=lat(in);
    TIME{rec}=t(in);
    SSH{rec}=ssh(in);
    TRACKS(rec)=tr;
    CYCLES(rec)=cy;
   end
  end
  end

 end  % ~isempty(in)
end

% Resort, leave only latest record for each track-cycle combination

if rec>0

 k=0;
 for irec=1:rec
  unirec=0;
  tr=TRACKS(irec);
  cy=CYCLES(irec);
  if irec<rec
   inn=find(TRACKS(irec+1:end)==tr &  CYCLES(irec+1:end)==cy); 
   if isempty(inn)
    unirec=1;
   end   
  else
   unirec=1;
  end

  if unirec
   k=k+1;
   LON_uni{k}=LON{irec};
   LAT_uni{k}=LAT{irec};
   TIME_uni{k}=TIME{irec};
   SSH_uni{k}=SSH{irec};
   TRACKS_uni(k)=tr;
   CYCLES_uni(k)=cy;
  end
 end

 LON=LON_uni;
 LAT=LAT_uni;
 TIME=TIME_uni;
 SSH=SSH_uni;
 TRACKS=TRACKS_uni;
 CYCLES=CYCLES_uni;

else

 LON=[];
 LAT=[];
 TIME=[];
 SSH=[];
 TRACKS=[];
 CYCLES=[];

end

