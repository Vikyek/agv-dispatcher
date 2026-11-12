# Maintainer: Vikyek <https://github.com/Vikyek>
pkgname=agv-dispatcher
pkgver=1.0.0
pkgrel=2
pkgdesc="Token-efficient multi-agent task dispatcher & self-scaling orchestrator for Antigravity (AGY)"
arch=('any')
url="https://github.com/Vikyek/agv-dispatcher"
license=('MIT')
depends=('python' 'git')
optdepends=(
    'jules-vanager: Integration for Google Jules API session orchestration'
)
source=("$pkgname-$pkgver.tar.gz::$url/archive/refs/tags/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$pkgname-$pkgver"
    local plugin_dir="$pkgdir/usr/share/antigravity/plugins/$pkgname"
    install -d "$plugin_dir"

    cp -r plugin.json rules skills "$plugin_dir/"
    [ -f "SKILL.md" ] && cp -d SKILL.md "$plugin_dir/"
    [ -f "install.sh" ] && install -Dm755 install.sh "$plugin_dir/install.sh"

    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"

    # Install manpages
    if [ -f "man1/$pkgname.1" ]; then
        install -Dm644 "man1/$pkgname.1" "$pkgdir/usr/share/man/man1/$pkgname.1"
    fi
}
