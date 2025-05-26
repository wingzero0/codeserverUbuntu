#!/bin/bash
git clone https://github.com/microsoft/vscode-java-test.git
cd vscode-java-test
git checkout 0.43.1
npm install
npm run build-plugin
npx -y @vscode/vsce@latest package
code-server --install-extension vscode-java-test-0.43.1.vsix