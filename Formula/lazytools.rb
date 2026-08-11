class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.2/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "8c5cb721958108479ec26c434da2bd1a40e3d903487ce70926898d5c603407bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.2/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "512ed5a5514966149714b5745adc22d35d7ab71df96e62f243a680c6d03fdf25"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.2/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d1d8e76f79b967153bde266d709c3948ed004d8e34a8fa5400489398b7a3306f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.2/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9d4ccb6b77223df871dfd1918b872ccb85f823d714ac544a8fcb4fd69a3ae83a"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "lazytools"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "lazytools"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "lazytools"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "lazytools"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
