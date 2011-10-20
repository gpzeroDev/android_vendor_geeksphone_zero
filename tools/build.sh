#!/bin/bash
#
# Realiza todo lo necesario para compilar la ROM :)
#
function gettop
{
    local TOPFILE=build/core/envsetup.mk
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        echo $TOP
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            # We redirect cd to /dev/null in case it's aliased to
            # a command that prints something as a side-effect
            # (like pushd)
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                cd .. > /dev/null
                T=`PWD= /bin/pwd`
            done
            cd $HERE > /dev/null
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

export ANDROID_BUILD_TOP=$(gettop)
cd $ANDROID_BUILD_TOP
. build/envsetup.sh && choosecombo 1 1 zero 3 && make -j`cat /proc/cpuinfo | grep "^processor" | wc -l` "$@" otapackage 

cd vendor/geeksphone/zero/tools/
./squisher

cd $ANDROID_BUILD_TOP
