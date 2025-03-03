#!/bin/bash
mkdir -p /home/ubuntu/.local/share/code-server/extensions
if [ "$(ls -A /home/ubuntu/.local/share/code-server/extensions)" ]; then
    echo "extensions folder not empty, skip copy extensions."
else
    echo "initialize extensions folder."
    tar zxvf /home/ubuntu/initExtensions/extensions.tgz -C /home/ubuntu/.local/share/code-server/extensions/
fi

code-server
