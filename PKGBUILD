# Maintainer: Vikyek <https://github.com/Vikyek>
pkgname=agv-dispatcher
pkgver=1.0.0
pkgrel=1
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

    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
