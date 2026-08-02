class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.1/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "c971fe8a219a5402a1f1a6d91d93228e256fe6d798fdee9af6105d6416624eb6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.1/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "7ddfe9d6892b514055f9504e52ccdb432414b5884f85c5c1d587da03b4f424d1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.1/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1fc33f05609721a4628ba9eaa66e208d759b155bf2a75632a4a6d01b4d843daf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.1/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6d76fd33a1ae7614be5861d5814cd460af42556d038d7cf7f8e249775f37979"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "lazytools" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazytools" if OS.mac? && Hardware::CPU.intel?
    bin.install "lazytools" if OS.linux? && Hardware::CPU.arm?
    bin.install "lazytools" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
