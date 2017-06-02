#!/bin/csh
# 
# BSD 3-Clause License
#
# Copyright (c) 2017, Rafael Souza Fijalkowski <rafaelsouzaf@gmail.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


set SO_USERNAME = 'MY_USER'
if ($SO_USERNAME == "MY_USER") then
	echo "PLEASE EDIT THE SCRIPT AND SET THE VARIABLES"
	exit
endif



printf "\n\n\n\n"
echo "########################################################"
echo "################# UPDATING FREEBSD "
echo "########################################################"
env PAGER=cat freebsd-update fetch
freebsd-update install



printf "\n\n\n\n"
echo "########################################################"
echo "################# INSTALLING BASIC STUFF"
echo "########################################################"
pkg install -y vim nano git wget curl openjdk unzip gcc compat9x-amd64 lynx



printf "\n\n\n\n"
echo "########################################################"
echo "################# INSTALLING TRANSCODE (has avimerge inside)"
echo "########################################################"
pkg install transcode



printf "\n\n\n\n"
echo "########################################################"
echo "################# ALLOW REMOTE LOGIN BY SSH WITH ROOT USER"
echo "########################################################"
sed -i -- 's/#PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
service sshd restart



printf "\n\n\n\n"
echo "########################################################"
echo "################# ADD USER TO SUDOERS"
echo "########################################################"
pw group mod wheel -m $SO_USERNAME
pkg install -y sudo
echo "$SO_USERNAME ALL=(ALL) ALL" >> /usr/local/etc/sudoers



set VM = 'dmesg|grep -oe VBOX|uniq'
if ("$VM" == "VBOX") then
	printf "\n\n\n\n"
	echo "########################################################"
	echo "################# INSTALL VIRTUALBOX GUEST ADDICTIONS"
	echo "########################################################"
	pkg install -y virtualbox-ose-additions
	sysrc vboxguest_enable="YES"
	sysrc vboxservice_enable="YES"
endif



printf "\n\n\n\n"
echo "########################################################"
echo "################# INSTALL SPEED TEST"
echo "########################################################"
pkg install -y py27-speedtest-cli



printf "\n\n\n\n"
echo "########################################################"
echo "################# INSTALL AND CONFIGURE NOIP"
echo "########################################################"
pkg install -y noip
sysrc noip_enable="YES"
echo "########################################################"
echo "################# ENTER YOUR noip.com USER AND PASS"
echo "################# YOU CAN REPEAT THIS ACTION AFTER EXECUTING: /usr/local/bin/noip2 -C"
echo "########################################################"
/usr/local/bin/noip2 -C



printf "\n\n\n\n"
echo "########################################################"
echo "################# READY. Thanks!"
echo "########################################################"
exit 1
