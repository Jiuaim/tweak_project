
function copyAllfile(){
    for element in `ls $1`
    do
        source_file_pwd=$1"/"$element
        des_file_pwd=$2"/"$element
        cp -a $source_file_pwd $des_file_pwd
#- a 保留链接和文件属性，递归拷贝目录，相当于下面的d、p、r三个选项组合。
#- d 拷贝时保留链接。
#- f 删除已经存在目标文件而不提示。
#- i 覆盖目标文件前将给出确认提示，属交互式拷贝。
#- p 复制源文件内容后，还将把其修改时间和访问权限也复制到新文件中。
#- r 若源文件是一目录文件，此时cp将递归复制该目录下所有的子目录和文件。当然，目标文件必须为一个目录名。
#- l 不作拷贝，只是链接文件。
#- s 复制成符号连结文件 (symbolic link)，亦即『快捷方式』档案；
#- u 若 destination 比 source 旧才更新 destination。
    done
}

function resignAllMachOFile(){
    frameworks_pwd=$1"/Frameworks"
    watch_pwd=$1"/Watch"
    extension_pwd=$1"/PlugIns"
    
    declare -a pwd_array=($frameworks_pwd $watch_pwd $extension_pwd)
    for pwd_element in ${pwd_array[*]}
    do
        if [ -d $pwd_element ]
        then
            for element in `ls $pwd_element`
            do
                file_pwd=$pwd_element"/"$element
                codesign -fs $2 $file_pwd
#        查看证书
#        security find-identity -v -p codesigning

#        查看签名(-d 是display展示签名信息的意思，-v 是verbose的意思，越多的verbose显示信息越多)
#        codesign -d -vvv xxx.app

#        签名
#        codesign -fs identity xxx.app
            done
        fi
    done

}

function insertDylib(){
    dy_load_path="@executable_path/Frameworks/"$1
    insert_dylib $dy_load_path $2 --all-yes --weak --inplace
}

function changeDylibLoadPath(){
    new_path="@rpath/CydiaSubstrate"
    install_name_tool -change '@executable_path/Frameworks/zhtweak.dylib' $new_path $1
}

function resignMainApp(){
    codesign -fs $1 --entitlements $2 $3
}

# move all($2 source path   $3 des path)
if [ $1 == '-ma' ]
then
copyAllfile $2 $3
fi

# resign all($2 identify   $3 .app path)
if [ $1 == '-ra' ]
then
resignAllMachOFile $3 $2
fi

# insert dylib($2 dylib name   $3 main mach-o path)
if [ $1 == '-id' ]
then
insertDylib $2 $3
fi

# change dylib load path($2 change load path mach-o path)
if [ $1 == '-cp' ]
then
changeDylibLoadPath $2
fi

# codesign main app($2 identify   $3 entitlements.plist path   $4 .app path)
if [ $1 == '-cm' ]
then
resignMainApp $2 $3 $4
fi
