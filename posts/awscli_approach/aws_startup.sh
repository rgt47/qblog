#!/bin/bash
snap install docker
git clone https://rgt47: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@github.com/rgt47/docker_compose_power1_app.git
wait
cp -R docker_compose_power1_app/ ~ubuntu
cd ~ubuntu
sudo chown -R ubuntu:ubuntu ~ubuntu/docker_compose_power1_app/
cd ~ubuntu/docker_compose_power1_app
