class Liblognorm < Formula
  desc "Log normalizing library"
  homepage "http://www.liblognorm.com/"
  url "http://www.liblognorm.com/files/download/liblognorm-2.0.5.tar.gz"
  sha256 "c8151da83b21031f088bb2a8ea674e4f7ee58551829e985028245841330db190"

  depends_on "pkg-config" => :build
  depends_on "libestr"

  resource "libfastjson" do
    url "http://download.rsyslog.com/libfastjson/libfastjson-0.99.8.tar.gz"
    sha256 "3544c757668b4a257825b3cbc26f800f59ef3c1ff2a260f40f96b48ab1d59e07"
  end

  def install
    resource("libfastjson").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "stdio.h"
      #include <lliblognorm.h>
      int main() {
      printf("%s\\n", ln_version());
      return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llognorm", "-o", "test"
    system "./test"
  end
end
