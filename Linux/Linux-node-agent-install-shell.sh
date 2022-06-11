#!/bin/sh

version="${VERSION:-0.18.1}"
arch="${ARCH:-linux-amd64}"
bin_dir="${BIN_DIR:-/usr/local/bin}"
base_url="https://github.com/prometheus/node_exporter/releases/download"
service_gist="https://gist.githubusercontent.com/safoorsafdar/626ba7b60885aec74cb7cb5baf07189d/raw/3ae4041e9ea8788175408a7e0fe9d422c1be311e/centos-6-service.sh"
exporter_args="--collector.diskstats.ignored-devices=\"^(dm-|ram|loop|fd|(h|s|v|xv)d[a-z]|nvme\\d+n\\d+p)\\d+$\" \
            --collector.filesystem.ignored-mount-points=\"^/(dev|sys|run|var/lib/(docker|lxcfs|nobody_tmp_secure))($|/)\" \
            --collector.filesystem.ignored-fs-types=\"^(autofs|binfmt_misc|cgroup|configfs|debugfs|devpts|devtmpfs|fuse.*|hugetlbfs|mqueue|overlay|pstore|rpc_pipefs|securityfs|sysfs|tracefs)$\" \
            --collector.netdev.ignored-devices=\"^(lo|docker[0-9]|veth.+)$\" \
            --collector.cpu \
            --collector.cpufreq
            --collector.diskstats \
            --collector.filesystem \
            --collector.meminfo \
            --collector.netstat \
            --collector.tcpstat \
            --collector.ksmd \
            --collector.processes \
            --collector.stat \
            --no-collector.conntrack \
            --no-collector.filefd \
            --no-collector.loadavg \
            --no-collector.netdev \
            --no-collector.ntp \
            --no-collector.sockstat \
            --no-collector.textfile \
            --no-collector.time \
            --no-collector.uname \
            --no-collector.vmstat \
            --no-collector.arp \
            --no-collector.bcache \
            --no-collector.bonding \
            --no-collector.buddyinfo \
            --no-collector.drbd \
            --no-collector.edac \
            --no-collector.entropy \
            --no-collector.hwmon \
            --no-collector.infiniband \
            --no-collector.interrupts \
            --no-collector.ipvs \            
            --no-collector.logind \
            --no-collector.mdadm \
            --no-collector.meminfo_numa \
            --no-collector.mountstats \
            --no-collector.nfs \
            --no-collector.nfsd \
            --no-collector.qdisc \
            --no-collector.runit \
            --no-collector.supervisord \
            --no-collector.systemd \
            --no-collector.timex \
            --no-collector.wifi \
            --no-collector.xfs \
            --no-collector.zfs"
# Get Linux OS and Version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    OS=$(cat /etc/redhat-release | cut -d ' ' -f 1)
    VER=$(cat /etc/redhat-release | cut -d ' ' -f 3)
else
    # Fall back to uname, e.g. Linux <version>, also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

# For Amazon Linux or CentOS 6 or RHEL 6
if [[ $OS == *"Amazon"* ]]; then
    echo "Amazon Linux"
    OSCHECK=1
elif [[ $OS == *"CentOS"* ]] && [ ${VER:0:1} == "6" ]; then
    echo "CentOS 6"
    OSCHECK=1
elif [[ $OS == *"Red"* ]] && [ ${VER:0:1} == "6" ]; then
    "OSCHECK=1",
    echo "Red Hat 6"

# For CentOS 7 or RHEL 7
elif [[ $OS == *"CentOS"* ]] && [ ${VER:0:1} == "7" ]; then
    echo "CentOS 7"
    OSCHECK=2
elif [[ $OS == *"Red"* ]] && [ ${VER:0:1} == "7" ]; then
    echo "Red Hat 7"
    OSCHECK=2

# For Ubuntu 14 - Trusty
elif [[ $OS == *"Ubuntu"* ]] && [ ${VER:0:2} == "14" ]; then
    echo "Ubuntu 14 - Trusty"
    OSCHECK=3

# For Ubuntu 16 - Xenial
elif [[ $OS == *"Ubuntu"* ]] && [ ${VER:0:2} == "16" ]; then
    echo "Ubuntu 16 - Xenial"
    OSCHECK=4
else
    echo "Unsupported OS"
    OSCHECK=0
fi

case $OSCHECK in
     "1")
        # Amazon Linux 1 or CentOS 6 or RHEL 6
        set -x
        curl -SL -o /tmp/node_exporter.tar.gz ${base_url}/v${version}/node_exporter-${version}.${arch}.tar.gz
        file /tmp/node_exporter.tar.gz
        mkdir -p /tmp/node_exporter
        cd /tmp || { echo "ERROR! No /tmp found.."; exit 1; }
        tar xfz /tmp/node_exporter.tar.gz -C /tmp/node_exporter || { echo "ERROR! Extracting the node_exporter tar"; exit 1; }
        cp "/tmp/node_exporter/node_exporter-${version}.${arch}/node_exporter" "${bin_dir}"
        curl -SL -o /etc/init.d/node_exporter ${service_gist} 
        chmod +x /etc/init.d/node_exporter
        chkconfig node_exporter on
        service node_exporter start 
        service node_exporter status
        set +x
        ;;
     *)
        # Amazon Linux 2
        # CentOS 7 or RHEL 7
        # Ubuntu 14+ - Trusty
        # Ubuntu 16 - Xenial
        service_path="/etc/systemd/system/node_exporter.service"
        curl -SL -o /tmp/node_exporter.tar.gz ${base_url}/v${version}/node_exporter-${version}.${arch}.tar.gz
        file /tmp/node_exporter.tar.gz
        mkdir -p /tmp/node_exporter
        cd /tmp || { echo "ERROR! No /tmp found.."; exit 1; }
        tar xfzv /tmp/node_exporter.tar.gz -C /tmp/node_exporter || { echo "ERROR! Extracting the node_exporter tar"; exit 1; }
        cp "/tmp/node_exporter/node_exporter-${version}.${arch}/node_exporter" "${bin_dir}"
        if  pgrep -x "node_exporter" > /dev/null; then 
            echo "Node Exporter is running"
        else
            if [[ -f $service_path ]]; then 
                echo "Service file exist,so restart"
                systemctl restart node_exporter.service
            else 
                echo "Service doest no exit, create file, enable and start"
                {
                    echo "[Unit]";
                    echo "Description=Prometheus node exporter";
                    echo "After=local-fs.target network-online.target network.target";
                    echo "Wants=local-fs.target network-online.target network.target";
                    echo "[Service]";
                    echo "Type=simple";
                    echo "ExecStart=/usr/local/bin/node_exporter";
                    echo "[Install]";
                    echo "WantedBy=multi-user.target";
                } > ${service_path}
                systemctl enable node_exporter.service
                systemctl start node_exporter.service
            fi
        fi
        systemctl status node_exporter.service
        ;;
esac