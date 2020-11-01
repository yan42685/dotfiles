#!/bin/bash
# 用于为新系统设置默认的Profile, 方便设置gnome-terminal主题
# NOTE: 只有在gnome-terminal里运行才有结果, 在Alacritty里运行没用
# 参考https://askubuntu.com/questions/270469/how-can-i-create-a-new-profile-for-gnome-terminal-via-command-line 第三个回答

dconfdir=/org/gnome/terminal/legacy/profiles:

get_profile_uuid() {
    # Print the UUID linked to the profile name sent in parameter
    local profile_ids=($(dconf list $dconfdir/ | grep ^: |\
                        sed 's/\///g' | sed 's/://g'))
    local profile_name="$1"
    for i in ${!profile_ids[*]}; do
        if [[ "$(dconf read $dconfdir/:${profile_ids[i]}/visible-name)" == \
            "'$profile_name'" ]]; then
            echo "${profile_ids[i]}"
            return 0
        fi
    done
}

id=$(get_profile_uuid Unnamed)

# 设为默认Profile
dconf write $dconfdir/default "'$id'"
