#! /bin/sh

g_debug_switch=off
g_ngx_bgn_switch=on

g_xfs_installed_dir=/usr/local/xfs
g_xfs_bin_dir=${g_xfs_installed_dir}/bin
g_xfs_log_dir=/data/proclog/log/xfs
g_xfs_service_dir=/etc/systemd/system

g_disk_num=0
g_disk_max=12 # support up to 12 data disks
g_vdisk_size=$(expr 32 \* 1024 \* 1024 \* 1024) # 32GB
g_disk_min_size=$(expr 64 \* 1024 \* 1024 \* 1024 \* 1024) # min size of all disk available space. here define as max value 64TB
g_disk_rsvd_size=$(expr 100 \* 1024 \* 1024 \* 1024) # disk reserve 17GB
g_mem_cache_size=0
g_mem_cache_max_size=$(expr 8 \* 1024 \* 1024 \* 1024) # max 8GB
g_cache_dir_top=/data/cache
g_cache_dir_prefix=${g_cache_dir_top}/rnode
g_ssd_dir_prefix=${g_cache_dir_top}/ssd

g_srv_ip_addr=127.0.0.1

# type,tcid,maski,maske,srvport,csrvport,cluster(s)
g_tasks_cfg_list=(
    xfs,10.10.67.18,0,0,618,718,1,3
    xfs,10.10.67.19,0,0,619,719,1,3
    xfs,10.10.67.20,0,0,620,720,1,3
    xfs,10.10.67.21,0,0,621,721,1,3
    xfs,10.10.67.22,0,0,622,722,1,3
    xfs,10.10.67.23,0,0,623,723,1,3
    xfs,10.10.67.24,0,0,624,724,1,3
    xfs,10.10.67.25,0,0,625,725,1,3
    xfs,10.10.67.26,0,0,626,726,1,3
    xfs,10.10.67.27,0,0,627,727,1,3
    xfs,10.10.67.28,0,0,628,728,1,3
    xfs,10.10.67.29,0,0,629,729,1,3

    ngx,10.10.6.18,0,0,818,918,1,3,4
    ngx,10.10.6.19,0,0,819,919,1,3,4
    ngx,10.10.6.20,0,0,820,920,1,3,4
    ngx,10.10.6.21,0,0,821,921,1,3,4
    ngx,10.10.6.22,0,0,822,922,1,3,4
    ngx,10.10.6.23,0,0,823,923,1,3,4
    ngx,10.10.6.24,0,0,824,924,1,3,4
    ngx,10.10.6.25,0,0,825,925,1,3,4
    ngx,10.10.6.26,0,0,826,926,1,3,4
    ngx,10.10.6.27,0,0,827,927,1,3,4
    ngx,10.10.6.28,0,0,828,928,1,3,4
    ngx,10.10.6.29,0,0,829,929,1,3,4

    ngx,10.10.7.18,0,0,838,938,1,3,4
    ngx,10.10.7.19,0,0,839,939,1,3,4
    ngx,10.10.7.20,0,0,840,940,1,3,4
    ngx,10.10.7.21,0,0,841,941,1,3,4
    ngx,10.10.7.22,0,0,842,942,1,3,4
    ngx,10.10.7.23,0,0,843,943,1,3,4
    ngx,10.10.7.24,0,0,844,944,1,3,4
    ngx,10.10.7.25,0,0,845,945,1,3,4
    ngx,10.10.7.26,0,0,846,946,1,3,4
    ngx,10.10.7.27,0,0,847,947,1,3,4
    ngx,10.10.7.28,0,0,848,948,1,3,4
    ngx,10.10.7.29,0,0,849,949,1,3,4

    ngx,10.10.8.18,0,0,858,958,1,3,4
    ngx,10.10.8.19,0,0,859,959,1,3,4
    ngx,10.10.8.20,0,0,860,960,1,3,4
    ngx,10.10.8.21,0,0,861,961,1,3,4
    ngx,10.10.8.22,0,0,862,962,1,3,4
    ngx,10.10.8.23,0,0,863,963,1,3,4
    ngx,10.10.8.24,0,0,864,964,1,3,4
    ngx,10.10.8.25,0,0,865,965,1,3,4
    ngx,10.10.8.26,0,0,866,966,1,3,4
    ngx,10.10.8.27,0,0,867,967,1,3,4
    ngx,10.10.8.28,0,0,868,968,1,3,4
    ngx,10.10.8.29,0,0,869,969,1,3,4

    ngx,10.10.9.18,0,0,878,978,1,3,4
    ngx,10.10.9.19,0,0,879,979,1,3,4
    ngx,10.10.9.20,0,0,880,980,1,3,4
    ngx,10.10.9.21,0,0,881,981,1,3,4
    ngx,10.10.9.22,0,0,882,982,1,3,4
    ngx,10.10.9.23,0,0,883,983,1,3,4
    ngx,10.10.9.24,0,0,884,984,1,3,4
    ngx,10.10.9.25,0,0,885,985,1,3,4
    ngx,10.10.9.26,0,0,886,986,1,3,4
    ngx,10.10.9.27,0,0,887,987,1,3,4
    ngx,10.10.9.28,0,0,888,988,1,3,4
    ngx,10.10.9.29,0,0,889,989,1,3,4

    detect,10.10.10.10,32,32,955,956,1,4

    console,0.0.0.64,32,32,600,,1,2
    console,0.0.0.65,32,32,700,,2
)

#--------------------------------------------------------------------------
#  scenario: item: 64B, key: 63B, slice: 256K
# disk size       inodes          np size x num      np model
# 500G            200w            256M x 1           5
# 1T              400w            512M x 1           6
# 2T              800w            1G   x 1           7
# 3T              1200w           512M x 3           6
# 4T              1600w           2G   x 1           8
# 5T              2000w           512M x 5           6
# 6T              2400w           1G   x 3           7
# 7T              2800w           512M x 7           6
# 8T              3200w           4G   x 1           9
#--------------------------------------------------------------------------

g_np_cfg_table=(
    # 64GB
    0,64,2,1

    # 128GB
    0,128,3,1

    # 256GB
    0,256,4,1

    # 512GB
    0,512,5,1

    # 1TB
    512,1024,6,1

    # 2TB
    1024,2048,7,1

    # 3TB
    2048,3072,6,3

    # 4TB
    3072,4096,8,1

    # 5TB
    4096,5120,6,5

    # 6TB
    5120,6144,7,3

    # 7TB
    6144,7168,6,7

    # 8TB
    7168,8192,9,1
)

###############################################################################
# USAGE
###############################################################################
usage()
{
    echo "usage: $0 [<xfs installed dir>] [<xfs log dir>]" 
    echo "  e.g. $0 /usr/local/xfs /data/proclog/log/xfs" 
}

##############################################
# entrance
##############################################
main()
{
    os_setting
    if [ $? != 0 ]; then
        echo_error "error: main: os_setting failed"
        return 1
    fi
    
    count_data_disk_num
    if [ $? != 0 ]; then
        echo_error "error: main: count_data_disk_num failed"
        return 1
    fi

    count_hsxfs_mem_cache_size
    if [ $? != 0 ]; then
        echo_error "error: main: count_hsxfs_mem_cache_size failed"
        return 1
    fi

    gen_sysConfig_block 0 > ${g_xfs_bin_dir}/config.xml
    if [ $? != 0 ]; then
        echo_error "error: main: gen_sysConfig_block failed"
        return 1
    fi

    count_disk_min_size
    if [ $? != 0 ]; then
        echo_error "error: main: count_disk_min_size failed"
        return 1
    fi

    gen_hsxfs_all_nodes
    if [ $? != 0 ]; then
        echo_error "error: main: gen_hsxfs_all_nodes failed"
        return 1
    fi

    sleep 5

    gen_hsxfs_all_services
    if [ $? != 0 ]; then
        echo_error "error: main: gen_hsxfs_all_services failed"
        return 1
    fi

    echo_info "[INFO] main: succ"

    return 0
}

##############################################
# os setting
##############################################
os_setting()
{
    local ret
    local file
    
    # disable swap partition
    swapoff -a
    file=/etc/fstab
    if [ -f ${file} ]; then
        sed -i "s@.*swap@#&@g" ${file}
    fi

    ulimit -n 819200

    sysctl -w fs.file-max=819200

    file=/etc/sysctl.conf
    if [ -f ${file} ]; then
        ret=$(grep fs.file-max ${file})
        if [ -z ${ret} ]; then
            echo fs.file-max=819200 >> ${file}
        else
            sed -i "s@fs\.file-max.*@fs.file-max=819200@g" ${file}
        fi
    fi

    return 0
}


##############################################
# generate one xfs node
##############################################
gen_hsxfs_one_node()
{
    local disk_idx
    local disk_size # bytes
    local vdisk_num # one virtual disk = 32G
    local cache_dir
    local ssd_dir
    local node_idx
    local tcid
    local cfg_line
    local disk_idx_t
    local cfg_type
    local dbg_exe
    local dbg_params
    local np_cfg_line
    local np_cfg_lo_size
    local np_cfg_hi_size
    local np_cfg_model
    local np_cfg_num
    local np_model
    local np_num
    local cache_meta_size

    disk_idx=$1
    disk_size=$2
    cache_dir=$3
    ssd_dir=$4

    node_idx=${disk_idx}
    vdisk_num=0
    # get tasks cfg line of specific disk
    disk_idx_t=1
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)
        if [ ${cfg_type} != 'xfs' ]; then
            continue
        fi

        if [ ${disk_idx_t} -gt ${g_disk_num} ]; then
            echo_error "error: gen_hsxfs_one_node: ${disk_idx_t} > ${g_disk_num}"
            return 1
        fi

        echo_debug "[DEBUG] gen_hsxfs_one_node ${disk_idx_t}, ${disk_idx} ${g_disk_num}"
        if [ ${disk_idx_t} -eq ${disk_idx} ]; then
            tcid=$(echo ${cfg_line} | cut -d, -f 2)
            break
        fi

        disk_idx_t=$(expr ${disk_idx_t} + 1)
    done

    # determine np model and np num
    np_model=8 # default
    np_num=1   # default
    for np_cfg_line in ${g_np_cfg_table[*]}
    do
        np_cfg_lo_size=$(echo ${np_cfg_line} | cut -d, -f 1) # in GB
        np_cfg_hi_size=$(echo ${np_cfg_line} | cut -d, -f 2) # in GB
        np_cfg_model=$(echo ${np_cfg_line} | cut -d, -f 3)
        np_cfg_num=$(echo ${np_cfg_line} | cut -d, -f 4)
        #cache_meta_size=$(echo ${np_cfg_line} | cut -d, -f 5)

        np_cfg_lo_size=$(expr ${np_cfg_lo_size} \* 1024 \* 1024 \* 1024) # bytes
        np_cfg_hi_size=$(expr ${np_cfg_hi_size} \* 1024 \* 1024 \* 1024) # bytes

        # np_cfg_lo_size <= disk_size < np_cfg_hi_size
        if [ ${disk_size} -ge ${np_cfg_lo_size} ] && [ ${disk_size} -lt ${np_cfg_hi_size} ]; then
            np_model=${np_cfg_model}
            np_num=${np_cfg_num}

            #compute vdisk num
            vdisk_num=$(expr ${disk_size} / ${g_vdisk_size})
            if [ $(expr ${disk_size} % ${g_vdisk_size}) -eq 0 ]; then
                vdisk_num=$(expr ${vdisk_num} - 1)
            fi
            if [ ${vdisk_num} -le 0 ]; then
                echo_error "error: gen_hsxfs_one_node: disk size ${disk_size}, vdisk size {g_vdisk_size} => vdisk num ${vdisk_num} <= 0"
                return 1
            fi
            break
        fi
    done

    if [ ${vdisk_num} -eq 0 ]; then
        echo_error "error: gen_hsxfs_one_node: virutal disk num should never be zero !"
        return 1
    fi
    echo_debug "[INFO] gen_hsxfs_one_node: disk size ${disk_size} B => virtual disk num ${vdisk_num} x 32 G"
    dbg_exe=${g_xfs_bin_dir}/xfs_tool

    dbg_params=""
    dbg_params="${dbg_params}set loglevel 9;"
    dbg_params="${dbg_params}open xfs ${cache_dir} ${ssd_dir};"
    dbg_params="${dbg_params}create np ${np_model} ${np_num};"
    dbg_params="${dbg_params}create dn;"
    dbg_params="${dbg_params}create sata bad bitmap;"
    dbg_params="${dbg_params}add disks ${vdisk_num};"
    dbg_params="${dbg_params}close xfs"

    #echo ${dbg_params}

    echo_debug "[DEBUG] cmd: '${dbg_exe} \"${dbg_params}\" \"${tcid}\" \"${g_xfs_bin_dir}/config.xml\" &'"
    ${dbg_exe} "${dbg_params}" "${tcid}" "${g_xfs_bin_dir}/config.xml" & # running on background

    return 0
}

##############################################
# generate one xfs service 
##############################################
gen_hsxfs_one_service()
{
    local cache_dir
    local ssd_dir
    local node_idx
    local tcid
    local cfg_line
    local disk_idx_t
    local cfg_type
    local service_template
    local service_file

    disk_idx=$1
    cache_dir=$2
    ssd_dir=$3

    node_idx=${disk_idx}

    # get tasks cfg line of specific disk
    disk_idx_t=1
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)
        if [ ${cfg_type} != 'xfs' ]; then
            continue
        fi

        if [ ${disk_idx_t} -gt ${g_disk_num} ]; then
            echo_error "error: gen_hsxfs_one_service: ${disk_idx_t} > ${g_disk_num}"
            return 1
        fi

        echo_debug "[DEBUG] gen_hsxfs_one_service ${disk_idx_t}, ${disk_idx} ${g_disk_num}"
        if [ ${disk_idx_t} -eq ${disk_idx} ]; then
            tcid=$(echo ${cfg_line} | cut -d, -f 2)
            break
        fi

        disk_idx_t=$(expr ${disk_idx_t} + 1)
    done

    service_template=${g_xfs_service_dir}/xfs.c7.service.default
    service_file=${g_xfs_service_dir}/xfs@rnode${node_idx}.service
    if [ ! -f ${service_template} ]; then
        echo_error "error: gen_hsxfs_one_service: not found service template '${service_template}'"
        return 1
    fi

    echo_debug "[DEBUG] cmd: cp -p ${service_template} ${service_file}"
    cp -p ${service_template} ${service_file}
    sed -i "s@\${xfs_tcid}@${tcid}@g" ${service_file}
    sed -i "s@\${xfs_sata_path}@${cache_dir}@g" ${service_file}

    if [ -L "${ssd_dir}" ]; then
        sed -i "s@\${xfs_ssd_path}@${ssd_dir}@g" ${service_file}
    else
        sed -i "s@ -xfs_ssd_path \${xfs_ssd_path}@@g" ${service_file}
    fi

    return 0
}

##############################################
# count min size of all disks
##############################################
count_disk_min_size()
{
    local disk_idx
    local disk_size
    local disk_size_str
    local disk_size_check
    local ret_val

    disk_idx=1
    while [ ${disk_idx} -le ${g_disk_num} ]; 
    do
        cache_dir=${g_cache_dir_prefix}${disk_idx}
        if [ ! -L  ${cache_dir} ]; then
            echo_error "error: count_disk_min_size: not found ${cache_dir}"
            break
        fi

        # SATA Disk Capacity
        disk_size_str=$(fdisk -l ${cache_dir} | grep Disk | grep bytes | awk '{print $5}')
        echo_debug "[DEBUG] count_disk_min_size: ${cache_dir} => \"${disk_size_str}\""

        disk_size_check=$(echo ${disk_size_str})
        if [ x"${disk_size_check}" == 'x' ]; then
            echo_error "error:count_disk_min_size: get disk size faild"
            return 1
        fi        

        disk_size=${disk_size_str}
        echo_debug "[DEBUG] count_disk_min_size: ${cache_dir} => ${disk_size_str} bytes => ${disk_size}"

        if [ ${disk_size} -lt ${g_disk_min_size} ]; then
            echo_debug "[DEBUG] count_disk_min_size: ${g_disk_min_size} => ${disk_size}"
            g_disk_min_size=${disk_size}
        fi
        disk_idx=$(expr ${disk_idx} + 1)
    done

    # adjust disk min size by cut down reserved space
    g_disk_min_size=$(expr ${g_disk_min_size} - ${g_disk_rsvd_size})
    echo_debug "[DEBUG] count_disk_min_size: adjust => ${g_disk_min_size}"
    
    return 0
}

##############################################
# count mem cache size of each xfs
##############################################
count_hsxfs_mem_cache_size()
{
    local total_mem_size_kb # KB
    local total_mem_size_nbytes

    if [ ${g_disk_num} -le 0 ]; then
        echo_error "error: count_hsxfs_mem_cache_size: disk num is 0"
        return 1
    fi

    total_mem_size_kb=$(cat /proc/meminfo  | grep MemTotal | awk '{print $2}')
    total_mem_size_nbytes=$(expr ${total_mem_size_kb} \* 1024)

    g_mem_cache_size=$(expr ${total_mem_size_nbytes} / 2 / ${g_disk_num})
    if [ ${g_mem_cache_size} -gt ${g_mem_cache_max_size} ]; then
        g_mem_cache_size=${g_mem_cache_max_size}
    fi
    echo_debug "[DEBUG] count_hsxfs_mem_cache_size: g_mem_cache_size=${g_mem_cache_size}"

    return 0
}

##############################################
# generate hsxfs nodes
##############################################
gen_hsxfs_all_nodes()
{
    local disk_idx
    local disk_size
    local disk_size_str
    local disk_size_check
    local cache_dir
    local ssd_dir
    local ret_val

    if [ ${g_disk_min_size} -le ${g_vdisk_size} ]; then
        echo_error "error: gen_hsxfs_all_nodes: disk min size ${g_disk_min_size} <= vdisk size ${g_vdisk_size}"
        return 1
    fi

    disk_size=${g_disk_min_size}

    disk_idx=1
    while [ ${disk_idx} -le ${g_disk_num} ]; 
    do
        cache_dir=${g_cache_dir_prefix}${disk_idx}
        if [ ! -L  ${cache_dir} ]; then
            echo_error "error: gen_hsxfs_all_nodes: not found ${cache_dir}"
            break
        fi

        ssd_dir=${g_ssd_dir_prefix}${disk_idx}
        #if [ ! -L  ${ssd_dir} ]; then
        #    echo_error "error: gen_hsxfs_all_nodes: not found ${ssd_dir}"
        #    break
        #fi        

        gen_hsxfs_one_node ${disk_idx} ${disk_size} ${cache_dir} ${ssd_dir}
        if [ $? != 0 ]; then
            echo_error "error: gen_hsxfs_all_nodes: generate hsxfs node ${disk_idx} failed"
            return 1
        fi

        disk_idx=$(expr ${disk_idx} + 1)
    done

    while [ 1 ];
    do
        sleep 3

        get_xfs_tool_proc_num
        ret_val=$?
        if [ ${ret_val} -eq 0 ]; then
            echo_info "[INFO] gen_hsxfs_all_nodes: all xfs_tool processes complete"
            break
        fi
        echo_info "[INFO] gen_hsxfs_all_nodes: ${ret_val} xfs_tool processes are running"
    done

    sync && sync && sync && sync && echo 1 > /proc/sys/vm/drop_caches

    return 0
}

##############################################
# generate hsxfs services 
##############################################
gen_hsxfs_all_services()
{
    local disk_idx
    local service_template

    service_template=${g_xfs_service_dir}/xfs.c7.service.default

    disk_idx=1
    while [ ${disk_idx} -le ${g_disk_num} ]; 
    do
        cache_dir=${g_cache_dir_prefix}${disk_idx}
        if [ ! -L  ${cache_dir} ]; then
            echo_error "error: gen_hsxfs_all_services: not found ${cache_dir}"
            break
        fi

        ssd_dir=${g_ssd_dir_prefix}${disk_idx}

        gen_hsxfs_one_service ${disk_idx} ${cache_dir} ${ssd_dir}
        if [ $? != 0 ]; then
            echo_error "error: gen_hsxfs_all_services: generate hsxfs node ${disk_idx} failed"
            return 1
        fi

        disk_idx=$(expr ${disk_idx} + 1)
    done

    rm -f ${service_template}
    return 0
}

##############################################
# generate sysConfig block
##############################################
gen_sysConfig_block()
{
    local level_cur
    local level_next

    level_cur=$1
    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo '<sysConfig>'

    gen_taskConfig_block ${level_next}

    gen_clusters_block ${level_next}

    gen_parasConfig_block ${level_next}

    echo_indent ${level_cur}
    echo '</sysConfig>'
}

##############################################
# count the num of data disks
##############################################
count_data_disk_num()
{
    local disk_idx
    local cache_dir

    echo_debug "[DEBUG] count_data_disk_num: g_disk_max: ${g_disk_max}"

    disk_idx=1
    while [ ${disk_idx} -le ${g_disk_max} ]; 
    do
        cache_dir=${g_cache_dir_prefix}${disk_idx}
        if [ ! -L  ${cache_dir} ]; then
            echo_debug "[DEBUG] count_data_disk_num: not found ${cache_dir}"
            break
        fi
        echo_debug "[DEBUG] count_data_disk_num: found ${cache_dir}"
        disk_idx=$(expr ${disk_idx} + 1)
    done

    g_disk_num=$(expr ${disk_idx} - 1)
    echo_debug "[DEBUG] count_data_disk_num: count disk num: ${g_disk_num}"
    return 0
}

##############################################
# generate tasks configuration item
##############################################
gen_tasks_cfg_item()
{
    local level_cur

    local cfg_line
    local tcid
    local maski
    local maske
    local srvport
    local csrvport
    local cluster
    local cluster_seg
    local idx

    level_cur=$1
    cfg_line=$2

    tcid=$(echo ${cfg_line} | cut -d, -f 2)
    maski=$(echo ${cfg_line} | cut -d, -f 3)
    maske=$(echo ${cfg_line} | cut -d, -f 4)
    srvport=$(echo ${cfg_line} | cut -d, -f 5)
    csrvport=$(echo ${cfg_line} | cut -d, -f 6)

    idx=7
    while [ 1 ];
    do
        cluster_seg=$(echo ${cfg_line} | cut -d, -f ${idx})
        if [ x"${cluster_seg}" == "x" ]; then
            break
        fi

        if [ x"${cluster}" == "x" ];then
            cluster=${cluster_seg}
        else
            cluster="${cluster},${cluster_seg}"    
        fi

        idx=$(expr ${idx} + 1)
    done;
    
    if [ x"${csrvport}" == "x" ]; then
        echo_indent ${level_cur}
        echo "<tasks tcid=\"${tcid}\"  maski=\"${maski}\" maske=\"${maske}\" ipv4=\"${g_srv_ip_addr}\" bgn=\"${srvport}\" cluster=\"${cluster}\"/>"
    else
        echo_indent ${level_cur}
        echo "<tasks tcid=\"${tcid}\"  maski=\"${maski}\" maske=\"${maske}\" ipv4=\"${g_srv_ip_addr}\" bgn=\"${srvport}\" rest=\"${csrvport}\" cluster=\"${cluster}\"/>"
    fi

    return 0
}

##############################################
# generate taskConfig block
##############################################
gen_taskConfig_block()
{
    local level_cur
    local level_next

    local cfg_line
    local cfg_type
    local disk_idx

    level_cur=$1

    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo "<taskConfig>"

    disk_idx=0
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)
        if [ ${cfg_type} == 'console' ]; then
            gen_tasks_cfg_item ${level_next} ${cfg_line}
            continue
        fi

        if [ ${cfg_type} == 'detect' ]; then
            gen_tasks_cfg_item ${level_next} ${cfg_line}
            continue
        fi        

        if [ ${cfg_type} == 'ngx' ]; then
            if [ ${g_ngx_bgn_switch} == 'on' ]; then
                gen_tasks_cfg_item ${level_next} ${cfg_line}
            fi
            continue
        fi

        if [ ${disk_idx} -ge ${g_disk_num} ]; then
            continue
        fi

        disk_idx=$(expr ${disk_idx} + 1)
        gen_tasks_cfg_item ${level_next} ${cfg_line}
    done

    echo_indent ${level_cur}
    echo "</taskConfig>"

    return 0
}

##############################################
# generate cluster xfs-ngx block
##############################################
gen_cluster_xfs_ngx_block()
{
    local level_cur
    local level_next

    local cluster_id
    local disk_idx
    local cfg_line
    local tcid

    level_cur=$1
    cluster_id=$2

    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo "<cluster id=\"${cluster_id}\" name=\"xfs-ngx\" model=\"master_slave\">"

    # xfs nodes
    disk_idx=0
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)

        if [ ${cfg_type} != 'xfs' ]; then
            continue
        fi

        if [ ${disk_idx} -ge ${g_disk_num} ]; then
            break
        fi

        disk_idx=$(expr ${disk_idx} + 1)
        
        tcid=$(echo ${cfg_line} | cut -d, -f 2)
        echo_indent ${level_next}
        echo "<node role=\"master\"   tcid=\"${tcid}\" rank=\"0\"/>"
    done

    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)

        if [ ${cfg_type} != 'ngx' ]; then
            continue
        fi
        
        tcid=$(echo ${cfg_line} | cut -d, -f 2)
        echo_indent ${level_next}
        echo "<node role=\"slave\"   tcid=\"${tcid}\" rank=\"0\"/>"
    done

    echo_indent ${level_cur}
    echo "</cluster>"
}

##############################################
# generate cluster detect-ngx block
##############################################
gen_cluster_detect_ngx_block()
{
    local level_cur
    local level_next

    local cluster_id
    local disk_idx
    local cfg_line
    local tcid

    level_cur=$1
    cluster_id=$2

    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo "<cluster id=\"${cluster_id}\" name=\"detect-ngx-disabled\" model=\"master_slave\">"

    # xfs nodes
    disk_idx=0
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)

        if [ ${cfg_type} != 'detect' ]; then
            continue
        fi

        if [ ${disk_idx} -ge ${g_disk_num} ]; then
            break
        fi

        disk_idx=$(expr ${disk_idx} + 1)
        
        tcid=$(echo ${cfg_line} | cut -d, -f 2)
        echo_indent ${level_next}
        echo "<node role=\"master\"   tcid=\"${tcid}\" rank=\"0\"/>"
    done

    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)

        if [ ${cfg_type} != 'ngx' ]; then
            continue
        fi
        
        tcid=$(echo ${cfg_line} | cut -d, -f 2)
        echo_indent ${level_next}
        echo "<node role=\"slave\"   tcid=\"${tcid}\" rank=\"0\"/>"
    done

    echo_indent ${level_cur}
    echo "</cluster>"
}


##############################################
# generate cluster debug64 block
##############################################
gen_cluster_debug64_block()
{
    local level_cur
    local level_next

    local cluster_id
    local disk_idx
    local cfg_line
    local tcid

    level_cur=$1
    cluster_id=$2

    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo "<cluster id=\"${cluster_id}\" name=\"debug64\" model=\"master_slave\">"

    echo_indent ${level_next}
    echo "<node role=\"master\"  tcid=\"0.0.0.64\"   rank=\"0\"/>"

    disk_idx=0
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)

        if [ ${cfg_type} == 'console' ]; then
            continue
        fi

        if [ ${cfg_type} == 'ngx' ]; then
            if [ ${g_ngx_bgn_switch} == 'on' ]; then
                tcid=$(echo ${cfg_line} | cut -d, -f 2)
                echo_indent ${level_next}
                echo "<node role=\"slave\"   tcid=\"${tcid}\" rank=\"0\"/>"
            fi
            continue
        fi

        if [ ${disk_idx} -ge ${g_disk_num} ]; then
            continue 
        fi

        disk_idx=$(expr ${disk_idx} + 1)
        
        tcid=$(echo ${cfg_line} | cut -d, -f 2)
        echo_indent ${level_next}
        echo "<node role=\"slave\"   tcid=\"${tcid}\" rank=\"0\"/>"
    done

    echo_indent ${level_cur}
    echo "</cluster>"
}

##############################################
# generate cluster debug65 block
##############################################
gen_cluster_debug65_block()
{
    local level_cur
    local level_next

    local cluster_id
    
    level_cur=$1
    cluster_id=$2

    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo "<cluster id=\"${cluster_id}\" name=\"debug65\" model=\"master_slave\">"

    echo_indent ${level_next}
    echo "<node role=\"master\"  tcid=\"0.0.0.65\"   rank=\"0\"/>"
     echo_indent ${level_next}
    echo "<node role=\"slave\"  tcid=\"0.0.0.64\"   rank=\"0\"/>"

    echo_indent ${level_cur}
    echo "</cluster>"

    return 0
}

##############################################
# generate clusters block
##############################################
gen_clusters_block()
{
    local level_cur
    local level_next

    level_cur=$1

    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo '<clusters>'

    gen_cluster_debug64_block ${level_next} 1
    gen_cluster_debug65_block ${level_next} 2

    if [ ${g_ngx_bgn_switch} == 'on' ]; then
         gen_cluster_xfs_ngx_block ${level_next} 3
         gen_cluster_detect_ngx_block ${level_next} 4
    fi   

    echo_indent ${level_cur}
    echo '</clusters>'

    return 0
}

##############################################
# generate para configuration item
##############################################
gen_paraConfig_item()
{
    local level_cur
    local level_next

    local cfg_line
    local cfg_type
    local tcid
    local maski
    local maske
    local srvport
    local csrvport
    local cluster
    local cluster_seg
    local idx

    level_cur=$1
    cfg_line=$2
    cfg_type=$3

    level_next=$(expr ${level_cur} + 1)

    tcid=$(echo ${cfg_line} | cut -d, -f 2)

    echo_indent ${level_cur}
    echo "<paraConfig tcid=\"${tcid}\" rank=\"0\">"

    if [ ${cfg_type} == 'xfs' ]; then
        echo_indent ${level_next}
        echo '<threadConfig maxReqThreadNum="2048" taskSlowDownMsec="1"/>'
        #echo_indent ${level_next}
        #echo '<connConfig timeoutNsec="20" timeoutMaxNumPerLoop="1024"/>'
        
        echo_indent ${level_next}
        echo "<xfsConfig xfsDnAmdSwitch=\"on\" xfsDnAmdMemDiskSize=\"${g_mem_cache_size}\"/>"
        
        echo_indent ${level_next}
        echo '<logConfig logLevel="all:0"/>' 
    fi

    if [ ${cfg_type} == 'ngx' ]; then
        echo_indent ${level_next}
        echo '<threadConfig maxReqThreadNum="4096" taskSlowDownMsec="1"/>'
        #echo_indent ${level_next}
        #echo '<connConfig timeoutNsec="20" timeoutMaxNumPerLoop="1024"/>'
        echo_indent ${level_next}
        echo '<logConfig logLevel="all:0"/>' 
    fi

    if [ ${cfg_type} == 'detect' ]; then
        echo_indent ${level_next}
        echo '<threadConfig maxReqThreadNum="2048" taskSlowDownMsec="1"/>'
        #echo_indent ${level_next}
        #echo '<connConfig timeoutNsec="20" timeoutMaxNumPerLoop="1024"/>'
        echo_indent ${level_next}
        echo '<logConfig logLevel="all:0"/>' 
    fi    

    if [ ${cfg_type} == 'console' ]; then
        echo_indent ${level_next}
        echo '<threadConfig maxReqThreadNum="4" taskSlowDownMsec="3" taskNotSlowDownMaxTimes="1"/>'
        echo_indent ${level_next}
        echo '<logConfig logLevel="all:0"/>'
    fi

    echo_indent ${level_cur}
    echo '</paraConfig>'
    
    return 0
}

##############################################
# generate para configuration block
##############################################
gen_parasConfig_block()
{
    local level_cur
    local level_next

    local cfg_line
    local cfg_type
    local disk_idx

    level_cur=$1
    level_next=$(expr ${level_cur} + 1)

    echo_indent ${level_cur}
    echo "<parasConfig>"

    disk_idx=0
    for cfg_line in ${g_tasks_cfg_list[*]}
    do
        cfg_type=$(echo ${cfg_line} | cut -d, -f 1)
        if [ ${cfg_type} == 'console' ]; then
            gen_paraConfig_item ${level_next} ${cfg_line} 'console'
            continue
        fi

        if [ ${cfg_type} == 'ngx' ]; then
            if [ ${g_ngx_bgn_switch} == 'on' ]; then
                gen_paraConfig_item ${level_next} ${cfg_line} 'ngx'
            fi
            continue
        fi

        if [ ${cfg_type} == 'detect' ]; then
            if [ ${g_ngx_bgn_switch} == 'on' ]; then
                gen_paraConfig_item ${level_next} ${cfg_line} 'detect'
            fi
            continue
        fi        

        if [ ${disk_idx} -ge ${g_disk_num} ]; then
            continue
        fi

        disk_idx=$(expr ${disk_idx} + 1)
        gen_paraConfig_item ${level_next} ${cfg_line} 'xfs'
    done

    echo_indent ${level_cur}
    echo "</parasConfig>"

    return 0
}

##############################################
# get num of xfs_tool processes
##############################################
get_xfs_tool_proc_num()
{
    local proc_num

    proc_num=$(ps -ef | grep xfs_tool | grep -v grep | grep -v xfs_init | wc -l)

    return ${proc_num}
}

##############################################
# echo several space without new line
##############################################
echo_spaces()
{
    local space_num
    local space_idx
    local space_str

    space_num=$1

    space_str=''
    space_idx=0
    while [ ${space_idx} -lt ${space_num} ];
    do
        space_str="${space_str} "
        space_idx=$(expr ${space_idx} + 1)
    done

    echo -n "${space_str}"
    return 0
}

##############################################
# echo indent in certan level
##############################################
echo_indent()
{
    local level
    local space_num

    level=$1
    space_num=$(expr ${level} + ${level})

    echo_spaces ${space_num}
    return 0
}

##############################################
# echo debug info if debug switch on
##############################################
echo_debug()
{
    if [ ${g_debug_switch} == 'on' ]; then
        echo $1
    fi
    return 0
}

##############################################
# echo error info
##############################################
echo_error()
{
    echo $1
    return 0
}

##############################################
# echo info
##############################################
echo_info()
{
    echo $1
    return 0
}

# default xfs installed dir  is current working directory
if [ $# -eq 2 ]; then
    g_xfs_installed_dir=$1
    g_xfs_log_dir=$2
fi

if [ "${g_xfs_installed_dir}" == "." ]; then
    g_xfs_installed_dir=$(pwd)
fi

if [ "${g_xfs_log_dir}" == "." ]; then
    g_xfs_log_dir=$(pwd)
fi

if [ $# -ne 0 -a $# -ne 1 -a $# -ne 2 ]; then
    usage
    exit 1
fi

main
exit $?
