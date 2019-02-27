class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/v0.29.1.tar.gz"
  sha256 "f9f9d461d1990f9728660b4ccb0e8cb5dce29ccaa6af567bec481b79291ca623"
  revision 3
  head "https://github.com/mpv-player/mpv.git"

  bottle :unneeded
  
  option "with-lua", "Enable lua support"
  option "with-javascript", "Enable javascript support"

  depends_on "docutils" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  depends_on "circleapps/ffmpeg/ffmpeg"
  depends_on "jpeg"
  #depends_on "libarchive"
  #depends_on "youtube-dl"
  

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

      # --disable-cplugins
    
    args = %W[
      --prefix=#{prefix}
      --enable-libmpv-shared
      --disable-libarchive
      --disable-libass
      --disable-libass-osd
      --disable-lua
      --disable-javascript
      --disable-uchardet
      --disable-lcms2
      --disable-vapoursynth
      --disable-vapoursynth-lazy
      --disable-libbluray
      --confdir=#{etc}/mpv
      --datadir=#{pkgshare}
      --mandir=#{man}
      --docdir=#{doc}
      --zshdir=#{zsh_completion}
    ]

    system "./bootstrap.py"
    system "python3", "waf", "configure", *args
    system "python3", "waf", "install"

    system "python3", "TOOLS/osxbundle.py", "build/mpv"
    prefix.install "build/mpv.app"
  end

  test do
    system bin/"mpv", "--ao=null", test_fixtures("test.wav")
  end
end
