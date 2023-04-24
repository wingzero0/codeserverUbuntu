#!/bin/bash
mkdir -p /root/.local/share/code-server/extensions
if [ "$(ls -A /root/.local/share/code-server/extensions)" ]; then
    echo "extensions folder not empty, skip copy extensions."
else
    echo "initialize extensions folder."
    cp -r /root/initExtensions/* /root/.local/share/code-server/extensions/
fi

code-server