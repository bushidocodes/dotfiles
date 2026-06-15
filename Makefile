
~/.local/bin:
	mkdir -p ~/.local/bin

~/.local/bin/exercism: ~/.local/bin
	mkdir -p ~/.local/bin
	mkdir -p ~/.config/exercism
	mkdir -p temp
	wget https://github.com/exercism/cli/releases/download/v3.5.8/exercism-3.5.8-linux-x86_64.tar.gz
	tar -xvf exercism-3.5.8-linux-x86_64.tar.gz -C temp
	mv temp/shell/exercism_completion* ~/.config/exercism
	mv temp/exercism ~/.local/bin/
	rm -rf temp
	rm exercism-3.5.8-linux-x86_64.tar.gz*

~/.local/bin/shellcheck: ~/.local/bin
	wget https://github.com/koalaman/shellcheck/releases/download/v0.11.0/shellcheck-v0.11.0.linux.x86_64.tar.xz
	tar -xvf shellcheck-v0.11.0.linux.x86_64.tar.xz
	mv ./shellcheck-v0.11.0/shellcheck ~/.local/bin
	rm -rf ./shellcheck-v0.11.0/
	rm shellcheck-v0.11.0.linux.x86_64.tar.xz

~/.local/bin/shfmt: ~/.local/bin
	wget https://github.com/mvdan/sh/releases/download/v3.13.1/shfmt_v3.13.1_linux_amd64
	chmod +x shfmt_v3.13.1_linux_amd64
	rm -f "$(which shfmt)"
	mv shfmt_v3.13.1_linux_amd64 ~/.local/bin/shfmt

# Exercism Configlet https://github.com/exercism/configlet
~/.local/bin/configlet: ~/.local/bin
	wget https://github.com/exercism/configlet/releases/download/4.0.2/configlet_4.0.2_linux_x86-64.tar.gz
	tar -xvf configlet_4.0.2_linux_x86-64.tar.gz
	mv configlet ~/.local/bin
	rm configlet_4.0.2_linux_x86-64.tar.gz

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
