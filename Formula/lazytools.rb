class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.0/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "f1f7d9cad6e5b1dd26b6bcbcd5d681ebc35b39359d4036c197dce08a674f0f11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.0/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "6900304d4f688a97cc347ed2d98db56a2b76796600c6fb4aa50216e569f1955a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.0/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e011ce8d0840ddc400458651e418ccfb6e8d8251c9c747cf6e68cc59eb82bc31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.0/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a33c56954c3f2ecc14b107e13da8f126900adf3b0e3dfe78487d5c0bec976ec"
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
