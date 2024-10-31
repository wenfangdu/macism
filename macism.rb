class Macism < Formula
  desc "MacOS Input Source Manager"
  homepage "https://github.com/laishulu/macism"
  version "1.0.0"

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/laishulu/macism/releases/download/v#{version}/macism-arm64"
      sha256 "PLACE_HOLDER"
    else
      url "https://github.com/laishulu/macism/releases/download/v#{version}/macism-x86_64"
      sha256 "PLACE_HOLDER"
    end
  end

  def install
    bin.install "macism-arm64" => "macism" if OS.mac? && Hardware::CPU.arm?
    bin.install "macism-x86_64" => "macism" if OS.mac? && !Hardware::CPU.arm?
  end

  test do
    system "#{bin}/macism"
  end
end
