# https://github.com/tekumara/typos-lsp
curl -sL -o - \
$(curl -sL https://api.github.com/repos/tekumara/typos-lsp/releases/latest | jq -r '.assets[] | select(.name? | match("typos-lsp-v.*-aarch64-apple-darwin.tar.gz$")) | .browser_download_url') |\
tar -zxvf - -C ~/.local/bin
