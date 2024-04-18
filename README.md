# nvim configs

Create folder `jdtls-libs` and `jdtls` in `.local/share/nvim/` and install following items to it:

- Download `lombok.jar` to `jdtls-libs` folder
- Clone [java debug](https://github.com/microsoft/java-debug) to `jdtls-libs` folder.
  - Run `./mvnw clean install`
- Clone [vscode-java-test](https://github.com/microsoft/vscode-java-test) to `jdtls-libs` folder.
  - Run `npm install` `npm run build-plugin`

## install plugins manually

Install following plugins manually via `:Mason` if not installed.

* codelldb
* delve
* gofumpt
* goimports
* prettierd
* shellcheck
* shfmt
* staticcheck
* stylua
