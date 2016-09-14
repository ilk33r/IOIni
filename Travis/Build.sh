#!/bin/bash

#  Build.sh
#  IOIni
#
#  Created by ilker özcan on 21/08/16.
#

if [[ $TRAVIS_IMAGE == 'Docker' ]]; then

	if [[ $DOCKER_OS_RELEASE == 'Ubuntu_Trusty' ]]; then
		SWIFT_PATH='/usr/local/swift/swift-3.0-GM-CANDIDATE-ubuntu14.04/usr/bin'
	elif [[ $DOCKER_OS_RELEASE == 'Ubuntu_Wily' ]]; then
		SWIFT_PATH='/usr/local/swift/swift-3.0-GM-CANDIDATE-ubuntu15.10/usr/bin'
	else
		SWIFT_PATH='/usr/local/swift/bin'
	fi

	docker run -e "OS_RELEASE=${DOCKER_OS_RELEASE}" -e "PATH=${SWIFT_PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" -e "TRAVIS_COMMIT=${TRAVIS_COMMIT}" -e "TRAVIS_IMAGE=${TRAVIS_IMAGE}" ilk3r/iorunner:${DOCKER_IMAGE} /bin/bash -c "cd /root/ilk33r/IOIni/; make dist-clean; git reset --hard origin/master; git pull; make;"

else
	make dist-clean
	make
fi
