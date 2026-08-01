class Lazytools < Formula
  desc "A terminal utility belt — offline, keyboard-first. TUI plus CLI subcommands in one binary."
  homepage "https://github.com/buiducnhat/lazytools"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.0/lazytools-aarch64-apple-darwin.tar.xz"
      sha256 "076b7c9b3409e0d7fce14d373cf79e382a009f249e1377202e4f8deb4c349b89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.0/lazytools-x86_64-apple-darwin.tar.xz"
      sha256 "a3be7212c439a3f7ed2302d2969867bd855c8f18ccf8021cd6c07ba46fb8f472"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.0/lazytools-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc512e5084ddd4b35ad4e8d95b262f93449fad5912574bd627234a8425b0736c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/buiducnhat/lazytools/releases/download/v0.2.0/lazytools-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fdf0cb573d1e2cb026eb0e4dc0912314e8b8dbe1d82170fb5503fadeed298849"
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
