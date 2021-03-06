IMG_DIR = /mnt/sandbox/embed-me/EBAZ4205/poky/build/tmp/deploy/images/ebaz4205-zynq7
SYSROOT_DIR = /opt/ebaz4205-dist/1.0/sysroots/cortexa9t2hf-neon-poky-linux-gnueabi/
HOST_ADAPTER_TO_BRIDGE = ens38


help:
	@sed -e '/#\{2\}-/!d; s/\\$$//; s/:[^#\t]*/:/; s/#\{2\}- *//' $(MAKEFILE_LIST)


run_system:	##- Run the whole image in system-mode
	qemu-system-aarch64 \
		-machine xilinx-zynq-a9 \
		-m 256M \
		-nographic \
		-net nic,macaddr=02:f0:0d:ba:be:02 \
		-net tap,id=mybr0,ifname=tap0,script=no,downscript=no \
		-nographic \
		-serial null \
		-serial mon:stdio \
		-append 'root=/dev/root rw debugshell console=ttyS0 mem=256M console=ttyPS0,115200 earlyprintk ip=dhcp' \
		-kernel $(IMG_DIR)/uImage \
		-initrd $(IMG_DIR)/ebaz4205-image-standard-ebaz4205-zynq7-*.rootfs.cpio \
		-dtb $(IMG_DIR)/devicetree/ebaz4205-zynq7.dtb \
		-drive file=$(IMG_DIR)/ebaz4205-image-standard-wic-ebaz4205-zynq7.wic,if=sd,format=raw,index=0

run_app:	##- Run an single application in user-mode (eg. make APP=foo run_app)
	qemu-arm \
		-cpu cortex-a9 \
		-p 4k \
		-L $(SYSROOT_DIR) \
		$(APP)

net_prep:	##- Prepare a bridge and tap interface for the image run in system-mode
	sudo ip link add name br0 type bridge
	sudo ip tuntap add dev tap0 mode tap user $$(whoami)

	sudo ip link set dev $(HOST_ADAPTER_TO_BRIDGE) master br0
	sudo ip link set dev tap0 master br0

	sudo ip link set dev $(HOST_ADAPTER_TO_BRIDGE) up
	sudo ip link set dev br0 up
	sudo ip link set dev tap0 up

net_unprep:	##- Unprepare the interfaces generated with net_prepare
	sudo ip link set dev $(HOST_ADAPTER_TO_BRIDGE) nomaster
	sudo ip link set dev $(HOST_ADAPTER_TO_BRIDGE) down

	sudo ip link set dev tap0 down
	sudo ip link delete dev tap0

	sudo ip link set dev br0 down
	sudo ip link delete dev br0
