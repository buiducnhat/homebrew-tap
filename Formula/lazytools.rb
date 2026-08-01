class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.1.0/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "070fbd119319de38bfd594140a3179aab29fc37017029bf5d738519ae45f759c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.1.0/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "cecab97438f3782fa6737e69c22e494f68dab8bf2f16f840b9a77d2f98a4a5fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.1.0/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ed6670be6f4f9ab68099eb55ce31f78d4d7e114f5d6b8076706c18e9c5d6678"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.1.0/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a54ceaba917350a7db9176e7e7d693486a1cc546911c307a33fc34c404d4bed3"
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
