require 'formula'

class Optipng < Formula
  url 'http://downloads.sourceforge.net/project/optipng/OptiPNG/optipng-0.7.1/optipng-0.7.1.tar.gz'
  homepage 'http://optipng.sourceforge.net/'
  md5 'b6181d566998ad489397b985ebfc4a03'

  def install
    system "./configure", "--with-system-zlib", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
