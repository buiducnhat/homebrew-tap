class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.1/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "d29140c0e7160f11fcd3c3861c6758d074572defcc61810c1b5abbf069409cdf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.1/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "0b39b6bbd09d8b3d538863ecc3526a98849026bcaff135203ab705bb4ca657e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.1/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf58577dbed8990c91a6191b17ec56baa191fbdd7800f951b45633b34b1bdbae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.1/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ed97ab9ae526348d45509f9be34c4f48d3a60e8cd5e470dcec8198a9b5d18d5"
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
