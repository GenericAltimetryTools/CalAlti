c$main	
      program naotestj	
c	
c Test driver program for subroutine <naotidej>	
c	
c Code : Koji Matsumoto	
c Date : 2000.09.09	
c	
      implicit double precision (a-h,o-z)	
c     	
      character*80 outfile	
      Logical      Ldata	
c	
c -----< Set mode, location, epoch, data interval, and output file >-----	
c      	
c Mode selection	
      itmode   = 1	
c      Set itmode = 1 to calculate geocentric tide	
c                 = 2 to calculate pure ocean tide 	
c                        with respect to ocean floor	
c                 = 3 to calculate radial loading tide 	
      lpmode  = 1	
c      Set lpmode = 1 to use long-period ocean tide map of Takanezawa	
c                 = 2 to use equilibrium tide (Valid for itmode = 1,2)	
c	
c Station location	
      x       =119.9895     ! East longitude in degree	
      y       =39.9166     ! North latitude in degree	
c	
c Start epoch	
      iyear1  =2016 ! year	
      imon1  =32 ! month	
      iday1  =18 ! iday1	
      ihour1  =00 ! ihour1	
      imin1  =32 ! imin1	
c	
c End epoch	
      iyear2  =2016 ! year	
      imon2  =32 ! month	
      iday2  =18 ! iday1	
      ihour2  =00 ! ihour1	
      imin2  =32 ! imin1	
c	
c Output data interval in minute	
      dt      = 10d0           ! in minute	
c	
c Output file name	
      outfile = 'naotestj.out'	
c	
c-----------------------------------------------------------------------	
c	
      print*,'--------------< naotestj (version000909) >--------------'	
      print*,'Output file : ',outfile	
      print*,'--------------------------------------------------------'	
c	
      open(20,file=outfile)	
c	
      if (itmode.eq.1) then	
         write(20,105)	
 105     format('Geocentric tidal height')	
      else if (itmode.eq.2) then	
         write(20,106)	
 106     format('Pure ocean tidal height WRT ocean floor')	
      else	
         write(20,107)	
 107     format('Radial loading tidal height')	
      endif	
c	
      write(20,102)	
 102  format('Elapsed day   Tide(cm)  Short-p   Long-p   '	
     +       ' M  D  Yr   H  M     MJD     Longitude Latitude')	
c      	
      call mjdymd(xmjd1, iyear1, imon1 , iday1 , ihour1,	
     +            imin1, 0     , 1                      )	
      call mjdymd(xmjd2, iyear2, imon2 , iday2 , ihour2,	
     +            imin2, 0     , 1                      )	
c	
      idmax = (xmjd2-xmjd1)*1440.d0/dt + 1	
c	
      do idat = 1, idmax	
c     	
         time = xmjd1 + dfloat(idat-1)*dt/1440.d0	
c 	
         call naotidej(x     , y     , time  , itmode, lpmode,	
     +                 height, hsp   , hlp   , Ldata          )	
c	
         if (Ldata) then	
c     	
            call mjdymd(time  , iy    , im    , id    , ih    ,	
     +                  imin  , isec  , 2                      )	
c	
            write(20,101) time-xmjd1, height, hsp, hlp,	
     +                    im, id, iy, ih, imin, time, x, y	
 101        format(f12.6,3f10.3,i3,'/',i2,i5,i3,':',i2,f13.6,2f9.4)	
c     	
         else	
c     	
            write(20,103)	
 103        format('Tide not defined at the selected location.')	
            write(20,104) x,y	
 104        format('(lon,lat) = ',2f10.5)	
c     	
         endif	
c     	
      enddo	
c	
 19   stop	
      end	
c	
c$naotidej	
c-------------------------------------------------------------------	
      subroutine naotidej (x     , y     , smjd  , itmode, lpmode ,	
     +                    height, hsp   , hlp   , Ldata           )	
c-------------------------------------------------------------------	
c	
c* Inputs (double precision)	
c    x      : East longitude in degrees (110.d0 to 165.d0).	
c    y      : North latitude in degrees ( 20.d0 to  65.d0).	
c    smjd   : Modified Julian date in days.	
c             (MJD for 1998.10.15 00:00:00 = 51101.0)	
c	
c  Input (integer)	
c    itmode : 1; Geocentric tidal height (pure ocean tide with	
c                respect to ocean floor + loading tide) is computed	
c                as 'height'.	
c             2; Pure ocean tidal height with respect to ocean floor	
c                is computed.	
c             3; Radial loading tidal height is computed.  	
c	
c    lpmode : 1; Use long-period ocean tide map of Takanezawa (1999).	
c             2; Equilibrium tide (Valid for itmode = 1,2)	
c             Note that 18.6-year period tide (Doodson #055.565)	
c             is treated as equilibrium tide for both lpmode=1 and 2.	
c	
c* Outputs (double precision)	
c    hsp    : Short-period tide value from 16 major constituents	
c             + 33 minor constituents.	
c    hlp    : Long-period tide value from 7 constituents + 5 nodal	
c             modulations. 18.6-year period equilibrium tide is	
c             added to the 12 terms when itmode = 1 or 2.	
c    height : Total tide value = hsp + hlp.	
c	
c  Output (logical)	
c    Ldata  : True if the ocean tide map is defined at the	
c             location (x,y), false otherwise.	
c             If Ldata is .false., all tidal outputs are returned	
c             as 9999.99d0.	
c	
c    Note that all tidal outputs are in centimeters.	
c                                       ^^^^^^^^^^^	
c* Tidal map directory configuration	
c    Suppose you want to put ocean tide maps in	
c      /home/kikuchi/momoko	
c    then you may change omapdir as	
c	
c      omapdir  = '/home/kikuchi/momoko'	
c  	
c    (Default is omapdir = './omap')	
c	
c* Unit 21 is assigned to open the tidal map files.	
c	
c Code : Koji Matsumoto (matumoto@miz.nao.ac.jp)	
c	
c Date : 2000.09.06,  modified from naotide.f	
c        	
      implicit double precision (a-h,o-z)	
c	
      Logical Lfirst, Ldata	
c	
      parameter (xmin0  = 110.d0, xmax0 = 165.d0)	
      parameter (ymin0  =  20.d0, ymax0 =  65.d0)	
      parameter (mmaxs  = 662   , nmaxs = 542)	
      parameter (mmaxl  = 721   , nmaxl = 361)	
      parameter (nwsmj  = 16    , nwsmi = 33)	
      parameter (nwlmj  =  7    , nwlmi =  5)	
      parameter (iunt21 = 21)	
c	
      dimension cs(mmaxs,nmaxs,nwsmj), ss(mmaxs,nmaxs,nwsmj)	
      dimension cl(mmaxl,nmaxl,nwlmj), sl(mmaxl,nmaxl,nwlmj)	
      dimension was(mmaxs,nmaxs)     , wps(mmaxs,nmaxs)	
      dimension wal(mmaxl,nmaxl)     , wpl(mmaxl,nmaxl)	
      dimension iwas(mmaxs)          , iwps(mmaxs)	
      dimension iwal(mmaxl)          , iwpl(mmaxl)	
      dimension fmaps(nwsmj)         , fmapl(nwlmj)	
c	
      character*80 omapdir, fmaps, fmapl, fmap	
c	
      data Lfirst /.true./	
      data undef  /9999.99d0/	
c	
c ***** Directory conf. *****	
c	
      data omapdir /'./omap'/	
c	
c ***************************	
c     	
      save	
c	
c ----------------------------------------------------------------------	
c	
      if ( (x.lt.xmin0) .or. (x.gt.xmax0) .or.	
     +     (y.lt.ymin0) .or. (y.gt.ymax0)      ) then	
         height = undef	
         hsp    = undef	
         hlp    = undef	
         Ldata = .false.	
         return	
      endif	
c	
      if ( (itmode.lt.1).or.(itmode.gt.3) ) then	
         print*,'!!! Error in <naotidej>. itmode should be 1, 2, or 3.'	
         stop	
      endif	
c	
      if ( (lpmode.lt.1).or.(lpmode.gt.2) ) then	
         print*,'!!! Error in <naotidej>. lpmode should be 1 or 2.'	
         stop	
      endif	
c	
c =====[ Preparation on first call (begin) ]=====	
c	
      if (Lfirst) then	
c	
         Lfirst = .false.	
c	
         print*,'Now reading ocean tide map...'	
c	
         call fname(omapdir, itmode, nwsmj, nwlmj, fmaps, fmapl)	
c     	
c ---< Read short-period maps >-----	
c	
         do iwave = 1, nwsmj	
	
            fmap = fmaps(iwave)	
	
            call rdmap(iunt21, cs    , ss    , dxs   , dys   ,	
     +                 mmaxs , nmaxs , nwsmj , xmins , ymaxs ,	
     +                 mends , nends , fmap  , undef , was   ,	
     +                 wps   , iwas  , iwps  , iwave         )	
	
         enddo	
c	
c ---< Read long-period maps >-----	
c	
         if ( (lpmode.eq.1).or.(itmode.eq.3) ) then	
c	
            do iwave = 1, nwlmj	
c	
               fmap = fmapl(iwave)	
c	
               call rdmap(iunt21, cl    , sl    , dxl   , dyl   ,	
     +                    mmaxl , nmaxl , nwlmj , xminl , ymaxl ,	
     +                    mendl , nendl , fmap  , undef , wal   ,	
     +                    wpl   , iwal  , iwpl  , iwave         )	
c	
            enddo	
c	
            print*,'---------------------------------------'	
c	
         endif	
c	
      endif	
c	
c =====[ Preparation on first call (End) ]=====	
c	
c	
c ===========================================================	
c	
c -----< Short-period tide >-----	
c	
      call hshort(x     , y     , smjd  , hsp   , undef ,	
     +            cs    , ss    , mmaxs , nmaxs , mends ,	
     +            nends , nwsmj , nwsmi , xmins , ymaxs ,	
     +            dxs   , dys                            )	
c	
c -----< Long-period tide >-----	
c	
      if ( (lpmode.eq.1).or.(itmode.eq.3) ) then	
c	
         call hlong (x     , y     , smjd  , hlp   , undef ,	
     +               cl    , sl    , mmaxl , nmaxl , mendl ,	
     +               nendl , nwlmj , nwlmi , xminl , ymaxl ,	
     +               dxl   , dyl   , itmode                 )	
c	
      else	
c	
c -----< Long-period equilibrium tide >-----	
c	
         call hlpeql(y, smjd, nwlmj, nwlmi, hlp)	
c	
      endif	
c         	
      if ( (hsp.lt.undef).and.(hlp.lt.undef) ) then	
c	
         height = hsp + hlp	
         Ldata = .true.	
c	
      else if ( (hsp.lt.undef).and.(hlp.ge.undef-1.d-5) ) then	
c	
         height = hsp	
         hlp    = undef	
         Ldata = .true.	
c	
      else	
c	
         height = undef	
         hsp    = undef	
         hlp    = undef	
         Ldata  = .false.	
c	
      endif	
c	
c ===========================================================	
c	
      return	
      end	
c	
c$astrol	
c --------------------------------------------------------------	
      subroutine astrol(smjd  , arglmj, arglmi, wlmj  , wlmi  ,	
     +                  helmj , helmi , nwlmj , nwlmi , arg186 )	
c --------------------------------------------------------------	
c	
c Reference	
c Tamura, Y. (1987) : A harmonic development of the tide-generating	
c    potential, Marees Terrestres Bulitin d'Informations, 99, 6813-6855.	
c	
      implicit   double precision(a-h,o-z)	
c	
      common /astrov/ iagsmj(7,16) , eqasmj(16),	
     +                iagsmi(7,33) , eqasmi(33),	
     +                iaglmj(7, 7) , eqalmj( 7),	
     +                iaglmi(7, 5) , eqalmi( 5),	
     +                fr(3,6)      , etmut(130)	
      common /const/  pi , rad, deg	
c	
      parameter (r36525 = 1.d0/36525.d0)	
c	
      dimension arglmj(nwlmj), wlmj(nwlmj), helmj(nwlmj)	
      dimension arglmi(nwlmi), wlmi(nwlmi), helmi(nwlmi)	
      dimension xarg(7,33)   , f(6)	
c	
c ----------------------------------------------------------------------	
c	
      call mjdymd(smjd  , iy    , im    , id    , ih    ,	
     +            imin  , isec  , 2                      )	
c	
      tdmut = etmut(iy-1900)	
c	
      tu  = (smjd - 51544.5d0) / 36525.d0	
      tu2 = tu*tu	
      tu3 = tu2*tu	
      td  = tu + tdmut/86400.d0/36525.d0	
      td2 = td*td	
      frac = smjd - dint(smjd)	
c	
      f(2) = fr(1,2) + fr(2,2)*td + fr(3,2)*td2 	
     +     + 0.0040d0*dcos((29.d0*133.d0*td)*rad)	
c	
      f(1) = fr(1,1) + fr(2,1)*tu + fr(3,1)*tu2 	
     +     - 0.0000000258d0*tu3   + 360.d0*frac - f(2)	
c	
      f(3) = fr(1,3) + fr(2,3)*td + fr(3,3)*td2	
     +     + 0.0018d0*dcos((159.d0+19.d0*td)*rad)	
c	
      f(4) = fr(1,4) + fr(2,4)*td + fr(3,4)*td2	
c	
      f(5) = fr(1,5) + fr(2,5)*td + fr(3,5)*td2	
c	
      f(6) = fr(1,6) + fr(2,6)*td + fr(3,6)*td2	
c	
c -----< Long-period Major 7 >-----	
c	
      do j = 1,nwlmj	
c	
         do i = 1,7	
            xarg(i,j) = dfloat(iaglmj(i,j))	
         enddo	
c	
         helmj(j) = eqalmj(j)	
c	
      enddo	
c	
      call setaw(nwlmj , xarg  , f     , r36525, arglmj, wlmj  )	
c	
c -----< Long-period nodal modulations >-----	
c	
      do j = 1,nwlmi	
c	
         do i = 1,7	
            xarg(i,j) = dfloat(iaglmi(i,j))	
         enddo	
c	
         helmi(j) = eqalmi(j)	
c	
      enddo	
c	
      call setaw(nwlmi , xarg  , f     , r36525, arglmi, wlmi  )	
c     	
c -----< 18.6-year period tide (055.565) >-----	
c	
      arg186 = f(5)*rad	
c	
      return	
      end	
c	
c$astros	
c --------------------------------------------------------------	
      subroutine astros(smjd  , argsmj, argsmi, wsmj  , wsmi  ,	
     +                  hesmj , hesmi , nwsmj , nwsmi          )	
c --------------------------------------------------------------	
c	
c Reference	
c Tamura, Y. (1987) : A harmonic development of the tide-generating	
c    potential, Marees Terrestres Bulitin d'Informations, 99, 6813-6855.	
c	
      implicit   double precision(a-h,o-z)	
c	
      common /astrov/ iagsmj(7,16) , eqasmj(16),	
     +                iagsmi(7,33) , eqasmi(33),	
     +                iaglmj(7, 7) , eqalmj( 7),	
     +                iaglmi(7, 5) , eqalmi( 5),	
     +                fr(3,6)      , etmut(130)	
      common /const/  pi , rad, deg	
c	
      parameter (r36525 = 1.d0/36525.d0)	
c	
      dimension argsmj(nwsmj), wsmj(nwsmj), hesmj(nwsmj)	
      dimension argsmi(nwsmi), wsmi(nwsmi), hesmi(nwsmi)	
      dimension xarg(7,33)   , f(6)	
c	
c ----------------------------------------------------------------------	
c	
      call mjdymd(smjd  , iy    , im    , id    , ih    ,	
     +            imin  , isec  , 2                      )	
c	
      tdmut = etmut(iy-1900)	
c	
      tu  = (smjd - 51544.5d0) / 36525.d0	
      tu2 = tu*tu	
      tu3 = tu2*tu	
      td  = tu + tdmut/86400.d0/36525.d0	
      td2 = td*td	
      frac = smjd - dint(smjd)	
c	
      f(2) = fr(1,2) + fr(2,2)*td + fr(3,2)*td2 	
     +     + 0.0040d0*dcos((29.d0*133.d0*td)*rad)	
c	
      f(1) = fr(1,1) + fr(2,1)*tu + fr(3,1)*tu2 	
     +     - 0.0000000258d0*tu3   + 360.d0*frac - f(2)	
c	
      f(3) = fr(1,3) + fr(2,3)*td + fr(3,3)*td2	
     +     + 0.0018d0*dcos((159.d0+19.d0*td)*rad)	
c	
      f(4) = fr(1,4) + fr(2,4)*td + fr(3,4)*td2	
c	
      f(5) = fr(1,5) + fr(2,5)*td + fr(3,5)*td2	
c	
      f(6) = fr(1,6) + fr(2,6)*td + fr(3,6)*td2	
c	
c -----< Short-period Major 16 >-----	
c	
      do j = 1,nwsmj	
c	
         do i = 1,7	
            xarg(i,j) = dfloat(iagsmj(i,j))	
         enddo	
c	
         hesmj(j) = eqasmj(j)	
c	
      enddo	
c	
      call setaw(nwsmj , xarg  , f     , r36525, argsmj, wsmj  )	
c	
c -----< Short-period Minor 33 >-----	
c	
      do j = 1,nwsmi	
c	
         do i = 1,7	
            xarg(i,j) = dfloat(iagsmi(i,j))	
         enddo	
c	
         hesmi(j) = eqasmi(j)	
c	
      enddo	
c	
      call setaw(nwsmi , xarg  , f     , r36525, argsmi, wsmi  )	
c	
      return	
      end	
c	
c$chop	
c----------------------------------------------------------------	
      subroutine chop(buf,ic)	
c----------------------------------------------------------------	
c	
      character*80 buf	
c	
      do i = 80,1,-1	
         if (buf(i:i).eq.'/') then	
            ic = i - 1	
            goto 9	
         endif	
         if (buf(i:i).ne.' ') then	
            ic = i	
            goto 9	
         endif	
      enddo	
c	
 9    return	
      end	
c	
c$fname	
c-------------------------------------------------------------------	
      subroutine fname(omapdir, imode, nwsmj, nwlmj, fmaps, fmapl)	
c-------------------------------------------------------------------	
	
      implicit double precision (a-h,o-z)	
c	
      common /wave/   wns(16), wnl(7)	
c	
      dimension fmaps(nwsmj), fmapl(nwlmj)	
      dimension cmodes(3)   , cmodel(3)	
c     	
      character*80 omapdir, fmaps, fmapl	
      character*10 cmodes, cmodel	
      character*2  wn2	
      character*3  wns, wnl, wn3	
c	
      data cmodes/'_j_gc.nao ','_j.nao    ','_rload.nao'/	
      data cmodel/'_gc.nao   ','.nao      ','_rload.nao'/	
c	
c ---------------------------------------------------------------------	
c	
      call chop(omapdir,ic)	
c     	
      do iwave = 1,nwsmj	
c	
         wn3 = wns(iwave)	
         iwn2 = 0	
c	
         if (wn3(3:3).eq.' ') then	
            iwn2 = 1	
            wn2  = wn3(1:2)	
         endif	
c	
         if (iwn2.eq.0) then	
            fmaps(iwave) = omapdir(1:ic)//'/'//wn3//cmodes(imode)	
         else	
            fmaps(iwave) = omapdir(1:ic)//'/'//wn2//cmodes(imode)	
         endif	
c	
      enddo	
c	
      do iwave = 1,nwlmj	
c	
         wn3 = wnl(iwave)	
         iwn2 = 0	
c	
         if (wn3(3:3).eq.' ') then	
            iwn2 = 1	
            wn2  = wn3(1:2)	
         endif	
c	
         if (iwn2.eq.0) then	
            fmapl(iwave) = omapdir(1:ic)//'/'//wn3//cmodel(imode)	
         else	
            fmapl(iwave) = omapdir(1:ic)//'/'//wn2//cmodel(imode)	
         endif	
c	
      enddo	
c	
      return	
      end	
c	
c$hlong	
c -----------------------------------------------------------	
      subroutine hlong(x     , y     , smjd  , height, undef ,	
     +                 cL    , sL    , mmax  , nmax  , mend  ,	
     +                 nend  , nwlmj , nwlmi , xmin  , ymax  ,	
     +                 dx    , dy    , itmode                 )	
c -----------------------------------------------------------	
c	
c Calculate long-period tidal height.	
c	
      implicit double precision (a-h,o-z)	
c	
      common /const/  pi , rad, deg	
c	
      dimension cL(mmax,nmax,nwlmj), sL(mmax,nmax,nwlmj)	
      dimension bialmj(nwlmj)      , biplmj(nwlmj)	
      dimension bialmi(nwlmi)      , biplmi(nwlmi)	
      dimension arglmj(nwlmj), wlmj(nwlmj), helmj(nwlmj)	
      dimension arglmi(nwlmi), wlmi(nwlmi), helmi(nwlmi)	
      dimension wf(2,2)	
      dimension infnml(5)	
c	
      data he186 /-0.065547d0/	
      data fact  /18.660641d0/	
      data infnml/1, 2, 4, 4, 6/	
c	
c ----------------------------------------------------------------------	
c	
      do i = 1,nwlmj	
         bialmj(i) = 0.d0	
         biplmj(i) = 0.d0	
      enddo	
c	
      do i = 1,nwlmi	
         bialmi(i) = 0.d0	
         biplmi(i) = 0.d0	
      enddo	
c	
      w0 = 0.d0	
c	
      phi = y*rad	
      g20 = 0.5d0 - 1.5d0*dsin(phi)*dsin(phi)	
c	
c -----< Bilinear interpolation >-----	
c	
      m = int( (x - xmin)/dx ) + 1.d0	
      n = int( (ymax - y)/dy ) + 1.d0	
c	
      x1 = xmin + (dfloat(m) - 1.d0)*dx	
      y1 = ymax - (dfloat(n) - 1.d0)*dy	
c	
      u1 = (x - x1)/dx	
      u2 = 1.d0 - u1	
      v1 = (y1 - y)/dy	
      v2 = 1.d0 - v1	
c	
      wf(1,1) = u2*v2	
      wf(1,2) = u2*v1	
      wf(2,1) = u1*v2	
      wf(2,2) = u1*v1	
c	
      do iy = 1,2	
c	
         nn = n + iy - 1	
c	
         if (nn.lt.1)    nn = 1	
         if (nn.gt.nend) nn = nend	
c	
         do ix = 1,2	
c	
            mm = m + ix - 1	
c	
            if (mm.lt.1)     mm = mend - mm	
            if (mm.gt.mend)  mm = mm - mend	
c	
            iundef = 0	
c	
            do i = 1,nwlmj	
               if (cL(mm,nn,i).lt.undef) then	
                  bialmj(i) = bialmj(i) + cL(mm,nn,i)*wf(ix,iy)	
                  biplmj(i) = biplmj(i) + sL(mm,nn,i)*wf(ix,iy)	
               else	
                  iundef = iundef + 1	
               endif	
            enddo	
c	
            if (iundef.lt.nwlmj) then	
               w0 = w0 + wf(ix,iy)	
            endif	
c	
         enddo   ! ix	
c	
      enddo      ! iy	
c	
      if (w0.ge.0.2d0) then	
c	
         do i = 1,nwlmj	
c	
            a0 = bialmj(i)/w0	
            p0 = biplmj(i)/w0	
            bialmj(i) = dsqrt(a0*a0+p0*p0)	
            if (dabs(a0).gt.0.d0) then	
               biplmj(i) = datan2(p0,a0)	
            elseif (p0.gt.0.d0) then	
               biplmj(i) = pi*0.5d0	
            else	
               biplmj(i) = pi*1.5d0	
            endif	
            if (biplmj(i).lt.0.d0) biplmj(i) = biplmj(i) + 2.d0*pi	
c	
         enddo	
c	
c -----< Infer nodal modulations tides from major ones >-----	
c	
         call astrol(smjd  , arglmj, arglmi, wlmj  , wlmi  ,	
     +               helmj , helmi , nwlmj , nwlmi ,arg186  )	
c	
         do i = 1,nwlmi	
c	
            k = infnml(i)	
c	
            bialmi(i) = bialmj(k)*helmi(i)/helmj(k)	
            biplmi(i) = biplmj(k)	
c	
         enddo	
c	
c -----< Calculation of tidal height >-----	
c	
         height = 0.d0	
c	
         do i = 1,nwlmj	
            height = height + bialmj(i)*dcos(arglmj(i) - biplmj(i))	
         enddo	
c	
         do i = 1,nwlmi	
            height = height + bialmi(i)*dcos(arglmi(i) - biplmi(i))	
         enddo	
c	
         if ( (itmode.eq.1) .or. (itmode.eq.2) ) then 	
            height = height + fact*g20*he186*dcos(arg186)	
         endif	
c	
      else	
c	
         height = undef	
c	
      endif	
c	
      return	
      end	
c	
c$hlpeql	
c -----------------------------------------------------------	
      subroutine hlpeql(y, smjd , nwlmj, nwlmi, height)	
c -----------------------------------------------------------	
c	
c Calculate long-period equilibrium tidal height.	
c	
      implicit double precision (a-h,o-z)	
c	
      common /const/  pi , rad, deg	
c	
      dimension arglmj(nwlmj), wlmj(nwlmj), helmj(nwlmj)	
      dimension arglmi(nwlmi), wlmi(nwlmi), helmi(nwlmi)	
c	
      data he186 /-0.065547d0/	
      data fact  /18.660641d0/	
c	
c ----------------------------------------------------------------------	
c	
      phi = y*rad	
      g20 = 0.5d0 - 1.5d0*dsin(phi)*dsin(phi)	
c	
      call astrol(smjd  , arglmj, arglmi, wlmj  , wlmi  ,	
     +            helmj , helmi , nwlmj , nwlmi , arg186 )	
c	
      height = 0.d0	
c	
      do i = 1,nwlmj	
         height = height + fact*g20*helmj(i)*dcos(arglmj(i)) ! in cm	
      enddo	
c	
      do i = 1,nwlmi	
         height = height + fact*g20*helmi(i)*dcos(arglmi(i)) ! in cm	
      enddo	
c	
      height = height + fact*g20*he186*dcos(arg186) ! in cm	
c	
      return	
      end	
c	
c$hshort	
c -----------------------------------------------------------	
      subroutine hshort(x     , y     , smjd  , height, undef ,	
     +                  cs    , ss    , mmax  , nmax  , mend  ,	
     +                  nend  , nwsmj , nwsmi , xmin  , ymax  ,	
     +                  dx    , dy                             )	
c -----------------------------------------------------------	
c	
c Calculate short-period tidal height.	
c	
      implicit double precision (a-h,o-z)	
c	
      common /const/  pi , rad, deg	
c	
      parameter (yp0 = 1.d+30, ypn = 1.d+30)	
c	
      dimension cs(mmax,nmax,nwsmj) , ss(mmax,nmax,nwsmj)	
      dimension biasmj(nwsmj)       , bipsmj(nwsmj)	
      dimension biasmi(nwsmi)       , bipsmi(nwsmi)	
      dimension cpsmj (nwsmj)       , spsmj (nwsmj)	
      dimension argsmj(nwsmj), wsmj(nwsmj), hesmj(nwsmj)	
      dimension argsmi(nwsmi), wsmi(nwsmi), hesmi(nwsmi)	
      dimension wf(2,2)	
      dimension cm(3), sm(3), wm(3)	
      dimension infnum(33)	
c	
      data infnum / 1,  1,  1,  1,  1,  2,  3,  3,  3,  3, ! 1-10	
     +              4,  5,  5,  5,  5,  5,  5,  8,  8,  9, !11-20	
     +             10, 11, 11, 11, 12, 12, 12, 14, 14, 14, !21-30	
     +             14, 14, 14/                             !31-33	
c	
c ----------------------------------------------------------------------	
c	
      do i = 1,nwsmj	
         biasmj(i) = 0.d0	
         bipsmj(i) = 0.d0	
      enddo	
c	
      do i = 1,nwsmi	
         biasmi(i) = 0.d0	
         bipsmi(i) = 0.d0	
      enddo	
c	
      w0 = 0.d0	
c	
c -----< Bilinear interpolation >-----	
c	
      m = int( (x - xmin)/dx ) + 1.d0	
      n = int( (ymax - y)/dy ) + 1.d0	
c	
      x1 = xmin + (dfloat(m) - 1.d0)*dx	
      y1 = ymax - (dfloat(n) - 1.d0)*dy	
c	
      u1 = (x - x1)/dx	
      u2 = 1.d0 - u1	
      v1 = (y1 - y)/dy	
      v2 = 1.d0 - v1	
c	
      wf(1,1) = u2*v2	
      wf(1,2) = u2*v1	
      wf(2,1) = u1*v2	
      wf(2,2) = u1*v1	
c	
      do iy = 1,2	
c	
         nn = n + iy - 1	
c	
         if (nn.lt.1)    nn = 1	
         if (nn.gt.nend) nn = nend	
c	
         do ix = 1,2	
c	
            mm = m + ix - 1	
c	
            if (mm.lt.1)     mm = mend - mm	
            if (mm.gt.mend)  mm = mm - mend	
c	
            iundef = 0	
c	
            do i = 1,nwsmj	
               if (cs(mm,nn,i).lt.undef) then	
                  biasmj(i) = biasmj(i) + cs(mm,nn,i)*wf(ix,iy)	
                  bipsmj(i) = bipsmj(i) + ss(mm,nn,i)*wf(ix,iy)	
               else	
                  iundef = iundef + 1	
               endif	
            enddo	
c	
            if (iundef.lt.nwsmj) then	
               w0 = w0 + wf(ix,iy)	
            endif	
c	
         enddo   ! ix	
c	
      enddo      ! iy	
c	
      if (w0.ge.0.2d0) then	
c	
         do i = 1,nwsmj	
c	
            cpsmj(i) = biasmj(i)/w0	
            spsmj(i) = bipsmj(i)/w0	
            biasmj(i) = dsqrt(cpsmj(i)*cpsmj(i) + spsmj(i)*spsmj(i))	
            if (dabs(cpsmj(i)).gt.0.d0) then	
               bipsmj(i) = datan2(spsmj(i),cpsmj(i))	
            elseif (spsmj(i).gt.0.d0) then	
               bipsmj(i) = pi*0.5d0	
            else	
               bipsmj(i) = pi*1.5d0	
            endif	
            if (bipsmj(i).lt.0.d0) bipsmj(i) = bipsmj(i) + 2.d0*pi	
c	
         enddo	
c	
c -----< Infer minor tides from major ones >-----	
c	
         call astros(smjd  , argsmj, argsmi, wsmj  , wsmi  ,	
     +               hesmj , hesmi , nwsmj , nwsmi          )	
c	
         do i = 1,nwsmi	
c	
            do j = 1,3	
c	
               k = infnum(i) + j - 1	
               cm(j) = cpsmj(k)/hesmj(k)	
               sm(j) = spsmj(k)/hesmj(k)	
               wm(j) = wsmj(k)	
c	
            enddo	
c	
            wi = wsmi(i)	
c	
            call polint(wm, cm, 3, wi, ci, cerr)	
            call polint(wm, sm, 3, wi, si, serr)	
c	
            if (dabs(ci).gt.0.d0) then	
               bipsmi(i) = datan2(si,ci)	
            else if (bipsmi(i).gt.0.d0) then	
               bipsmi(i) = pi*0.5d0	
            else	
               bipsmi(i) = pi*1.5d0	
            endif	
            if (bipsmi(i).lt.0.d0) bipsmi(i) = bipsmi(i) + 2.d0*pi	
            biasmi(i) = dsqrt(ci*ci + si*si)*hesmi(i)	
c	
         enddo	
c	
c -----< Calculation of tidal height >-----	
c	
         height = 0.d0	
c	
         do i = 1,nwsmj	
            height = height + biasmj(i)*dcos(argsmj(i) - bipsmj(i))	
         enddo	
c	
         do i = 1,nwsmi	
            height = height + biasmi(i)*dcos(argsmi(i) - bipsmi(i))	
         enddo	
c	
      else	
c	
         height = undef	
c	
      endif	
c	
      return	
      end	
c	
c$mjdymd	
c---------------------------------------------------------------------	
      subroutine mjdymd(xmjd  , iy    , im    , id    , ih    ,	
     +                  imin  , isec  , iflag                  )	
c---------------------------------------------------------------------	
c	
c xmjd  : modified julian date	
c iy    : year	
c im    : month	
c id    : day	
c ih    : hour	
c imin  : minute	
c isec  : second	
c iflag : 1 -> YMDHMS to MJD	
c         2 -> MJD to YMDHMS	
c Date must be within the years Mar. 1, 1900 to Feb. 28, 2100	
c	
      implicit double precision (a-h,o-z)	
c	
      parameter ( xjd0 = 2400000.5d0 )	
      parameter ( half =       0.5d0 )	
c	
c -----< YMDHMS to MJD >-----	
c	
      if (iflag.eq.1) then	
c	
         y = dfloat(iy - 1)	
c	
         if (im.gt.2) then	
            m = im	
            y = y + 1	
         else	
            m = im + 12	
         endif	
c	
         xjd  = int(365.25d0*y) + int(30.6001d0*(m+1)) - 15	
     +        + 1720996.5d0     + id	
         xmjd = xjd - xjd0	
c	
         fsec = dfloat(ih)*3600.d0 + dfloat(imin)*60.d0 + dfloat(isec)	
c	
         xmjd = xmjd + fsec/86400.d0	
c	
c -----< MJD to YMDHMS >-----	
c	
      else if (iflag.eq.2) then	
c	
         mjd  = xmjd	
         xjd  = dfloat(mjd) + xjd0	
         c    = int(xjd + half) + 1537	
         nd   = int((c - 122.1d0)/365.25d0 )	
         e    = int(365.25d0*nd)	
         nf   = int((c - e)/30.6001d0)	
c     	
         ifr  = int(xjd + half)	
         frc  = xjd + half - dfloat(ifr) 	
         id   = c - e - int(30.6001d0*nf) + frc	
         im   = nf - 1 - 12*int(nf/14)	
         iy   = nd - 4715 - int((7+im)/10)	
c	
         sec  = (xmjd-dfloat(mjd))*86400.d0	
         isec = sec	
         if ((sec-isec).gt.0.5d0) isec = isec + 1	
         ih   = isec/3600	
         imin = (isec - ih*3600)/60	
         isec = isec - ih*3600 - imin*60	
c	
      else	
c	
         print*,'!!! Error in <mjdymd>. iflag should be 1 or 2.'	
         stop	
c	
      endif	
c	
      return	
      end	
c	
c$polint	
c----------------------------------------------------------------	
      subroutine polint(xa, ya, n, x, y, dy)	
c----------------------------------------------------------------	
c	
c From : Numerical Recipes [Fortran]	
c Date : 1996.09.07	
c	
      implicit double precision(a-h,o-z)	
c	
      parameter (nmax = 10)	
c	
      dimension xa(n), ya(n), c(nmax), d(nmax)	
c	
      ns  = 1	
      dif = dabs(x-xa(1))	
c	
      do i = 1,n	
         dift = dabs(x-xa(i))	
         if (dift.lt.dif) then	
            ns  = i	
            dif = dift	
         endif	
         c(i) = ya(i)	
         d(i) = ya(i)	
      enddo	
c	
      y  = ya(ns)	
      ns = ns - 1	
c	
      do m = 1, n-1	
         do i = 1, n-m	
c	
            ho  = xa(i)   - x	
            hp  = xa(i+m) - x	
            w   = c(i+1) - d(i)	
            den = ho - hp	
c	
            if (den.eq.0.d0) pause	
c	
            den  = w/den	
            d(i) = hp*den	
            c(i) = ho*den	
c	
         enddo	
c	
         if (2*ns.lt.n-m) then	
            dy = c(ns+1)	
         else	
            dy = d(ns)	
            ns = ns - 1	
         endif	
c	
         y = y + dy	
c	
      enddo	
c	
      return	
      end	
c	
c$rdcmp	
c----------------------------------------------------------------	
      subroutine rdcmp(iu    , amp   , phs   , mend  , nend  ,	
     +                 mmax  , nmax  , fmt   , iamp  , iphs  ,	
     +                 aunit , punit  )	
c----------------------------------------------------------------	
c	
      implicit double precision (a-h,o-z)	
c	
      parameter (kc = 10)	
c	
      dimension amp(mmax,nmax), phs(mmax,nmax)	
      dimension iamp(mmax)    , iphs(mmax)	
      character fmt*6	
c	
c -----< Reading loop >-----	
c	
      kend = mend/kc	
      krem = mod(mend,kc)	
c	
      do n = 1,nend	
c	
         do k = 1,kend	
c	
            m1 = (k-1)*kc + 1	
            m2 = m1 + kc - 1	
            read(iu,fmt) (iamp(m),m=m1,m2)	
c	
         enddo	
c	
         if (krem.ne.0) then	
c	
            m1 = kend*kc + 1	
            m2 = kend*kc + krem	
            read(iu,fmt) (iamp(m),m=m1,m2)	
c	
         endif	
c	
         do k = 1,kend	
c	
            m1 = (k-1)*kc + 1	
            m2 = m1 + kc - 1	
            read(iu,fmt) (iphs(m),m=m1,m2)	
c	
         enddo	
c	
         if (krem.ne.0) then	
c	
            m1 = kend*kc + 1	
            m2 = kend*kc + krem	
            read(iu,fmt) (iphs(m),m=m1,m2)	
c	
         endif	
c	
         do m = 1,mend	
c	
            amp(m,n) = dfloat(iamp(m))*aunit  ! in centimeters	
            phs(m,n) = dfloat(iphs(m))*punit  ! in degrees	
c	
         enddo	
c	
      enddo	
c	
      close(iu)	
c	
      return	
      end	
c	
c$rdhead	
c----------------------------------------------------------------	
      subroutine rdhead(iu    , name  , wave  , date  , xmin  ,	
     +                  xmax  , ymin  , ymax  , dx    , dy    ,	
     +                  mend  , nend  , ideff , fmt   , aunit ,	
     +                  punit                                  )	
c----------------------------------------------------------------	
c	
      implicit double precision (a-h,o-z)	
c	
      character fmt*6, wave*3, name*50, date*50, buf*50	
c	
      read(iu,'(13x,a50)') name	
      read(iu,'(13x,a3 )') wave	
      read(iu,'(13x,f5.3,19x,f4.2)') aunit,punit	
      read(iu,'(13x,a50)') date	
      read(iu,'(7x,f7.2,3(9x,f7.2))') xmin,xmax,ymin,ymax	
      read(iu,'(12x,i2,14x,i2,2(9x,i7))') idx,idy,mend,nend	
      read(iu,'(16x,i6,11x,a6)') ideff, fmt	
c	
      if (idx.eq.50) then	
         dx = 0.5d0	
         dy = 0.5d0	
      else	
         dx = 1.d0/dfloat(idx)	
         dy = 1.d0/dfloat(idy)	
      endif	
c	
      return	
      end	
c	
c$rdmap	
c------------------------------------------------------------	
      subroutine rdmap(iu    , c     , s     , dx    , dy    ,	
     +                 mmax  , nmax  , nwave , xmin  , ymax  ,	
     +                 mend  , nend  , fmap  , undef , amp0  ,	
     +                 phs0  , iwa   , iwp   , iwave         )	
c------------------------------------------------------------	
c	
      implicit double precision (a-h,o-z)	
c	
      common /const/  pi , rad, deg	
c	
      dimension c(mmax,nmax,nwave), s(mmax,nmax,nwave)	
      dimension amp0(mmax,nmax), phs0(mmax,nmax)	
      dimension iwa(mmax), iwp(mmax)	
c	
      character    fmt*6, wave*3, name*50, date*50	
      character*80 fmap	
c	
      open(iu,file=fmap,status='old',err=98)	
c	
      call chop(fmap,ic)	
      print*,'Reading : ',fmap(1:ic)	
c	
      call rdhead(iu    , name  , wave  , date  , xmin  ,	
     +            xmax  , ymin  , ymax  , dx    , dy    ,	
     +            mend  , nend  , ideff , fmt   , aunit ,	
     +            punit                                  )	
c	
      write(6,6002) name	
 6002 format('   Model name   = ',a50)	
      write(6,6003) date	
 6003 format('   Created date = ',a50)	
      write(6,101) xmin, xmax, ymin, ymax	
      write(6,102) dx, dy, mend, nend	
      write(6,103) aunit, punit	
 101     format(4x,'xmin = ',f6.2,', xmax = ',f6.2,', ymin = ',f6.2,	
     +             ', ymax = ',f6.2)	
 102     format(4x,'dx   = ',f6.3,', dy =   ',f6.3,', mend = ',i4,	
     +             '  , nend = ',i4)	
 103     format(4x,'amplitude unit = ',f6.3,', phase unit =  ',f6.3)	
c	
      undef = dfloat(ideff)*aunit	
c	
      call rdcmp(iu    , amp0  , phs0  , mend  , nend  ,	
     +           mmax  , nmax  , fmt   , iwa   , iwp   ,	
     +           aunit , punit  )	
c	
      do n = 1,nend	
         do m = 1,mend	
            if (amp0(m,n).lt.undef) then	
               c(m,n,iwave) = amp0(m,n)*dcos(phs0(m,n)*rad)	
               s(m,n,iwave) = amp0(m,n)*dsin(phs0(m,n)*rad)	
            else	
               c(m,n,iwave) = undef	
               s(m,n,iwave) = undef	
            endif	
         enddo	
      enddo	
c	
      close (iu)	
c	
      return	
c	
 98   print*,'Error : Can not open ',fmap	
      print*,'Check <omapdir> in subroutine <naotidej>.'	
      stop	
c	
 99   return	
      end	
c	
c$setaw	
c------------------------------------------------------------------	
      subroutine setaw(nwave , xarg  , f     , r36525, arg   , w     )	
c------------------------------------------------------------------	
c	
      implicit double precision (a-h,o-z)	
c	
      common /astrov/ iagsmj(7,16) , eqasmj(16),	
     +                iagsmi(7,33) , eqasmi(33),	
     +                iaglmj(7, 7) , eqalmj( 7),	
     +                iaglmi(7, 5) , eqalmi( 5),	
     +                fr(3,6)      , etmut(130)	
      common /const/  pi , rad, deg	
c	
      dimension arg(nwave), w(nwave)	
      dimension xarg(7,33), f(6)	
c	
      do j = 1,nwave	
c	
         temp = f(1)*xarg(1,j) + f(2)*xarg(2,j) + f(3)*xarg(3,j)	
     +        + f(4)*xarg(4,j) + f(5)*xarg(5,j) + f(6)*xarg(6,j)	
     +        +    xarg(7,j)	
         temp = dmod(temp,360.d0)	
         if (temp.lt.0.d0) temp = temp + 360.d0	
c     	
         arg(j) = temp*rad      ! in radian	
c	
         ftau = 360.d0/r36525 - fr(2,2) + fr(2,3)	
         temp = ftau*xarg(1,j)    + fr(2,2)*xarg(2,j)	
     +        + fr(2,3)*xarg(3,j) + fr(2,4)*xarg(4,j)	
     +        + fr(2,5)*xarg(5,j) + fr(2,6)*xarg(6,j)	
         temp = temp*r36525	
c     	
         w(j) = temp*rad/86400.d0 ! in rad/sec	
c	
      enddo	
c	
      return	
      end	
c	
c$vset	
c------------------------------------------------------------------	
      block data vset	
c------------------------------------------------------------------	
c	
c* TD - UT values are stored in 'etmut'.	
c  They are currently filled up until 2030, but they are not	
c  correct beyond 1997. It is preferable to replace them by	
c  correct values when they are published.	
c	
      implicit double precision (a-h,o-z)	
c	
      common /astrov/ iagsmj(7,16) , eqasmj(16),	
     +                iagsmi(7,33) , eqasmi(33),	
     +                iaglmj(7, 7) , eqalmj( 7),	
     +                iaglmi(7, 5) , eqalmi( 5),	
     +                fr(3,6)      , etmut(130)	
      common /const/  pi , rad, deg	
      common /wave/   wns(16), wnl(7)	
c	
      character*3 wns, wnl	
c	
c	
c Major diurnal 	
c	
      data ((iagsmj(i,j),i=1,7),j=1,7)	
     +         /1,-2, 0, 1, 0, 0,-90, ! Q1       1	
     +          1,-1, 0, 0, 0, 0,-90, ! O1       2	
     +          1, 0, 0, 1, 0, 0, 90, ! M1       3	
     +          1, 1,-2, 0, 0, 0,-90, ! P1       4	
     +          1, 1, 0, 0, 0, 0, 90, ! K1       5	
     +          1, 2, 0,-1, 0, 0, 90, ! J1       6	
     +          1, 3, 0, 0, 0, 0, 90/ ! OO1      7	
c               m  s  h  p  n  ps	
c	
c Major semi-diurnal 	
c	
      data ((iagsmj(i,j),i=1,7),j=8,16)	
     +         /2,-2, 0, 2, 0, 0,  0, ! 2N2      8	
     +          2,-2, 2, 0, 0, 0,  0, ! Mu2      9	
     +          2,-1, 0, 1, 0, 0,  0, ! N2      10	
     +          2,-1, 2,-1, 0, 0,  0, ! Nu2     11	
     +          2, 0, 0, 0, 0, 0,  0, ! M2      12	
     +          2, 1, 0,-1, 0, 0,180, ! L2      13	
     +          2, 2,-3, 0, 0, 1,  0, ! T2      14	
     +          2, 2,-2, 0, 0, 0,  0, ! S2      15	
     +          2, 2, 0, 0, 0, 0,  0/ ! K2      16	
c               m  s  h  p  n  ps	
c	
c Diurnal Minor 17	
      data ((iagsmi(i,j),i=1,7),j=1,17)	
     +         /1,-3, 0, 2, 0, 0,-90, ! 2Q1     1	
     +          1,-3, 2, 0, 0, 0,-90, ! Sigma1  2	
     +          1,-2, 0, 1,-1, 0,-90, ! Q1'     3	
     +          1,-2, 2,-1, 0, 0,-90, ! Rho1    4	
     +          1,-1, 0, 0,-1, 0,-90, ! O1'     5	
     +          1,-2, 2, 0, 0, 0, 90, ! Tau1    6	
     +          1, 0, 0, 1, 1, 0, 90, ! M1'     7	
     +          1, 0, 2,-1, 0, 0, 90, ! Kai1    8	
     +          1, 1,-3, 0, 0, 1,-90, ! Pi1     9	
     +          1, 1,-2, 0,-1, 0, 90, ! P1'     10	
     +          1, 1, 0, 0,-1, 0,-90, ! K1'     11	
     +          1, 1, 0, 0, 1, 0, 90, ! K1'     12	
     +          1, 1, 1, 0, 0,-1, 90, ! Psi1    13	
     +          1, 1, 2, 0, 0, 0, 90, ! Phi1    14	
     +          1, 2,-2, 1, 0, 0, 90, ! Theta1  15	
     +          1, 2, 0,-1, 1, 0, 90, ! J1'     16	
     +          1, 3, 0, 0, 1, 0, 90/ ! OO1'    17	
c               m  s  h  p  n  ps	
c	
c Semi-diurnal minor 16	
      data ((iagsmi(i,j),i=1,7),j=18,33)	
     +         /2,-3, 2, 1, 0, 0,  0, ! Eps.2   18	
     +          2,-2, 2, 0,-1, 0,180, ! Mu2'    19	
     +          2,-1, 0, 1,-1, 0,180, ! N2'     20	
     +          2,-1, 2,-1,-1, 0,180, ! Nu2'    21	
     +          2, 0,-2, 2, 0, 0,180, ! Gamma2  22	
     +          2, 0,-1, 0, 0, 1,180, ! Alpha2  23	
     +          2, 0, 0, 0,-1, 0,180, ! M2'     24	
     +          2, 0, 1, 0, 0,-1,  0, ! Beta2   25	
     +          2, 0, 2, 0, 0, 0,  0, ! Delata2 26	
     +          2, 1,-2, 1, 0, 0,180, ! Lambda2 27	
     +          2, 2,-2, 0,-1, 0,  0, ! S2'     28	
     +          2, 2,-1, 0, 0,-1,180, ! R2      29	
     +          2, 2, 0, 0, 1, 0,  0, ! K2'     30	
     +          2, 3,-2, 1, 0, 0,  0, ! Zeta2   31	
     +          2, 3, 0,-1, 0, 0,  0, ! Eta2    32	
     +          2, 3, 0,-1, 1, 0,  0/ ! Eta2'   33	
c               m  s  h  p  n  ps	
c	
c Major long period	
c	
      data ((iaglmj(i,j),i=1,7),j=1,7)	
     +         /0, 3, 0,-1, 0, 0,  0, ! Mtm     1	
     +          0, 2, 0, 0, 0, 0,  0, ! Mf      2	
     +          0, 2,-2, 0, 0, 0,  0, ! MSf     3	
     +          0, 1, 0,-1, 0, 0,  0, ! Mm      4	
     +          0, 1,-2, 1, 0, 0,  0, ! MSm     5	
     +          0, 0, 2, 0, 0, 0,  0, ! Ssa     6	
     +          0, 0, 1, 0, 0,-1,  0/ ! Sa      7	
c               m  s  h  p  n  ps	
c	
c Long-period nodal modulations	
      data ((iaglmi(i,j),i=1,7),j=1,5)	
     +         /0, 3, 0,-1, 1, 0,  0, ! Mtm'    1	
     +          0, 2, 0, 0, 1, 0,  0, ! Mf'     2	
     +          0, 1, 0,-1, 1, 0,180, ! Mm'     3	
     +          0, 1, 0,-1,-1, 0,180, ! Mm'     4	
     +          0, 0, 2, 0, 1, 0,180/ ! Ssa'    5	
c               m  s  h  p  n  ps	
c	
c	
      data fr/280.4606184d0,  36000.7700536d0,  0.00038793d0,	
     +        218.3166560d0, 481267.8813420d0, -0.00133000d0,	
     +        280.4664490d0,  36000.7698220d0,  0.00030360d0,	
     +         83.3532430d0,   4069.0137110d0, -0.01032400d0,	
     +        234.9554440d0,   1934.1361850d0, -0.00207600d0,	
     +        282.9373480d0,      1.7195330d0,  0.00045970d0/	
c	
c	
      data eqasmj/0.072136d0, 0.376763d0, 0.029631d0, 0.175307d0, ! 1- 4	
     +            0.529876d0, 0.029630d0, 0.016212d0, 0.023009d0, ! 5- 8	
     +            0.027768d0, 0.173881d0, 0.033027d0, 0.908184d0, ! 9-12	
     +            0.025670d0, 0.024701d0, 0.422535d0, 0.114860d0/ !13-16 	
c	
      data eqasmi/0.009545d0, 0.011520d0, 0.013607d0, 0.013702d0, ! 1- 4	
     +            0.071081d0, 0.004914d0, 0.005946d0, 0.005667d0, ! 5- 8	
     +            0.010251d0, 0.001973d0, 0.010492d0, 0.071886d0, ! 9-12	
     +            0.004145d0, 0.007545d0, 0.005666d0, 0.005875d0, !13-16	
     +            0.010385d0, 0.006709d0, 0.001037d0, 0.006484d0, !17-20	
     +            0.001232d0, 0.002728d0, 0.003123d0, 0.033885d0, !21-24	
     +            0.002749d0, 0.001066d0, 0.006697d0, 0.000946d0, !25-28	
     +            0.003536d0, 0.034240d0, 0.001228d0, 0.006422d0, !29-32	
     +            0.002799d0/                                     !33	
c	
      data eqalmj/0.029926d0, 0.156303d0, 0.013695d0, 0.082569d0, ! 1- 4	
     +            0.015791d0, 0.072732d0, 0.011549d0/             ! 5- 7	
c	
      data eqalmi/0.012405d0, 0.064805d0, 0.005358d0, 0.005419d0, ! 1- 4	
     +            0.001799d0/                                     ! 5	
c	
      data (etmut(i),i=1,50)        !1901-1950	
     +           / 1.7D0,    2.9D0,    4.0D0,    5.2D0,    6.3D0,	
     +             7.5D0,    8.6D0,    9.7D0,   10.9D0,   12.1D0,	
     +            13.4D0,   14.6D0,   15.7D0,   16.8D0,   17.8D0,	
     +            18.7D0,   19.6D0,   20.4D0,   21.1D0,   21.7D0,	
     +            22.2D0,   23.0D0,   22.9D0,   23.4D0,   23.7D0,	
     +            23.9D0,   23.9D0,   23.5D0,   23.7D0,   24.0D0,	
     +            24.1D0,   24.4D0,   24.2D0,   24.4D0,   24.3D0,	
     +            24.2D0,   24.2D0,   24.6D0,   24.4D0,   24.6D0,	
     +            25.5D0,   25.5D0,   26.4D0,   26.7D0,   26.9D0,	
     +            27.4D0,   28.2D0,   28.5D0,   29.2D0,   29.9D0/	
      data (etmut(i),i=51,100)      !1951-2000	
     +           /30.0D0,   30.6D0,   31.0D0,   31.3D0,   31.23D0,	
     +            31.50D0,  31.92D0,  32.43D0,  32.91D0,  33.37D0,	
     +            33.78D0,  34.246D0, 34.735D0, 35.403D0, 36.151D0,	
     +            37.000D0, 37.887D0, 38.756D0, 39.708D0, 40.710D0,	
     +            41.689D0, 42.825D0, 43.961D0, 44.998D0, 45.986D0,	
     +            47.000D0, 48.038D0, 49.105D0, 50.105D0, 50.981D0,	
     +            51.817D0, 52.578D0, 53.438D0, 54.090D0, 54.640D0,	
     +            55.117D0, 55.585D0, 56.098D0, 56.574D0, 57.227D0,	
     +            57.962D0, 58.545D0, 59.590D0, 60.406D0, 61.250D0,	
     +            61.980D0, 62.638D0, 63.284D0, 63.664D0, 64.600D0/	
      data (etmut(i),i=101,130)     !2001-2030	
     +           /65.000D0, 65.000D0, 66.000D0, 67.000D0, 67.000D0,	
     +            68.000D0, 69.000D0, 69.000D0, 70.000D0, 71.000D0,	
     +            71.000D0, 72.000D0, 73.000D0, 73.000D0, 74.000D0,	
     +            74.000D0, 75.000D0, 76.000D0, 76.000D0, 77.000D0,	
     +            78.000D0, 78.000D0, 79.000D0, 80.000D0, 80.000D0,	
     +            81.000D0, 82.000D0, 82.000D0, 83.000D0, 84.000D0/	
c	
c	
      data pi      /3.14159265358979d0/	
      data rad     /1.745329251994329d-2/	
      data deg     /5.729577951308232d+1/	
c	
c	
      data wns     /'q1 ','o1 ','m1 ','p1 ','k1 ','j1 ','oo1','2n2',	
     +              'mu2','n2 ','nu2','m2 ','l2 ','t2 ','s2 ','k2 '/	
      data wnl     /'mtm','mf ','msf','mm ','msm','ssa','sa '      /	
c	
      end	
c	
c ----------------------< End of program >----------------------	
c \(^_^)/ \(^o^)/ \(^_^)/ \(^o^)/ \(^_^)/ \(^o^)/ \(^_^)/ \(^o^)/	
