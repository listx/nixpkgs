{ stdenv, fetchurl, m4, perl, gfortran, texlive, ffmpeg, tk
, imagemagick, liblapack, python, openssl, libpng
, which
}:

stdenv.mkDerivation rec {
  name = "sage-7.3";

  src = fetchurl {
    url = "mirror://sagemath/${name}.tar.gz";
    sha256 = "0aash14cv4ayk4aqg954jm59fs76p8zjsx88whvr57mx4iym7rm6";
  };

  buildInputs = [ m4 perl gfortran texlive.combined.scheme-basic ffmpeg tk imagemagick liblapack
                  python openssl libpng which];

  patches = [ ./spkg-singular.patch ./spkg-python.patch ./spkg-git.patch ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  preConfigure = ''
    export SAGE_NUM_THREADS=$NIX_BUILD_CORES
    export SAGE_ATLAS_ARCH=fast
    mkdir -p $out/sageHome
    export HOME=$out/sageHome
    export CPPFLAGS="-P"
  '';

  preBuild = "patchShebangs build";

  installPhase = ''DESTDIR=$out make'';

  meta = {
    homepage = "http://www.sagemath.org";
    description = "A free open source mathematics software system";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
