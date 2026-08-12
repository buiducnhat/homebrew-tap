class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.3/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "4691b466261214524cb45074167088a3fa441c8c1a89e1919905c9aad32042e4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.3/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "60de483d883f7bc5ba33b616dd5ffd8c840ea73de3bc46caeb53b3b207fee013"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.3/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bbbdada7d9dd0b4e8f75cefd14a16bc529d368d39952bf071bb25835fee16fa7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.5.3/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6be3795298916ffaef25a87551a8fbcab8996b0fab6a05a5c7a66f94cda39e08"
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
