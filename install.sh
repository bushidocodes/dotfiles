#!/usr/bin/env bash

source "./utils.sh"

update_modules() {
  sudo apt update --yes                             # Update Aptitude Repositories
  sudo apt upgrade --yes                            # Upgrade Aptitude Packages
  sudo apt install software-properties-common --yes # Install PPA Dependencies
}

link_dotfiles() {
  # set -e

  # Ensure paths and files are in place to allow dotbot to link correctly

  # If any of thse files are NOT symlinks, blow them away
  rm ~/.profile ~/.bashrc ~/.bash_logout ~/.gitconfig ~/.zshrc ~/.zsh_plugins.txt ~/.zprofile
  mkdir ~/.cargo
  mkdir -p ~/bin
  if is_wsl; then
    # We assume PowerShell installed Code by this point, so just set the settings file...
    export CODE_PATH="$HOME/winhome/AppData/Roaming/Code/User"
  elif is_native_ubuntu; then
    mkdir -p ~/.config/
    mkdir -p ~/.config/Code/
    mkdir -p ~/.config/Code/User/
    cp ~/.dotfiles/vscode_settings.json ~/winhome/AppData/Roaming/Code/User
  fi

  BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  DOTBOT_DIR="dotbot"
  DOTBOT_BIN="bin/dotbot"
  CONFIG="install.conf.yaml"

  cd "${BASEDIR}" || echo "Failed to cd into ${BASEDIR}" && exit 1
  git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${DOTBOT_DIR}"

  "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" #"${@}"
}

config_git() {
  email=""
  fullname=""

  if [[ -n "$email" && -n "$fullname" ]]; then
    git config --global user.name "$fullname"
    git config --global user.email "$email"
  fi
}

install_misc_packages() {
  sudo apt install fonts-firacode --yes # Fira Code for X Window Apps
  sudo apt install vim --yes            # VIM
  sudo apt install curl --yes           # Curl
  sudo apt install httpie --yes         # HTTPie
  sudo apt install apache2-utils --yes  # Apache Bench
  sudo apt install qemu --yes           # QEMU
  sudo apt install autoconf --yes
  sudo apt install automake --yes
  sudo apt install libtool --yes
  sudo apt install make --yes
  sudo apt install g++ --yes
  sudo apt install unzip --yes
}

install_c_cpp_tools() {
  sudo apt install gcc gdb g++ clang-format make libtinfo5 libopenmpi-dev --yes
}

install_llvm() {
  LLVM_VERSION=9
  sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
  sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-$LLVM_VERSION 100
  sudo update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-$LLVM_VERSION 100
  sudo apt install libc++-dev libc++abi-dev --yes # C++ Stdlib for LLVM
}

install_rust() {
  if [[ -x "$(command -v rustup)" ]]; then
    rustup update
  else
    # See flags and options with curl https://sh.rustup.rs -sSf | bash -s -- --help
    curl https://sh.rustup.rs -sSf | bash -s -- -y
    source "$HOME/.cargo/env"
    export PATH="$HOME/.cargo/bin:$PATH"
  fi
  rustup component add rustfmt
  rustup component add clippy
}

install_go() {
  if is_wsl; then
    sudo apt install golang-go
  elif is_native_ubuntu; then
    sudo snap install go --classic
  fi
  mkdir -p "$HOME/go"
  go env -w GOPATH="$HOME/go"
}

install_java() {
  sudo apt install openjdk-11-jdk openjdk-8-jdk maven --yes

  if [[ ! -d "$HOME/.jenv" ]]; then
    git clone https://github.com/gcuisinier/jenv.git ~/.jenv
    source ~/.bash_profile
    source ~/.bashrc
  fi

  jenv add /usr/lib/jvm/java-8-openjdk-amd64
  jenv add /usr/lib/jvm/java-11-openjdk-amd64
  jenv global 11.0
}

install_python() {
  # Python Build Dependencies
  sudo apt install build-essential libsqlite3-dev sqlite3 bzip2 libbz2-dev zlib1g-dev libssl-dev openssl libgdbm-dev libgdbm-compat-dev liblzma-dev libreadline-dev libncursesw5-dev libffi-dev uuid-dev --yes

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

install_ansible() {
  if [[ -x "$(command -v ansible)" ]]; then
    echo "Ansible installed and in path"
  else
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt update
    sudo apt install ansible --yes
  fi

  export ansible_python_interpreter=/usr/bin/python2
}

install_nodejs() {
  if [[ -x "$(command -v n)" ]]; then
    echo "n installed and in path"
    n-update -y
    source ~/.bash_profile
    source ~/.bashrc
  else
    # We use the -n argument because we have already configured our profile in our .dotfiles repo for n
    curl -L https://git.io/n-install | bash -s -- -n
    sudo chown -R "$USER":"$(id -gn "$USER")" /home/sean/.config
    source ~/.bash_profile
    source ~/.bashrc
  fi
}

install_assorted_npm_tools() {
  # Simple HTTP Server. https://www.npmjs.com/package/http-server
  if [[ ! -x "$(command -v http-server)" ]]; then
    npm i -g http-server
  fi

  # Netlify CLI. https://github.com/netlify/cli
  if [[ ! -x "$(command -v netlify)" ]]; then
    npm i -g netlify-cli
  fi

  # Fancy Kill. Nicer UX for killing processes
  if [[ ! -x "$(command -v fkill)" ]]; then
    npm i -g fkill-cli
  fi

}

install_bash_tools() {
  npm i -g bats

  # ShellCheck, a static analysis tool for shell scripts
  # https://github.com/koalaman/shellcheck
  if [[ -x "$(command -v shellcheck)" ]]; then
    echo "Shellcheck installed and in path"
  else
    if is_wsl; then
      echo "WSL Detected"
      cd ~ || exit
      wget https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz
      tar -xvf shellcheck-stable.linux.x86_64.tar.xz
      sudo mv ./shellcheck-stable/shellcheck /usr/bin
      rm -rf ./shellcheck-stable
      rm shellcheck-stable.linux.x86_64.tar.xz
    else
      snap install --channel=edge shellcheck
    fi
  fi
}

install_exercism() {
  if [[ ! -x "$(command -v exercism)" ]]; then
    cd ~ || exit
    curl -O -J -L https://github.com/exercism/cli/releases/download/v3.0.12/exercism-linux-64bit.tgz
    tar -xvf exercism-linux-64bit.tgz
    mkdir -p ~/bin
    mv exercism ~/bin
    rm exercism-linux-64bit.tgz
    echo "Be sure to manually configure the Exercism CLI with your Token"
  else
    exercism upgrade
  fi
}

install_wasmer() {
  if [[ ! -x "$(command -v wasmer)" ]]; then
    curl https://get.wasmer.io -sSfL | bash
  fi
}

install_wasmtime() {
  if [[ ! -x "$(command -v wasmtime)" ]]; then
    curl https://wasmtime.dev/install.sh -sSf | bash
  fi
}

install_wavm() {
  if [[ ! -x "$(command -v wavm)" ]]; then
    WAVM_DEB_PATH=https://github.com/WAVM/WAVM/releases/download/nightly%2F2019-12-25/wavm-0.0.0-prerelease-linux.deb
    WAVM_DEB_NAME=wavm-0.0.0-prerelease-linux.deb
    cd ~ || exit
    wget $WAVM_DEB_PATH
    mv $WAVM_DEB_NAME wavm-1.0.0-linux.deb
    sudo apt install ./wavm-1.0.0-linux.deb
    rm wavm-1.0.0-linux.deb
  fi
}

install_lucet() {
  cd ~/projects || exit
  git clone --recurse-submodules git@github.com:bytecodealliance/lucet.git
  cd lucet || exit
  source devenv_setenv.sh
  cd ~ || exit
}

install_emscripten() {
  if [[ ! -x "$(command -v emsdk)" ]]; then
    cd ~ || exit
    git clone https://github.com/emscripten-core/emsdk
    # Update and activate latest
    cd ~/emsdk || exit
    ./emsdk install latest
    ./emsdk activate latest
    cd ~ || exit
  fi

}

install_latex() {
  sudo apt install texlive texlive-latex-extra --yes
}

install_kubernetes() {
  if [ ! -x "$(command -v kubectl)" ]; then
    echo "Installing Kubectl"
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
  fi
}

install_helm_2() {
  if [ ! -x "$(command -v helm)" ]; then
    echo "Installing Helm"
    cd ~ || exit
    wget https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz
    tar -xvf helm-v2.16.1-linux-amd64.tar.gz linux-amd64/tiller linux-amd64/helm
    sudo mv linux-amd64/tiller /usr/bin
    sudo mv linux-amd64/helm /usr/bin
    rm -r linux-amd64
    rm helm-v2.16.1-linux-amd64.tar.gz
    helm init --upgrade
  fi
}

install_helm_3() {
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
}

install_openwhisk() {
  if [ ! -x "$(command -v wsk)" ]; then
    echo "Installing OpenWhisk"
    cd ~ || exit
    wget https://github.com/apache/openwhisk-cli/releases/download/1.0.0/OpenWhisk_CLI-1.0.0-linux-amd64.tgz
    tar -xvf OpenWhisk_CLI-1.0.0-linux-amd64.tgz wsk
    sudo mv wsk /usr/bin
    rm OpenWhisk_CLI-1.0.0-linux-amd64.tgz
  fi
}

install_protobuf() {
  if [ ! -x "$(command -v protoc)" ]; then
    cd ~ || exit
    curl -O -J -L https://github.com/protocolbuffers/protobuf/releases/download/v3.10.0/protobuf-all-3.10.0.tar.gz
    tar -xvf protobuf-all-3.10.0.tar.gz
    cd protobuf-3.10.0 || exit
    ./configure
    make
    make check
    sudo make install
    sudo ldconfig # refresh shared library cache
  fi
}

cleanup() {
  sudo apt autoremove -y
}

main() {
  link_dotfiles
  # config_git
  install_misc_packages
  install_c_cpp_tools
  install_llvm
  install_rust
  install_go
  install_java
  install_python
  install_ansible
  install_nodejs
  install_assorted_npm_tools
  install_bash_tools
  install_exercism
  install_wasmer
  install_wasmtime
  install_wavm
  # install_lucet
  install_emscripten
  install_latex
  # install_kubernetes
  # install_helm_2
  # install_helm_3
  install_openwhisk
  # install_protobuf
  cleanup
}

main "$@"
