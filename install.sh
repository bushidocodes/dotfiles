#!/usr/bin/env bash

source "./utils.sh"

declare -A options=(
	["verbose"]=false
)

process_flags() {
	while true; do
		case $1 in
			-h | --help)
				echo "./install.sh"
				echo "-v | --verbose > Run Installation Verbose"
				echo "-h | --help    > Help"
				exit 0
				;;
			-v | --verbose)
				options["verbose"]=true
				;;
			*)
				break
				;;
		esac
		shift
	done
}

update_modules() {
	${options["verbose"]} && banner "Upgrading Apt Packages"

	sudo apt-get update --yes         # Update Aptitude Repositories
	sudo apt-get upgrade --yes        # Upgrade Aptitude Packages
	sudo apt-get install software-properties-common --yes # Install PPA Dependencies
}

link_dotfiles() {
	${options["verbose"]} && banner "Linking Dotfiles"

	# Ensure paths and files are in place to allow dotbot to link correctly
	# If any of thse files are NOT symlinks, blow them away
	rm -f ~/.profile ~/.bashrc ~/.bash_logout ~/.gitconfig ~/.zshrc ~/.zsh_plugins.txt ~/.zprofile
	[ ! -d "$HOME/.cargo" ] && mkdir ~/.cargo

	BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	DOTBOT_DIR="dotbot"
	DOTBOT_BIN="bin/dotbot"
	CONFIG="install.conf.yaml"
	cd "${BASEDIR}" || exit 1
	git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
	git submodule update --init --recursive "${DOTBOT_DIR}"
	"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" #"${@}"
}

config_git() {
	${options["verbose"]} && banner "Configuring Git"

	email="spmcbride1201@gmail.com"
	fullname="Sean McBride"

	if [[ -n "$email" && -n "$fullname" ]]; then
		git config --global user.name "$fullname"
		git config --global user.email "$email"
	fi
}

install_misc_packages() {
	${options["verbose"]} && banner "Installing Various Dev Tools from Apt"

	sudo apt-get install fonts-firacode --yes # Fira Code for X Window Apps
	sudo apt-get install vim --yes # VIM
	sudo apt-get install curl --yes # Curl
	sudo apt-get install httpie --yes # HTTPie
	sudo apt-get install apache2-utils --yes # Apache Bench
	sudo apt-get install qemu --yes # QEMU
	sudo apt-get install autoconf --yes
	sudo apt-get install automake --yes
	sudo apt-get install libtool --yes
	sudo apt-get install unzip --yes
}

install_c_cpp_tools() {
	${options["verbose"]} && banner "Installing C/C++ Tools"

	sudo apt-get install \
		gcc \
		gdb \
		g++ \
		glibc-doc \
		make \
		cmake \
		libtinfo5 \
		libboost-all-dev --yes
}

install_llvm() {
	${options["verbose"]} && banner "Installing LLVM Tools"

	LLVM_VERSION=13
	studo apt-get install clang-format-$LLVM_VERSION
	sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
	sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$LLVM_VERSION 100
	sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$LLVM_VERSION 100
	sudo apt-get install libc++-dev libc++abi-dev --yes # C++ Stdlib for LLVM
}

install_rust() {
	${options["verbose"]} && banner "Installing Rust"

	if [[ -x "$(command -v rustup)" ]]; then
		rustup update
	else
		# See flags and options with curl https://sh.rustup.rs -sSf | bash -s -- --help
		make ~/.cargo/bin/rustup
		source "$HOME/.cargo/env"
		export PATH="$HOME/.cargo/bin:$PATH"
	fi
	rustup component add rustfmt
	rustup component add clippy
}

install_go() {
	${options["verbose"]} && banner "Installing Go"

	if is_wsl; then
		sudo apt-get install golang-go
	elif is_native_ubuntu; then
		sudo snap install go --classic
	fi
	mkdir -p "$HOME/go"
	go env -w GOPATH="$HOME/go"
}

install_java() {
	${options["verbose"]} && banner "Installing Java"

	sudo apt-get install openjdk-17-jdk maven --yes
	make ~/.jenv

	jenv add /usr/lib/jvm/java-17-openjdk-amd64
	jenv global 17.0
}

install_python() {
	${options["verbose"]} && banner "Installing Python"

	# Python Build Dependencies
	sudo apt-get install build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev libncursesw5-dev libffi-dev uuid-dev --yes

	# I use pyenv to manage my tools https://github.com/pyenv/pyenv
	if pyenv --version | grep -q 'pyenv 1'; then
		echo "pyenv 1.x is already installed and in path"
	else
		echo "Installing Pyenv"
		curl https://pyenv.run | bash
		source ~/.bash_profile
		source ~/.bashrc
		pyenv install 3.7.5
		pyenv global 3.7.5
	fi

	if python3 --version | grep -q 'Python 3.7.5'; then
		echo "Python 3.7.5 is already installed and in path"
	else
		pyenv install 3.7.5
		pyenv global 3.7.5
	fi
}

install_nodejs() {
	${options["verbose"]} && banner "Installing Node.js"

	make ~/.local/share/pnpm/node
}

install_deno() {
	${options["verbose"]} && banner "Installing Deno"

	make ~/.deno/bin/deno
	export DENO_INSTALL="/home/sean/.deno"
	export PATH="$DENO_INSTALL/bin:$PATH"
}

install_assorted_npm_tools() {
	${options["verbose"]} && banner "Installing NPM Tools"

	# Simple HTTP Server. https://www.npmjs.com/package/http-server
	make ~/.local/share/pnpm/http-server

	# Netlify CLI. https://github.com/netlify/cli
	make ~/.local/share/pnpm/netlify

	# Fancy Kill. Nicer UX for killing processes
	make ~/.local/share/pnpm/fkill

}

install_bash_tools() {
	${options["verbose"]} && banner "Installing Bash Tools"

	# BATS, A Bash Unit Testing Framework
	make ~/.local/bin/bats
	make ~/.local/bin/shfmt
	make ~/.local/bin/shellcheck
}

install_exercism() {
	${options["verbose"]} && banner "Installing Exercism"
	cd ~ || exit
	make ~/.local/bin/exercism
	exercism upgrade
	make ~/.local/bin/configlet
}

install_wasmtime() {
	${options["verbose"]} && banner "Installing Wasmtime"
	make ~/.wasmtime/bin/wasmtime
}


install_latex() {
	${options["verbose"]} && banner "Installing LaTeX"

	sudo apt-get install texlive texlive-latex-extra --yes
	sudo apt-get install gnuplot --yes
}

cleanup() {
	${options["verbose"]} && banner "Cleaning Up"

	sudo apt-get autoremove -y
}

main() {

	process_flags "$@"
	while [[ $1 = -* ]]; do shift; done

	if ((${#@} == 0)); then
		update_modules
		link_dotfiles
		config_git
		install_misc_packages
		install_c_cpp_tools
		install_llvm
		install_rust
		# install_go
		install_java
		# install_python
		install_nodejs
		install_deno
		install_assorted_npm_tools
		install_bash_tools
		install_exercism
		install_wasmtime
		install_latex
		cleanup
	else
		for cmd in "$@"; do
			"$cmd"
		done
	fi
}

main "$@"
