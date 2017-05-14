pacman for Mac OS X.

There are [Mac Ports][macports] and [Homebrew][homebrew], and other package management for Mac OS X.  
However, as a [pre-Archer][arch], consider [pacman][pacman] the fastest package management utilities.

For most of [packages][packages] in Arch Linux, or [AUR][aur], should be support in Mac OS X.  
However, there may be changed, for example, Arch Linux install to `/usr` and `/etc` instead of `/usr/local`.

Howto install?

1. (optional) define SRCDEST, PKGDEST, PACKAGER in `~/.bash_profile`.  

		export SRCDEST=$HOME/pacman/sources
		export PKGDEST=$HOME/pacman/packages
		# export PACKAGER="John Doe <john@doe.com>"

2. just run `bootstrap/bootstrap.sh`, which will install `pacman` to `/tmp/bootsrap`.

3. then you can `makepkg -i` like in [Arch Linux][arch] now.

[macports]: http://www.macports.org "Mac Ports"
[homebrew]: http://homebrew.sh "Homebrew"
[arch]: https://www.archlinux.org "Arch Linux"
[pacman]: https://www.archlinux.org/pacman "Package manager from Arch Linux" 
[packages]: https://www.archlinux.org/packages "Packages in Arch Linux"
[aur]: https://aur.archlinux.org/ "Arch User Repository"
