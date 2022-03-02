
~/.local/bin:
	mkdir -p ~/.local/bin

~/.local/bin/exercism: ~/.local/bin
	mkdir -p ~/.local/bin
	mkdir -p ~/.config/exercism
	mkdir -p temp
	wget https://github.com/exercism/cli/releases/download/v3.0.13/exercism-linux-64bit.tgz
	tar -xvf exercism-linux-64bit.tgz -C temp
	mv temp/shell/exercism_completion* ~/.config/exercism
	mv temp/exercism ~/.local/bin/
	rm -rf temp
	rm exercism-linux-64bit.tgz*

~/.local/bin/shellcheck: ~/.local/bin
	wget https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz
	tar -xvf shellcheck-v0.8.0.linux.x86_64.tar.xz
	mv ./shellcheck-v0.8.0/shellcheck ~/.local/bin
	rm -rf ./shellcheck-v0.8.0/
	rm shellcheck-v0.8.0.linux.x86_64.tar.xz

~/.local/bin/shfmt: ~/.local/bin
	wget https://github.com/mvdan/sh/releases/download/v3.4.3/shfmt_v3.4.3_linux_amd64
	chmod +x shfmt_v3.4.3_linux_amd64
	rm -f "$(which shfmt)"
	mv shfmt_v3.4.3_linux_amd64 ~/.local/bin/shfmt
	rm shfmt_v3.4.3_linux_amd64

# Exercism Configlet https://github.com/exercism/configlet
~/.local/bin/configlet: ~/.local/bin
	wget https://github.com/exercism/configlet/releases/download/4.0.0-alpha.37/configlet-linux-64bit.tgz
	tar -xvf configlet-linux-64bit.tgz
	mv configlet ~/.local/bin
	rm configlet-linux-64bit.tgz

~/.local/share/pnpm/pnpm:
	curl -fsSL https://get.pnpm.io/install.sh | sh -

~/.local/share/pnpm/node: /home/sean/.local/share/pnpm/pnpm
	pnpm env use --global lts

~/.local/share/pnpm/http-server: ~/.local/share/pnpm/pnpm
	pnpm i -g http-server

~/.local/share/pnpm/netlify: ~/.local/share/pnpm/pnpm
	pnpm i -g netlify-cli

~/.local/share/pnpm/fkill: ~/.local/share/pnpm/pnpm
	pnpm i -g fkill-cli

~/.local/share/pnpm/bats: ~/.local/share/pnpm/pnpm
	pnpm i -g bats

~/.wasmtime/bin/wasmtime:
	curl https://wasmtime.dev/install.sh -sSf | bash

~/.deno/bin/deno:
	curl -fsSL https://deno.land/x/install/install.sh | sh

~/.jenv:
	git clone https://github.com/gcuisinier/jenv.git ~/.jenv

~/.cargo/bin/rustup:
	curl https://sh.rustup.rs -sSf | bash -s -- -y
