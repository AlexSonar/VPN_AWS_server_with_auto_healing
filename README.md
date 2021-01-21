# VPN_AWS_server_with_auto_healing
AWS EC2 instance with VPN server also using auto healing to replace failed Instances

## WireGuard
First I would recommend checking the repo like [WireGuard](https://www.wireguard.com/)
and check it best repo [WireGuard VPN installer for Linux servers](https://github.com/angristan/wireguard-install)
and Learn [how to set up your own Wireguard server](https://stanislas.blog/2019/01/how-to-setup-vpn-server-wireguard-nat-ipv6/)


This project is a bash script that aims to set up a WireGuard VPN on a Linux server, as easily as possible!


If WireGuard does not fit your environment? Check out [openvpn-install](https://github.com/angristan/openvpn-install).


# Terraform Automation module 

 In current repository presented scripts that will create in AWS
 a single node OpenVPN Server cluster in a dedicated AWS VPC and subnet. The OpenVPN server is configured to be readily accessible by the users supplied in the Terraform input file. The same Terraform input file can be used to subsequently update the list of authorized users.

## Requirements

Before the start Make sure you have:

    the actual AWS account
    the Terraform CLI installed
    the list of users to provision with OpenVPN access

Moreover, you probably had enough of people snooping on you and want some privacy back or just prefer to have a long-lived static IP.

