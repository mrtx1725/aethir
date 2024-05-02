printf "[Unit]
Description=Aethir Node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/aethir
ExecStart=/root/aethir/AethirChecker
Restart=on-failure
RestartSec=60
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/aethird.service

sudo systemctl daemon-reload
sudo systemctl enable aethird
