
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
	rm -f "$$(which shfmt)"
	mv shfmt_v3.13.1_linux_amd64 ~/.local/bin/shfmt

# Exercism Configlet https://github.com/exercism/configlet
~/.local/bin/configlet: ~/.local/bin
	wget https://github.com/exercism/configlet/releases/download/4.0.2/configlet_4.0.2_linux_x86-64.tar.gz
	tar -xvf configlet_4.0.2_linux_x86-64.tar.gz
	mv configlet ~/.local/bin
	rm configlet_4.0.2_linux_x86-64.tar.gz

# pnpm installs its binary under $PNPM_HOME/bin and only puts it on PATH via
# ~/.bashrc, which these non-interactive recipes never source. Invoke it by
# absolute path with PNPM_HOME set rather than relying on a bare `pnpm`.
PNPM_HOME := $(HOME)/.local/share/pnpm
PNPM := PNPM_HOME=$(PNPM_HOME) PATH="$(PNPM_HOME)/bin:$$PATH" $(PNPM_HOME)/bin/pnpm

$(PNPM_HOME)/bin/pnpm:
	# pnpm's installer infers the rc file from $$SHELL and aborts with
	# ERR_PNPM_UNKNOWN_SHELL when it is unset (non-interactive shells).
	curl -fsSL https://get.pnpm.io/install.sh | SHELL="$${SHELL:-/bin/bash}" sh -

~/.local/share/pnpm/node: $(PNPM_HOME)/bin/pnpm
	$(PNPM) env use --global lts

~/.local/share/pnpm/http-server: $(PNPM_HOME)/bin/pnpm
	$(PNPM) i -g http-server

~/.local/share/pnpm/netlify: $(PNPM_HOME)/bin/pnpm
	$(PNPM) i -g netlify-cli

~/.local/share/pnpm/fkill: $(PNPM_HOME)/bin/pnpm
	$(PNPM) i -g fkill-cli

~/.local/share/pnpm/bats: $(PNPM_HOME)/bin/pnpm
	$(PNPM) i -g bats

~/.wasmtime/bin/wasmtime:
	curl https://wasmtime.dev/install.sh -sSf | bash

~/.deno/bin/deno:
	curl -fsSL https://deno.land/x/install/install.sh | sh

~/.jenv:
	git clone https://github.com/gcuisinier/jenv.git ~/.jenv

~/.cargo/bin/rustup:
	curl https://sh.rustup.rs -sSf | bash -s -- -y
