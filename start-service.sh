#!/bin/bash

source ~/.bash_profile

sudo systemctl restart aethird
sudo journalctl -u aethird.service -f --no-hostname -o cat
