function [LON,LAT,TIME,SSH,CYCLES]=get_track_data(pdir,fhead,tracknumber,jd1,jd2,...
                                                  lonlims,latlims);

% find files:
a=evalc(['!ls -l ' pdir '*.nc']);

in=findstr(a,'.nc');
nf=length(in);

Date1=zeros(nf,1);
Date2=zeros(nf,1);
flist=[];

if strcmp(pdir,'/home/europe/kurapov/AVISO/NRT/ADT/Jason1/') |...
   strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/nrt/adt/j1/') |...
   strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/nrt/adt/j2/') 


 for k=1:nf
  flist=[flist;...
         [fhead a(in(k)-11:in(k)+2)]];

  Date1(k)=str2num(a(in(k)-11:in(k)-7));
  Date2(k)=str2num(a(in(k)-5 :in(k)-1));
 end

elseif strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/dt/upd/adt/j1/') |...
       strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/dt/upd/adt/tpn/') |...
       strcmp(pdir,'/home/europe/kurapov/AVISO/SSH/duacs/global/dt/upd/adt/en/')
 % example, filename: 
 % dt_upd_global_tpn_adt_vxxc_20051005_20051008_20080109.nc

 jd0=datenum('1-Jan-1950');
 
 for k=1:nf
  flist=[flist;...
         [fhead a(in(k)-26:in(k)+2)]];

  dstr1=a(in(k)-26:in(k)-19);
  dstr2=a(in(k)-17:in(k)-10);
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
nf=length(Date1);

% read file by file:
rec=0;

for k=1:nf

 fname=[pdir flist(k,:)];
 disp(fname);
 
 [dt,Tracks,NbPoints,Cycles,lon,lat,BeginDates,ind,ssh]=read_along_track_file(fname);

 in=find(lon>180);
 lon(in)=lon(in)-360;

 [ncycles,ndata]=size(ssh);
 ntr=length(Tracks);

 % End points, start points of each track
 I2=cumsum(NbPoints);
 I1=[1;I2(1:end-1)+1];

 itr=find(Tracks==tracknumber);

 if length(itr>0) 

  i1=I1(itr);
  i2=I2(itr);
  ii=[i1:i2];
  nii=length(ii);

  lon=lon(ii);
  lat=lat(ii);
  ind=ind(ii);
  ssh=ssh(:,ii);
  ssh(find(ssh>30))=NaN;

  in=find(lon>=lonlims(1) & lon<=lonlims(2) & ...
          lat>=latlims(1) & lat<=latlims(2));

  in

  lon=lon(in);
  lat=lat(in);
  ind=ind(in);
  ssh=ssh(:,in);
  nn=length(lon);

  Cycles=Cycles(:,itr);
  BeginDates=BeginDates(:,itr);
  
  BeginDates
  nn
  ind
  ncycles

  t=repmat(BeginDates,[1 nn])+repmat(ind',[ncycles 1])*dt/(24*3600);

  t

  for ic=1:ncycles
 
   if (Cycles(ic)~=-1)
 
    tmean=mean(t(ic,:));

    if tmean>=jd1 & tmean<=jd2
     rec=rec+1;
     LON{rec}=lon;
     LAT{rec}=lat;
     TIME{rec}=t(ic,:);
     SSH{rec}=ssh(ic,:);
     CYCLES(rec)=Cycles(ic);
    end
 
   end % if length(itr>0), if given track is in the record

  end
 end  

end

% Resort, leave only latest record for each cycle

if rec>0

 unicycles=unique(CYCLES);
 nc=length(unicycles);

 for k=1:nc
  recs=find(CYCLES==unicycles(k));
  rec=recs(end);
  LON_uni{k}=LON{rec};
  LAT_uni{k}=LAT{rec};
  TIME_uni{k}=TIME{rec};
  SSH_uni{k}=SSH{rec};
 end

 LON=LON_uni;
 LAT=LAT_uni;
 TIME=TIME_uni;
 SSH=SSH_uni;
 CYCLES=unicycles;

else

 LON=[];
 LAT=[];
 TIME=[];
 SSH=[];
 CYCLES=[];

end
