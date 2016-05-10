#!/bin/bash -xe
# Copyright 2016 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

MIRROR_VOLUME=$1

BASE="/afs/.openstack.org/mirror/centos"
MIRROR="rsync://mirror.sfo12.us.leaseweb.net"
K5START="k5start -t -f /etc/centos.keytab service/centos-mirror -- timeout -k 2m 30m"

REPO=7
if ! [ -f $BASE/$REPO ]; then
    $K5START mkdir -p $BASE/$REPO
fi

echo "Running rsync..."
$K5START rsync -rlptDvz \
    --delete \
    --delete-excluded \
    --exclude="atomic" \
    --exclude="centosplus" \
    --exclude="cloud" \
    --exclude="cr" \
    --exclude="extras" \
    --exclude="fasttrack" \
    --exclude="isos" \
    --exclude="sclo" \
    --exclude="storage" \
    --exclude="virt" \
    $MIRROR/centos/$REPO/ $BASE/$REPO/

# TODO(pabelanger): Validate rsync process

echo "rsyc completed successfully, running vos release."
k5start -t -f /etc/afsadmin.keytab service/afsadmin -- vos release -v $MIRROR_VOLUME

echo "Done."
