require 'formula'

class Wireshark < Formula
  homepage 'http://www.wireshark.org'
  url 'http://wiresharkdownloads.riverbed.com/wireshark/src/wireshark-1.10.2.tar.bz2'
  mirror 'http://www.wireshark.org/download/src/wireshark-1.10.2.tar.bz2'
  sha1 '1f8f877f17dea23e1cf2bafeef0f71323df43521'

  head 'http://anonsvn.wireshark.org/wireshark/trunk/', :using => :svn

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  option 'with-x', 'Include X11 support'
  option 'with-qt', 'Use QT for GUI instead of GTK+'

  depends_on 'pkg-config' => :build

  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libgcrypt'

  depends_on 'geoip' => :recommended

  depends_on 'c-ares' => :optional
  depends_on 'lua' => :optional
  depends_on 'pcre' => :optional
  depends_on 'portaudio' => :optional
  depends_on 'qt' => :optional

  if build.with? 'x'
    depends_on :x11
    depends_on 'gtk+'
  end

  def install
    system "./autogen.sh" if build.head?

    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-gnutls",
            "--with-ssl"]

    args << "--disable-warnings-as-errors" if build.head?
    args << "--disable-wireshark" unless build.with? "x" or build.with? "qt"
    args << "--disable-gtktest" unless build.with? "x"
    args << "--with-qt" if build.with? "qt"

    system "./configure", *args
    system "make"
    ENV.deparallelize # parallel install fails
    system "make install"
  end

  def caveats; <<-EOS.undent
    If your list of available capture interfaces is empty
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
      tar zxvf ChmodBPF.tar.gz
      open ChmodBPF/Install\\ ChmodBPF.app

    This adds a launch daemon that changes the permissions of your BPF
    devices so that all users in the 'admin' group - all users with
    'Allow user to administer this computer' turned on - have both read
    and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end
end
