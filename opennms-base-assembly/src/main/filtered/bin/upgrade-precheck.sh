#!/bin/bash

OK=1

if [ ! -e "${install.etc.dir}/upgradewhilerunning" ]; then
	if [ -x /bin/systemctl ]; then
		if /bin/systemctl -q is-active opennms.service; then
			OK=0
		fi
	fi
	if [ -x /usr/sbin/service ]; then
		if /usr/sbin/service opennms status >/dev/null 2>&1; then
			OK=0
		fi
	fi
fi

if [ "$OK" -eq 0 ]; then
	echo "OpenNMS is running! Please stop OpenNMS before doing package changes."
	exit 1
fi

if [ "$OPENNMS_PRECHECK_BACK_UP_ETC" = 1 ] && [ -d "${install.share.dir}" ] && [ -d "${install.etc.dir}" ] && [ -e "${install.etc.dir}/service-configuration.xml" ]; then
	rsync -aqr --delete "${install.etc.dir}"/ "${install.share.dir}/etc-pre-upgrade/" || :
fi

exit 0
